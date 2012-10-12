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

#import "MyCommon.h"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController
@synthesize myInfoNavigationBar;
@synthesize udidLabel;
@synthesize deviceTokenLabel;
@synthesize nameLabel;


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
    
    self.nameLabel.text = self.dataModel.nickname;
    self.deviceTokenLabel.text = self.dataModel.deviceToken;
    self.udidLabel.text = self.dataModel.udid;
    
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setDeviceTokenLabel:nil];
    [self setUdidLabel:nil];
    [self setMyInfoNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)signOut:(id)sender {
    [self postSignOutRequest];
}

- (IBAction)deleteAccount:(id)sender {
    [self postUnregisterRequest];
}

- (void)userDidSignOut
{
    NSLog(@"Entered userDidSignOut!");
    
    [self.dataModel setJoined:NO];
    
    NSLog(@"Popup Login Screen");
    
    // Popup login screen
    LoginViewController *loginViewController = [[LoginViewController alloc]
        initWithNibName:@"LoginViewController" bundle:nil];
    loginViewController.dataModel = self.dataModel;
    
    [self.parentViewController presentModalViewController:loginViewController animated:NO];
    
}

- (void)userDidUnregister
{
    NSLog(@"Entered userDidUnregister!");
    
    [self.dataModel setJoined:NO];
    
    NSLog(@"Popup Login Screen");
    
    // Popup login screen
    LoginViewController *loginViewController = [[LoginViewController alloc]
                                                initWithNibName:@"LoginViewController" bundle:nil];
    loginViewController.dataModel = self.dataModel;
    
    [self.parentViewController presentModalViewController:loginViewController animated:NO];
    
}

- (void)postSignOutRequest
{
    NSLog(@"Posting sign out request");
    
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"signout", nil);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"signout", @"cmd",
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
             
             NSLog(@"%@", @"user did sign out");
             [self userDidSignOut];
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

- (void)postUnregisterRequest
{
    NSLog(@"Posting unregister request");
    
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"signout", nil);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"unregistered", @"cmd",
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
             
             NSLog(@"%@", @"user did unregister");
             [self userDidUnregister];
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
