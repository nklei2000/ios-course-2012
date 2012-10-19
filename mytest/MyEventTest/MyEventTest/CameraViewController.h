//
//  CameraViewController.h
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/19/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController
- (IBAction)showCamera:(id)sender;
- (IBAction)pickPhoto:(id)sender;
- (IBAction)dismiss:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@end
