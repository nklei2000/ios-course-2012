//
//  MyInfoViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/5/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "MyInfoViewController.h"
#import "LoginViewController.h"

#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"

#import "DataModel.h"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"My Info", @"My Info");
        self.tabBarItem.image = [UIImage imageNamed:@"gear"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)leave:(id)sender {
    [self postLeaveRequest];
}

- (void)userDidLeave
{
    NSLog(@"Entered UserDidLeave!");
    
    [self.dataModel setJoined:NO];
    
    NSLog(@"Popup Login Screen");
    // Popup login screen
    LoginViewController *loginViewController = [[LoginViewController alloc]
        initWithNibName:@"LoginViewController" bundle:nil];
    loginViewController.dataModel = self.dataModel;
    
    [self.parentViewController presentModalViewController:loginViewController animated:NO];
    
}

- (void)postLeaveRequest
{
    NSLog(@"Posting leave request");
    
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Leave", nil);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"leave", @"cmd",
                            [self.dataModel udid], @"udid",
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
             
             NSLog(@"%@", @"user did leave");
             [self userDidLeave];
         }
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", [error localizedDescription]);
         if ([self isViewLoaded])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [self ShowErrorAlert:[error localizedDescription]];
         }
     }];
    
}

- (void)ShowErrorAlert:(NSString*)text
{
	UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:text
                              message:nil
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
    
	[alertView show];
}

@end
