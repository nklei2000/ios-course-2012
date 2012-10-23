//
//  CameraViewController.m
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/19/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

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
@synthesize featuresTbl;

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
    
    [self.featuresTbl registerNib:[UINib nibWithNibName:@"FaceTableViewCell" bundle:nil] forCellReuseIdentifier:CustomCellIdentifier];
    
    featureFaces = [[NSMutableArray alloc] init];
    
    
    
}

- (void)viewDidUnload
{
    [self setPhotoImageView:nil];
    [self setFeaturesTbl:nil];
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
    
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)detect:(NSTimer *)timer
{
    ciImage = helper.ciImage;
    UIImage *baseImage = [UIImage imageWithCIImage:ciImage];
    CGRect imageRect = (CGRect){.size = baseImage.size};
    
    self.photoImageView.image = baseImage;
    
    NSDictionary *detectorOptions = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
                           
    ExifOrientation detectOrientation = detectorEXIF(helper.isUsingFrontCamera, NO);
    
    NSDictionary *imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:detectOrientation] forKey:CIDetectorImageOrientation];
    
    NSArray *features = [detector featuresInImage:ciImage options:imageOptions];
    
    if ( !features.count ) return;
    
    // CIFaceFeature *feature = [features lastObject];
    [featureFaces removeAllObjects];
    [self.featuresTbl reloadData];
    
    for (CIFaceFeature *feature in features)
    {
        CGRect rect = rectInEXIF(detectOrientation, feature.bounds, imageRect);
        
        CGPoint center = CGRectGetCenter(rect);
        CGFloat width = rect.size.width * 1.1f;
        CGFloat height = rect.size.height * 1.1f;
        
        CGRect newRect = CGRectAroundCenter(center, width, height);
        
        UIImage *newImage = [baseImage subImageWithBounds:newRect];
        [featureFaces addObject:newImage];
    }
    
    [self.featuresTbl reloadData];
    
    // UIImage *newImage = baseImage;
    // photoImageView.image = newImage;
    
    
}

- (IBAction)detectFace:(id)sender {
    
    
    helper = [CameraImageHelper helperWithCamera:kCameraFront];
    [helper startRunningSession];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(detect:) userInfo:nil repeats:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog( @"didFinishPickingMediaWithInfo..." );
    
    if (IS_IPHONE)
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if ( image != nil)
            photoImageView.image = image;
        
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


#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [featureFaces count];
}

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


@end
