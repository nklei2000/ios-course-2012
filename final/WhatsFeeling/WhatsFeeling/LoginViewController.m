//
//  LoginViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/8/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.

#import "LoginViewController.h"

#import "MBProgressHUD.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

#import "MyCommon.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize nickNameTextField;
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
    
    self.nickNameTextField.text = self.dataModel.nickname;
    self.secretCodeTextField.text = self.dataModel.secretCode;
    
//    [[self.nickNameTextField layer] setBorderColor:[[UIColor grayColor] CGColor]];
//    [[self.nickNameTextField layer] setBorderWidth:2.3];
//    [[self.nickNameTextField layer] setCornerRadius:15];
    
    [MyCommon replaceTextWithLocalizedTextInSubviewsForView:self.view];
    
}

- (void)viewDidUnload
{
    [self setNickNameTextField:nil];
    [self setSecretCodeTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ( self.nickNameTextField.text.length == 0 )
        [self.nickNameTextField becomeFirstResponder];
    else
        [self.secretCodeTextField becomeFirstResponder];
    
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
    if (self.nickNameTextField.text.length == 0)
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
    self.dataModel.nickname = self.nickNameTextField.text;
    self.dataModel.secretCode = self.secretCodeTextField.text;
    
    [self.nickNameTextField resignFirstResponder];
    [self.secretCodeTextField resignFirstResponder];
    
    [self postSignUpRequest];

}

- (void)postSignUpRequest
{
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Connecting", nil);
        
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"signup", @"cmd",
                            [self.dataModel udid], @"udid",
                            [self.dataModel deviceToken], @"token",
                            [self.dataModel nickname], @"name",
                            [self.dataModel secretCode], @"code",
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

                NSLog(@"%@", @"user did sign in");
                [self userDidSignIn];
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

- (void) postSignInRequest
{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Connecting", nil);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"signup", @"cmd",
                            [self.dataModel udid], @"udid",
                            [self.dataModel deviceToken], @"token",
                            [self.dataModel nickname], @"name",
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
