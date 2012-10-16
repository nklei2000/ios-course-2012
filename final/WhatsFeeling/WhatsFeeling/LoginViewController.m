//
//  LoginViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/8/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.

#import "LoginViewController.h"
#import "SignUpViewController.h"

#import "MBProgressHUD.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

#import "MyCommon.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize usernameTextField;
@synthesize secretCodeTextField;

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
    
    self.usernameTextField.text = self.dataModel.username;
    self.secretCodeTextField.text = self.dataModel.secretCode;
    
    [self.usernameTextField resignFirstResponder];
    [self.secretCodeTextField resignFirstResponder];
        
    [MyCommon replaceTextWithLocalizedTextInSubviewsForView:self.view];
    
}

- (void)viewDidUnload
{
    [self setSecretCodeTextField:nil];
    [self setUsernameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)userDidSignIn
{
    NSLog(@"Entered userDidSignIn");
    
    self.dataModel.joined=YES;
        
    [self dismissModalViewControllerAnimated:YES];
    
}

- (IBAction)signInAction:(id)sender
{
    // validate the text field values
    if (self.usernameTextField.text.length == 0)
    {
        [MyCommon ShowErrorAlert:NSLocalizedString(@"ERROR_FILL_USERNAME",nil)];
        return;
    }
    if (self.secretCodeTextField.text.length == 0)
    {
        [MyCommon ShowErrorAlert:NSLocalizedString(@"ERROR_FILL_SECRET_CODE",nil)];
        return;
    }
    
    // starting post the value to remote server
    self.dataModel.username = self.usernameTextField.text;
    self.dataModel.secretCode = self.secretCodeTextField.text;
    
    [self.usernameTextField resignFirstResponder];
    [self.secretCodeTextField resignFirstResponder];
    
    [self postSignInRequest];

}

- (IBAction)signUpAction:(id)sender {
    
    SignUpViewController *signUpViewController = [[SignUpViewController alloc]
                                                initWithNibName:@"SignUpViewController" bundle:nil];
    [self presentModalViewController:signUpViewController animated:NO];
    
}

//- (void)postSignUpRequest
//{
//	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//	hud.labelText = NSLocalizedString(@"Connecting", nil);
//        
//    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
//                            @"signin", @"cmd",
//                            [self.dataModel udid], @"udid",
//                            [self.dataModel deviceToken], @"token",
//                            [self.dataModel username], @"name",
//                            [self.dataModel secretCode], @"code",
//                            nil];
//    
//    NSLog(@"%@", params);
//    
//    NSURL *url = [NSURL URLWithString:@"http://samlei.site88.net"];
//    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
//
//    [httpClient postPath:@"/api.php" parameters:params
//        success:^(AFHTTPRequestOperation *operation, id response)
//        {
//            NSString *text = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
//            NSLog(@"Response: %@", text);
//            if ([self isViewLoaded])
//            {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//                NSLog(@"%@", @"user did sign in");
//                [self userDidSignIn];
//            }
//        }
//        failure:^(AFHTTPRequestOperation *operation, NSError *error)
//        {
//            NSLog(@"%@", [error localizedDescription]);
//            if ([self isViewLoaded])
//            {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [MyCommon ShowErrorAlert:[error localizedDescription]];
//            }
//        }];
//    
//}

- (void) postSignInRequest
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Connecting", nil);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"signin", @"cmd",
                            [self.dataModel udid], @"udid",
                            [self.dataModel deviceToken], @"token",
                            [self.dataModel username], @"username",
                            [self.dataModel secretCode], @"code",
                            nil];
    
    NSLog(@"%@", params);
    
    NSURL *url = [NSURL URLWithString:@"http://samlei.site88.net/"];
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
    NSURLRequest *request = [client requestWithMethod:@"POST"
                                                 path:@"/api.php"
                                           parameters:params];
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         // Do something with JSON
         if ([self isViewLoaded])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             NSLog(@"%@", @"loaded feeling status");

             NSLog(@"Json: %@", JSON);
             NSString *status = [JSON objectForKey:@"status"];
             NSString *reason = [JSON objectForKey:@"reason"];
             
             NSLog( @"status: %@", status );
             NSLog( @"reason: %@", reason );
             
             if ( [status isEqualToString:@"success"] )
             {
                 NSLog( @"User Signed in" );
                 
                 NSDictionary *userInfo = [JSON objectForKey:@"profile"];
                 if ( userInfo != nil )
                 {
                     NSLog(@"username: %@", [userInfo objectForKey:@"username"]);
                     
                     self.dataModel.email = [userInfo objectForKey:@"email"];
                     self.dataModel.firstName = [userInfo objectForKey:@"first_name"];
                     self.dataModel.lastName = [userInfo objectForKey:@"last_name"];
                     self.dataModel.nickname = [userInfo objectForKey:@"nickname"];
                     self.dataModel.gender = [userInfo objectForKey:@"gender"];
                     
                     [[NSUserDefaults standardUserDefaults] synchronize];
                     
                 }
                 
                 [self userDidSignIn];
                 
             }
             
         }
     }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
     {
         NSLog(@"Error: %@", [error localizedDescription]);
         NSLog(@"Json: %@", JSON);
         if ([self isViewLoaded])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [MyCommon ShowErrorAlert:[error localizedDescription]];
         }
         
     }];
    
    // you can either start your operation like this
    [operation start];

}

@end
