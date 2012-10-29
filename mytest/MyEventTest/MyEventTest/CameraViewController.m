//
//  CameraViewController.m
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/19/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "CameraViewController.h"

#import "CameraImageHelper.h"
#import "exifGeometry.h"
#import "UIImage-Utilities.h"
#import "Orientation.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IMG_WIDTH 640.0f
#define IMG_HEIGHT 480.0f

@interface CameraViewController ()

@end

@implementation CameraViewController

static NSString *CustomCellIdentifier = @"CustomCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    featureFaces = [[NSMutableArray alloc] init];
    
    self.featuresScrollView.backgroundColor = [UIColor grayColor];
    self.imageScrollView.backgroundColor = [UIColor grayColor];
    
    photoImageView = [[UIImageView alloc] init];
    photoImageView.contentMode = UIViewContentModeTopLeft;
    
    CGRect viewRect = CGRectMake(0, 0, IMG_WIDTH, IMG_HEIGHT);
    
    photoImageView.frame = viewRect;
	self.imageScrollView.contentSize = CGSizeMake(viewRect.size.width, viewRect.size.height);
    self.imageScrollView.contentMode = UIViewContentModeTopLeft;
    [self.imageScrollView addSubview:photoImageView];
    
    if ( [CameraImageHelper numberOfCameras] > 1 )
    {
        UIBarButtonItem *leftbarItem = [[UIBarButtonItem alloc] initWithTitle:@"Switch" style:UIBarButtonItemStylePlain target:self action:@selector(switchCamera:)];
                                        
        self.navigationItem.leftBarButtonItem = leftbarItem;
        
        UIBarButtonItem *rightbarItem = [[UIBarButtonItem alloc] initWithTitle:@"Process" style:UIBarButtonItemStylePlain target:self action:@selector(processImage:)];
        
        self.navigationItem.rightBarButtonItem = rightbarItem;
    }
}

- (void)switchCamera:(id)sender
{
    [helper switchCameras];
}

- (void)processImage:(id)sender
{

}

- (void)viewDidUnload
{
    [self setFeaturesScrollView:nil];
    [self setImageScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)showCamera:(id)sender
{
     NSLog(@"Show Camera");
    
#if !TARGET_IPHONE_SIMULATOR
    if ( imagePickerController == nil ) {
        imagePickerController = [[UIImagePickerController alloc] init];
    }
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing = YES;
    
    [self presentModalViewController:imagePickerController animated:YES];
#endif
    
#if TARGET_IPHONE_SIMULATOR

    NSLog(@"iPhone simulator doesn't have camera");
    
#endif
    
}

- (IBAction)pickPhoto:(id)sender
{
    NSLog(@"Show Camera");

    if ( imagePickerController == nil ) {
        imagePickerController = [[UIImagePickerController alloc] init];
    }
    
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    
    [self presentModalViewController:imagePickerController animated:YES];

}

- (IBAction)dismiss:(id)sender
{
    
    //[self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)extractFaces:(NSTimer *)timer
{
    UIImageOrientation imageOrientation = currentImageOrientation(helper.isUsingFrontCamera, NO);
    
    ciImage = helper.ciImage;
    UIImage *baseImage = [UIImage imageWithCIImage:ciImage orientation:imageOrientation];
    CGRect imageRect = (CGRect){.size = baseImage.size};
    
    
    
    NSDictionary *detectorOptions = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
                           
    ExifOrientation detectOrientation = detectorEXIF(helper.isUsingFrontCamera, NO);
    
    NSDictionary *imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:detectOrientation] forKey:CIDetectorImageOrientation];
    
    NSArray *features = [detector featuresInImage:ciImage options:imageOptions];
    
    if ( !features.count ) return;
    
    // CIFaceFeature *feature = [features lastObject];
    [featureFaces removeAllObjects];
    // [self.featuresTbl reloadData];
    
    UIGraphicsBeginImageContext(baseImage.size);
    [baseImage drawInRect:imageRect];
    
    for (CIFaceFeature *feature in features)
    {
        NSLog(@"feature: width=%.0f, height=%.0f ## base width=%.0f, height=%.0f", feature.bounds.size.width, feature.bounds.size.height, imageRect.size.width, imageRect.size.height);
        
        CGRect rect = rectInEXIF(detectOrientation, feature.bounds, imageRect);
        if ( deviceIsPortrait() && helper.isUsingFrontCamera)
        {
            rect.origin = CGPointFlipHorizontal(rect.origin, imageRect);
            rect.origin = CGPointOffset(rect.origin, -rect.size.width, 0.0f);
        }
        
        [[[UIColor greenColor] colorWithAlphaComponent:0.3f] set];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        [path fill];
        

        CGPoint center = CGRectGetCenter(rect);
        CGFloat width = rect.size.width * 1.05f;
        CGFloat height = rect.size.height * 1.05f;
        
        CGRect newRect = CGRectAroundCenter(center, width, height);
        
        UIImage *newImage = [baseImage subImageWithBounds:newRect];
        [featureFaces addObject:newImage];
        
    }
    
    // self.photoImageView.image = baseImage;
    photoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self showFaces:featureFaces];
    
    // [self.featuresTbl reloadData];
    
    // UIImage *newImage = baseImage;
    // photoImageView.image = newImage;
    
}

