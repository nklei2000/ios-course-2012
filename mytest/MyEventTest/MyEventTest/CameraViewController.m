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

@interface CameraViewController ()

@end

@implementation CameraViewController
@synthesize photoImageView;

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
    [self setPhotoImageView:nil];
    [self setFeaturesScrollView:nil];
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
    self.photoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
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
            
            [self markFaces:photoImageView];
            
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



- (void)markFaces:(UIImageView *)facePicture
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
    
    // we'll iterate through every detected face.  CIFaceFeature provides us
    // with the width for the entire face, and the coordinates of each eye
    // and the mouth if detected.  Also provided are BOOL's for the eye's and
    // mouth so we can check if they already exist.
    for(CIFaceFeature* faceFeature in features)
    {
        // get the width of the face
        CGFloat faceWidth = faceFeature.bounds.size.width;
        
        CGRect frame = faceFeature.bounds;
        // frame.origin.x = frame.origin.x - 50;
        
        // create a UIView using the bounds of the face
        UIView* faceView = [[UIView alloc] initWithFrame:frame];
        
        // add a border around the newly created UIView
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        
//        CGRect newBounds = CGRectMake(faceFeature.bounds.origin.x,
//                                      self.photoImageView.bounds.size.height - faceFeature.bounds.origin.y - faceFeature.bounds.size.height,
//                                      faceFeature.bounds.size.width,
//                                      faceFeature.bounds.size.height);
//        
//        NSLog(@"My view frame: %@", NSStringFromCGRect(newBounds));
        
        [self.photoImageView addSubview:faceView];
//        
//        UIImage *newImage = [facePicture.image subImageWithBounds:newBounds];
//        [featureFaces addObject:newImage];
        
        
        if(faceFeature.hasLeftEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.15, faceFeature.leftEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [leftEyeView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the leftEyeView based on the face
            [leftEyeView setCenter:faceFeature.leftEyePosition];
            // round the corners
            leftEyeView.layer.cornerRadius = faceWidth*0.15;
            // add the view to the window
            [self.photoImageView addSubview:leftEyeView];
        }
        
        if(faceFeature.hasRightEyePosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* leftEye = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.15, faceFeature.rightEyePosition.y-faceWidth*0.15, faceWidth*0.3, faceWidth*0.3)];
            // change the background color of the eye view
            [leftEye setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.3]];
            // set the position of the rightEyeView based on the face
            [leftEye setCenter:faceFeature.rightEyePosition];
            // round the corners
            leftEye.layer.cornerRadius = faceWidth*0.15;
            // add the new view to the window
            [self.photoImageView addSubview:leftEye];
        }
        
        if(faceFeature.hasMouthPosition)
        {
            // create a UIView with a size based on the width of the face
            UIView* mouth = [[UIView alloc] initWithFrame:CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.2, faceFeature.mouthPosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4)];
            // change the background color for the mouth to green
            [mouth setBackgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.3]];
            // set the position of the mouthView based on the face
            [mouth setCenter:faceFeature.mouthPosition];
            // round the corners
            mouth.layer.cornerRadius = faceWidth*0.2;
            // add the new view to the window
            [self.photoImageView addSubview:mouth];
        }
        
        // [featureFaces addObject:newImage];
    }
    
    [self showFaces:featureFaces];
    
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


@end
