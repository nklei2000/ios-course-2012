//
//  CameraViewController.h
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/19/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraImageHelper;

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePickerController;
    CameraImageHelper *helper;
    CIImage *ciImage;
}

- (IBAction)showCamera:(id)sender;
- (IBAction)pickPhoto:(id)sender;
- (IBAction)dismiss:(id)sender;

- (IBAction)detectFace:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@end
