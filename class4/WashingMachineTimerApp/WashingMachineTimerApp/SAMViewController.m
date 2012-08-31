//
//  SAMViewController.m
//  WashingMachineTimerApp
//
//  Created by Nam Kin Lei on 8/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SAMViewController.h"

@interface SAMViewController ()
- (void)initWashingMachine;
- (void)startWashingMachine;
- (void)resetWashingMachine;

- (void)initIndicatorLights;
- (void)resetIndicatorLights;
- (void)shiftIndicatorLight:(NSInteger)index;

- (NSString *)getCurrentDateTime;

- (void)stopWashingTimer;
- (void)alert:(NSString*)message;

@end

@implementation SAMViewController {
    float preWashingTime;
    float mainWashingTime;
    float changeWaterTime;
    float flushWaterTime;
    
    float totalWashingTime;
    float remaindWashingTime;
    
    NSMutableArray *indicatorLightArray;
    int currentLightIndex;

    NSTimer *washingTimer;
}

@synthesize preWashingLight;
@synthesize mainWashingLight;
@synthesize changeWaterLight;
@synthesize flushWaterLight;
@synthesize finishWashingLight;
@synthesize toolBar;
@synthesize startupButton;
@synthesize resetButton;
@synthesize startingTimeLabel;
@synthesize totalTimeLabel;
@synthesize remaindTimeLabel;
@synthesize finishTimeLabel;
@synthesize preWashingTimeSlider;
@synthesize mainWashingTimeSlider;
@synthesize changeWaterTimeSlider;
@synthesize flushWaterTimeSlider;
@synthesize preWashingTimeLabel;
@synthesize mainWashingTimeLabel;
@synthesize changeWaterTimeLabel;
@synthesize flushWaterTimeLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initWashingMachine];
}

- (void)viewDidUnload
{
    [self setTotalTimeLabel:nil];
    [self setRemaindTimeLabel:nil];
    [self setPreWashingTimeSlider:nil];
    [self setMainWashingTimeSlider:nil];
    [self setChangeWaterTimeSlider:nil];
    [self setFlushWaterTimeSlider:nil];
    [self setPreWashingTimeLabel:nil];
    [self setMainWashingTimeLabel:nil];
    [self setChangeWaterTimeLabel:nil];
    [self setFlushWaterTimeLabel:nil];
    [self setPreWashingLight:nil];
    [self setMainWashingLight:nil];
    [self setChangeWaterLight:nil];
    [self setFlushWaterLight:nil];
    [self setFinishWashingLight:nil];
    [self setStartingTimeLabel:nil];
    [self setFinishTimeLabel:nil];
    [self setToolBar:nil];
    [self setStartupButton:nil];
    [self setResetButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)sliderValueChanged:(id)sender {
    float value = [(UISlider*)sender value];
    
    UISlider *slider = (UISlider*)sender;
    
    switch (slider.tag) {
        case 0: // preWashingTimeSlider
            preWashingTime = value;
            preWashingTimeLabel.text = [NSString stringWithFormat:@"%.0f", value];
            break;
        case 1: // mainWashingTimeSlider
            mainWashingTime = value;
            mainWashingTimeLabel.text = [NSString stringWithFormat:@"%.0f", value];
            break;
        case 2: // changeWaterTimeSlider
            changeWaterTime = value;
            changeWaterTimeLabel.text = [NSString stringWithFormat:@"%.0f", value];
            break;
        case 3: // flushWaterTimeSlider
            flushWaterTime = value;
            flushWaterTimeLabel.text = [NSString stringWithFormat:@"%.0f", value];            
            break;
        default:
            break;            
    }
    
}

- (void)initWashingMachine 
{
    totalWashingTime = 0.0;
    
    preWashingTime = preWashingTimeSlider.value;
    mainWashingTime = mainWashingTimeSlider.value;
    changeWaterTime = changeWaterTimeSlider.value;
    flushWaterTime = flushWaterTimeSlider.value;
    
    [self stopWashingTimer];
    
    [self initIndicatorLights];
    [self resetIndicatorLights];
    
}

- (void)initIndicatorLights
{
    indicatorLightArray = [NSMutableArray arrayWithCapacity:5]; 

    [indicatorLightArray addObject:preWashingLight];
    [indicatorLightArray addObject:mainWashingLight];
    [indicatorLightArray addObject:changeWaterLight];
    [indicatorLightArray addObject:flushWaterLight];
    [indicatorLightArray addObject:finishWashingLight];
    
}

- (void)resetIndicatorLights
{   
    if ( indicatorLightArray != NULL && indicatorLightArray.count > 0)
    {
        for (int i=0; i<5; i++) {
            UIButton *button = [indicatorLightArray objectAtIndex:i];
            if (button != NULL) {
                //button.backgroundColor = [UIColor yellowColor];
                [button setBackgroundImage:[UIImage imageNamed:@"yellow_light.png"]
                                  forState:UIControlStateNormal];
            }
        }
    }
    
}

- (void)shiftIndicatorLight:(NSInteger)index
{
    [self resetIndicatorLights];
    if ( currentLightIndex < indicatorLightArray.count )
    {
        UIButton *light = [indicatorLightArray objectAtIndex:currentLightIndex];
        // light.backgroundColor = [UIColor blueColor];
        [light setBackgroundImage:[UIImage imageNamed:@"green_light.png"]
                         forState:UIControlStateNormal];
    }
}

- (void)startWashingMachine 
{
    preWashingTimeSlider.enabled=FALSE;
    mainWashingTimeSlider.enabled=FALSE;
    changeWaterTimeSlider.enabled=FALSE;
    flushWaterTimeSlider.enabled=FALSE; 
    
    totalWashingTime = preWashingTime + mainWashingTime + changeWaterTime + flushWaterTime;

    remaindWashingTime = totalWashingTime; 

    if ( totalWashingTime <= 0.0 ) {
        NSLog(@"No need to startup the washing machine");
        [self alert:@"洗衣程序不能啟動，請設定洗衣時間。"];
        return;
    }
        
    startingTimeLabel.text = [self getCurrentDateTime];             
    
    currentLightIndex = 0;
    if ( preWashingTime == 0.0 ) 
        currentLightIndex = 1;
    
    if ( (preWashingTime+mainWashingTime) == 0.0 )
        currentLightIndex = 2;

    if ( (preWashingTime+mainWashingTime+changeWaterTime) == 0.0 )
        currentLightIndex = 3;
    
    if ( (preWashingTime+mainWashingTime+changeWaterTime+flushWaterTime) == 0.0 )
        currentLightIndex = 4;
        
    // Shift to the indicator light
    [self shiftIndicatorLight:currentLightIndex];
    
    // Update time remainding label
    [self refreshTimeCountingLabels];    
    
    if ( totalWashingTime > 0.0 ) 
    {
        washingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f 
                target:self
                selector:@selector(updateCounter:)
                userInfo:nil
                repeats:YES];
    }
}

