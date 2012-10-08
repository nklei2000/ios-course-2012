//
//  LoginViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/8/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h" 
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"

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

- (void)userDidJoin
{
    NSLog(@"Entered userDidJoin");
    
    self.dataModel.joined=YES;
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)joinAction:(id)sender
{

    // validate the text field values
    if (self.nickNameTextField.text.length == 0)
    {
        ShowErrorAlert( NSLocalizedString(@"Please fill your nick name",nil) );
        return;
    }
    if (self.secretCodeTextField.text.length == 0)
    {
        ShowErrorAlert( NSLocalizedString(@"Please fill your secret code", nil) );
        return;
    }
    
    // starting post the value to remote server
    self.dataModel.nickname = self.nickNameTextField.text;
    self.dataModel.secretCode = self.secretCodeTextField.text;
    
    [self.nickNameTextField resignFirstResponder];
    [self.secretCodeTextField resignFirstResponder];
    
    [self postJoinRequest];

}

- (void)postJoinRequest
{
	MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.labelText = NSLocalizedString(@"Connecting", nil);
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"join", @"cmd",
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

                NSLog(@"%@", @"user did join");
                [self userDidJoin];
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"%@", [error localizedDescription]);
            if ([self isViewLoaded])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                ShowErrorAlert([error localizedDescription]);
            }
        }];
    
    
    
//    NSURL *url = [NSURL URLWithString:@"http://samlei.site88.net/"];
//    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:url];
//    NSURLRequest *request = [client requestWithMethod:@"POST"
//                                                 path:@"/api.php"
//                                           parameters:params];
//    AFJSONRequestOperation *operation =
//    [AFJSONRequestOperation
//     JSONRequestOperationWithRequest:request
//     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
//    {
//        // Do something with JSON
//        if ([self isViewLoaded])
//        {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//            NSLog(@"%@", @"user did join");
//            [self userDidJoin];
//        }
//    }
//     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
//    {
//        NSLog(@"%@", [error localizedDescription]);
//        if ([self isViewLoaded])
//        {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            ShowErrorAlert([error localizedDescription]);
//        }
//
//    }];
//    
//    // you can either start your operation like this
//    [operation start];
//    
//    // or enqueue it in the client default operations queue.
//    [client enqueueHTTPRequestOperation:operation];
    
    
    
    

    
}

void ShowErrorAlert(NSString* text)
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
