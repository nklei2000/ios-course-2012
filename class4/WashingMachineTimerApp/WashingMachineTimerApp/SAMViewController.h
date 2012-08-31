//
//  SAMViewController.h
//  WashingMachineTimerApp
//
//  Created by Nam Kin Lei on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAMViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *startingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *remaindTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *finishTimeLabel;

@property (strong, nonatomic) IBOutlet UISlider *preWashingTimeSlider;
@property (strong, nonatomic) IBOutlet UISlider *mainWashingTimeSlider;
@property (strong, nonatomic) IBOutlet UISlider *changeWaterTimeSlider;
@property (strong, nonatomic) IBOutlet UISlider *flushWaterTimeSlider;
@property (strong, nonatomic) IBOutlet UILabel *preWashingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *mainWashingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *changeWaterTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *flushWaterTimeLabel;
- (IBAction)sliderValueChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *preWashingLight;
@property (strong, nonatomic) IBOutlet UIButton *mainWashingLight;
@property (strong, nonatomic) IBOutlet UIButton *changeWaterLight;
@property (strong, nonatomic) IBOutlet UIButton *flushWaterLight;
@property (strong, nonatomic) IBOutlet UIButton *finishWashingLight;


@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startupButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *resetButton;

- (IBAction)startupClicked:(id)sender;
- (IBAction)resetClicked:(id)sender;

@end