- (NSString*) getCurrentDateTime
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd HH:mm"];   

    NSString *text = [formatter stringFromDate:date];
    
    return text;
}

- (void)refreshTimeCountingLabels
{
    int totalHours = totalWashingTime/60.0f;
    int totalMins = (int)totalWashingTime - (totalHours*60);
    
    int remaindHours = remaindWashingTime/60.0f;
    int remaindMins = (int)remaindWashingTime - (remaindHours*60);
    
    NSLog(@"refreshTimeCountingLabels[totalWashingTime: %.0f, remaindWashingTime: %.0f]", totalWashingTime, remaindWashingTime);
    NSLog(@"totalHours: %i, totalMins: %i]", totalHours, totalMins);
    NSLog(@"remaindHours: %i, remaindMins: %i]", remaindHours, remaindMins);
    
    // Show hour and minute
    if ( totalHours > 0 ) 
    {
        totalTimeLabel.text = [NSString stringWithFormat:@"%i 小時 %i 分鐘", totalHours, totalMins];
        remaindTimeLabel.text = [NSString stringWithFormat:@"%i 小時 %i 分鐘", remaindHours, remaindMins];
    }
    // Show minute only
    else 
    {
        totalTimeLabel.text = [NSString stringWithFormat:@"%i 分鐘",  totalMins];        
        remaindTimeLabel.text = [NSString stringWithFormat:@"%i 分鐘",  remaindMins];
    }
}


- (void)updateCounter:(NSTimer*)theTimer 
{
    static int counter;    
    counter++;

    if ( remaindWashingTime > 0.0 ) {
        remaindWashingTime--;
    }
    
    NSLog(@"counter: %i, timeLeft: %.0f", counter, remaindWashingTime);
    
    BOOL isChangeLight = FALSE;
    
    if ( currentLightIndex == 0 && counter > preWashingTime )
    {
        currentLightIndex++;
        isChangeLight = TRUE; 
    }
    
    if ( currentLightIndex == 1 && counter > (preWashingTime+mainWashingTime) ) 
    {   
        currentLightIndex++;
        isChangeLight = TRUE;
    }
    
    if ( currentLightIndex == 2 && counter > (preWashingTime+mainWashingTime+changeWaterTime) )
    {
        currentLightIndex++;
        isChangeLight = TRUE;
    }
    
    if ( currentLightIndex == 3 && counter > (preWashingTime+mainWashingTime+changeWaterTime+flushWaterTime) )
    {
        currentLightIndex++;
        isChangeLight = TRUE;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.6f];
    
    if ( isChangeLight ) 
    {
        [self shiftIndicatorLight:currentLightIndex];
    }
    
    // Update time remainding label
    [self refreshTimeCountingLabels];
    
    [UIView commitAnimations];
    
    if ( remaindWashingTime <= 0 )
    {        
        finishTimeLabel.text = [self getCurrentDateTime];
        
        counter = 0;
        
        NSLog(@"Finished Washing, please hang up your clothes!"); 
        // Popup Alert
        [self alert:@"完成洗衣程序，請掠衣服。"];
        
        // Stop timer
        [self stopWashingTimer];
    }
    
}

- (void)resetWashingMachine 
{
    preWashingTimeSlider.enabled=TRUE;
    mainWashingTimeSlider.enabled=TRUE;
    changeWaterTimeSlider.enabled=TRUE;
    flushWaterTimeSlider.enabled=TRUE;    
    
    [self stopWashingTimer];
}

- (void)stopWashingTimer
{
    if ( washingTimer != NULL ) 
    {
        [washingTimer invalidate];
        washingTimer = nil;
    }    
}

- (IBAction)startupClicked:(id)sender {
    [self startWashingMachine];
    startupButton.enabled = FALSE;
}

- (IBAction)resetClicked:(id)sender {
    [self resetWashingMachine];
    startupButton.enabled = TRUE;    
}

- (void)alert:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"訊息"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"關閉"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