- (void)showFaces:(NSArray*)faces
{
    NSLog(@"Removing %d subviews", [self.featuresScrollView.subviews count]);
    
    for (int i = 0; i < [self.featuresScrollView.subviews count]; i++)
    {
        UIImageView *subview = [self.featuresScrollView.subviews objectAtIndex:i];
        [subview removeFromSuperview];
        subview = nil;
    }
    
    NSLog(@"Adding %d subviews", [faces count]);
    for (int i=0; i < [faces count]; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[faces objectAtIndex:i]];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        CGRect frame = imageView.frame;
        frame.origin.x = 100 * i;
        frame.origin.y = 1.0f;
        frame.size.width = 100.0f;
        frame.size.height = 100.0f;
        
        imageView.frame = frame;
        
        [self.featuresScrollView addSubview:imageView];
    }
}

- (IBAction)detectFace:(id)sender
{
    helper = [CameraImageHelper helperWithCamera:kCameraFront];
    [helper startRunningSession];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(extractFaces:) userInfo:nil repeats:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog( @"didFinishPickingMediaWithInfo..." );
    
    if (IS_IPHONE)
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if ( image != nil)
        {
            photoImageView.image = image;
            
            NSLog(@"image size (%.0f, %.0f)", image.size.width, image.size.height);
            
            CGRect viewRect = CGRectMake(0, 0, IMG_WIDTH, IMG_HEIGHT);
            photoImageView.frame = viewRect;
            
            self.imageScrollView.contentSize = CGSizeMake(IMG_WIDTH, IMG_HEIGHT);
            
            [self markFaces:photoImageView forFaceImage:image];
            
        }
        
        [picker dismissModalViewControllerAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog( @"imagePickerControllerDidCancel..." );
    
    [picker dismissModalViewControllerAnimated:YES];
}

/*
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog( @"popoverControllerDidDismissPopover..." );
    
    [popoverController dismissPopoverAnimated:YES];

}
*/


/*
 - (void) snap: (NSTimer *) timer
 {
 UIImageOrientation imageOrientation = currentImageOrientation(helper.isUsingFrontCamera, NO);
 
 ciImage = helper.ciImage;
 UIImage *baseImage = [UIImage imageWithCIImage:ciImage orientation:imageOrientation];
 CGRect imageRect = (CGRect){.size = baseImage.size};
 
 NSDictionary *detectorOptions = [NSDictionary dictionaryWithObject:CIDetectorAccuracyLow forKey:CIDetectorAccuracy];
 
 CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
 
 ExifOrientation detectOrientation = detectorEXIF(helper.isUsingFrontCamera, NO);
 NSLog(@"Current orientation: %@", exifOrientationNameFromOrientation(detectOrientation));
 
 NSDictionary *imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:detectOrientation] forKey:CIDetectorImageOrientation];
 NSArray *features = [detector featuresInImage:ciImage options:imageOptions];
 if (!features.count) return;
 CIFaceFeature *feature = [features lastObject]; // only one at a time
 
 CGRect rect = rectInEXIF(detectOrientation, feature.bounds, imageRect);
 if (deviceIsPortrait() && helper.isUsingFrontCamera) // workaround
 {
 rect.origin = CGPointFlipHorizontal(rect.origin, imageRect);
 rect.origin = CGPointOffset(rect.origin, -rect.size.width, 0.0f);
 }
 
 // Expand by about 10%
 CGPoint center = CGRectGetCenter(rect);
 CGFloat width = rect.size.width * 1.1f;
 CGFloat height = rect.size.height * 1.1f;
 CGRect newRect = CGRectAroundCenter(center, width / 2.0f, height / 2.0f);
 
 UIImage *newImage = [baseImage subImageWithBounds:newRect];
 imageView.image = newImage;
 }

*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // static NSString *CellIdentifier = @"CustomCell";
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UIImage *theImage = (UIImage *)[featureFaces objectAtIndex:indexPath.row];
    
    UIImageView *featureImageView = (UIImageView*)[cell viewWithTag:1001];
    if (featureImageView != nil)
        featureImageView.image = theImage;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
*/



- (void)markFaces:(UIImageView *)facePicture forFaceImage:(UIImage *)faceImage;
{
    // draw a CI image with the previously loaded face detection picture
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];

    // create a face detector - since speed is not an issue we'll use a high accuracy
    // detector
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    // create an array containing all the detected faces from the detector
    NSArray* features = [detector featuresInImage:image];
    
    NSLog(@"features count: %d", [features count]);
    
    [featureFaces removeAllObjects];
    
    
    // UIImage *faceImage = facePicture.image;
    UIGraphicsBeginImageContextWithOptions(faceImage.size, YES, 0);
    CGRect rect = CGRectMake(facePicture.bounds.origin.x, facePicture.bounds.origin.y, facePicture.bounds.size.width, facePicture.bounds.size.height);
    [faceImage drawInRect:rect];
    
    NSLog(@"Face image size (%.0f, %.0f)", faceImage.size.width, faceImage.size.height);
    NSLog(@"Face image view size(%.0f, %.0f), origin (%.0f, %.0f)", facePicture.bounds.size.width, facePicture.bounds.size.height,
          facePicture.bounds.origin.x, facePicture.bounds.origin.y);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);

    CGFloat scale = [UIScreen mainScreen].scale;
    if ( scale > 1.0 )
    {
        CGContextScaleCTM(context, 0.5, 0.5);
    }

    NSLog(@"scale: %.2f", scale);
    
    
    // we'll iterate through every detected face.  CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected.  Also provided are BOOL's for the eye's and
    // mouth so we can check if they already exist.
    int i = 1;
    for(CIFaceFeature* feature in features)
    {
        NSLog(@"face feature %d size (%.f, %.f) origin (%.f, %.f)",
              i,
              feature.bounds.size.width,
              feature.bounds.size.height,
              feature.bounds.origin.x,
              feature.bounds.origin.y);
        ++i;
        
        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 2.0f * scale);
        CGContextAddRect(context, feature.bounds);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        
        CGContextSetRGBFillColor(context, 1.0f, 0.0f, 0.0f, 0.4f);
        if(feature.hasLeftEyePosition)
        {
            // [self drawFeatureInContext:context atPoint:faceFeature.leftEyePosition];
        }
        
        if(feature.hasRightEyePosition)
        {
            // [self drawFeatureInContext:context atPoint:faceFeature.rightEyePosition];
        }
        
        if(feature.hasMouthPosition)
        {
            // [self drawFeatureInContext:context atPoint:faceFeature.mouthPosition];
        }
        
        // [featureFaces addObject:newImage];
    }
    
    facePicture.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    [self.imageScrollView setScrollEnabled:YES];
    
    //[self showFaces:featureFaces];
    
}

-(void)faceDetector
{
    // Load the picture for face detection
    UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jolie.jpg"]];
    
    // Draw the face detection image
    [self.view addSubview:image];
    
    // flip image on y-axis to match coordinate system used by core image
    [image setTransform:CGAffineTransformMakeScale(1, -1)];
    
    // flip the entire window to make everything right side up
    [self.view setTransform:CGAffineTransformMakeScale(1, -1)];
    
    // Execute the method used to markFaces in background
    [self performSelectorInBackground:@selector(markFaces:) withObject:image];
}

- (void)drawFeatureInContext:(CGContextRef)context atPoint:(CGPoint)featurePoint {
    CGFloat radius = 20.0f * [UIScreen mainScreen].scale;
    CGContextAddArc(context, featurePoint.x, featurePoint.y, radius, 0, M_PI * 2, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
