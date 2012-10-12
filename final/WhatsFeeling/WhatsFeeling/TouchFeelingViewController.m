//
//  TouchFeelingViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/12/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "TouchFeelingViewController.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"

#import "DataModel.h"
#import "Feeling.h"

#import "MyCommon.h"

@interface TouchFeelingViewController ()

@end

@implementation TouchFeelingViewController

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendTouchFeeling)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSendTouchFeeling)];
    
    // Change backgroud size: 320x460(480)
    self.view.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-touch.png"]]];
    
    // add gesture recognizers to the image view
    UITapGestureRecognizer *onePointTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOnePointTap:)];
    UITapGestureRecognizer *twoPointTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoPointTap:)];
    UITapGestureRecognizer *threePointTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleThreePointTap:)];
    UITapGestureRecognizer *fourPointTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFourPointTap:)];
    UITapGestureRecognizer *fivePointTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFivePointTap:)];
    
    [onePointTap setNumberOfTouchesRequired:1];
    [twoPointTap setNumberOfTouchesRequired:2];
    [threePointTap setNumberOfTouchesRequired:3];
    [fourPointTap setNumberOfTouchesRequired:4];
    [fivePointTap setNumberOfTouchesRequired:5];
    
    [self.view addGestureRecognizer:onePointTap];
    [self.view addGestureRecognizer:twoPointTap];
    [self.view addGestureRecognizer:threePointTap];
    [self.view addGestureRecognizer:fourPointTap];
    [self.view addGestureRecognizer:fivePointTap];
    
    self.touchFeeling = [[Feeling alloc] init];
    self.touchFeeling.type = @"TOUCH";
    
    self.title = @"Touch me";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark TapDetectingImageViewDelegate methods

- (void)handleOnePointTap:(UIGestureRecognizer *)gestureRecognizer
{
    // one point tap
    self.title = @"Touch face";
    // self.touchFeeling.touchAction = @"TOUCHFACE";
    NSLog(@"One point: Touch Face");
}

- (void)handleTwoPointTap:(UIGestureRecognizer *)gestureRecognizer {
    // two point tap
    self.title = @"Kiss";
    // self.touchFeeling.touchAction = @"KISS";
    NSLog(@"Kiss");
}

- (void)handleThreePointTap:(UIGestureRecognizer *)gestureRecognizer
{
    // three-point tap
    self.title = @"Hug";
    self.touchFeeling.touchAction = @"HUG";
    NSLog(@"Hug");
}

- (void)handleFourPointTap:(UIGestureRecognizer *)gestureRecognizer
{
    // four-point
    self.title = @"Punch";
    self.touchFeeling.touchAction = @"PUNCH";
    NSLog(@"Punch");
}

- (void)handleFivePointTap:(UIGestureRecognizer *)gestureRecognizer
{
    // five-point
    self.title = @"Hug and Kiss";
    self.touchFeeling.touchAction = @"HUG-KISS";
    NSLog(@"Hug");
}

//- (void)handleSixPointTap:(UIGestureRecognizer *)gestureRecognizer
//{
//    // six-point
//    self.title = @"Hug and Kiss";
//    self.touchFeeling.touchAction = @"HUG-KISS";
//    NSLog(@"Hug");
//}

- (void)touchFeelingDidSend:(Feeling*)feeling
{
    NSLog(@"User did show.");
    
	// Add the Message to the data model's list of messages
	int index = [self.dataModel addFeeling:feeling];
    
    [self.delegate didTouchFeeling:feeling atIndex:index];
        
    [self dismissModalViewControllerAnimated:YES];
}


- (void)cancelSendTouchFeeling
{
    NSLog(@"Cancelled send feeling...");
    
//    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SelectedFeelingStatusKey"];
//    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"SelectedFeelingStatusValue"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
        
    [self dismissModalViewControllerAnimated:YES];
}


- (void)sendTouchFeeling
{
    NSLog(@"Sending feeling to your friends...");
    
    Feeling *feeling = [[Feeling alloc] init];
    
    feeling.type = @"TOUCH";
    feeling.text = @"KISS";
    
    if ( feeling.text.length == 0 )
    {
        [MyCommon ShowErrorAlert:@"Please choose your feeling"];
        return;
    }
    
    [self touchFeelingRequest:feeling];
    
}

- (void)touchFeelingRequest:(Feeling *)feeling
{
    if ( feeling == nil || feeling.text.length == 0)
    {
        [MyCommon ShowErrorAlert:NSLocalizedString(@"NOTHING_SENT", nil)];
        return;
    }
    
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Sending", nil);
        
    NSLog(@"feeling action: %@, udid: %@", feeling.text, [self.dataModel udid]);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"touchfeeling", @"cmd",
                            [self.dataModel udid], @"udid",
                            feeling.text, @"text",
                            nil];
    NSLog(@"%@", params);
    
    NSURL *url = [NSURL URLWithString:@"http://samlei.site88.net"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    [httpClient postPath:@"/api.php" parameters:params
                 success:^(AFHTTPRequestOperation *operation, id response)
     {
         NSString *text = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
         NSLog(@"Response: %@", text);
         if ([self isViewLoaded])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             NSLog(@"%@", @"user did show");
             [self touchFeelingDidSend:feeling];
         }
     }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", [error localizedDescription]);
         if ([self isViewLoaded])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MyCommon ShowErrorAlert:[error localizedDescription]];
         }
     }];
}

@end
