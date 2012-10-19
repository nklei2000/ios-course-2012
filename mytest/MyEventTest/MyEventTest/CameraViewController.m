//
//  CameraViewController.m
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/19/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "CameraViewController.h"


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface CameraViewController ()

@end

@implementation CameraViewController
@synthesize photoImageView;

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
}

- (void)viewDidUnload
{
    [self setPhotoImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)showCamera:(id)sender
{
    NSLog(@"show camera");

}

- (IBAction)pickPhoto:(id)sender
{
    NSLog(@"show camera");
    
    

}

- (IBAction)dismiss:(id)sender
{
    
    [self dismissModalViewControllerAnimated:YES];
}

@end