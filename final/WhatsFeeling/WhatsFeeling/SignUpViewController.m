//
//  SingUpViewController.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/12/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Sign Up", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    NSURL *signUpURL = [NSURL URLWithString:@"http://samlei.site88.net/signup.html" ];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:signUpURL]];
    
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)tappedDone:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


@end
