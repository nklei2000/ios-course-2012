//
//  SAMViewController.m
//  UIScrollViewApp
//
//  Created by Nam Kin Lei on 8/24/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "SAMViewController.h"
#import "UIImageView+AFNetworking.h"

@interface SAMViewController ()
-(void)setNetworkImageView:(UIImageView*) theImageView X:(float)x Y:(float)y;
@end

@implementation SAMViewController
@synthesize sourceImageView;
@synthesize targetImageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSURL *imageURL = [NSURL URLWithString:@"http://graph.facebook.com/nklei/picture?type=large"];
    [sourceImageView setIma]
    
}

- (void)viewDidUnload
{
    [self setSourceImageView:nil];
    [self setTargetImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)setNetworkImageView:(UIImageView*)theImageView X:(float)x Y:(float)y
{
    CGRect frame = theImageView.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    theImageView.frame = frame;
}

@end
