//
//  SAMViewController.h
//  UIScrollViewApp
//
//  Created by Nam Kin Lei on 8/24/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SAMViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *sourceImageView;

@property (strong, nonatomic) IBOutlet UIScrollView *targetImageView;

@end
