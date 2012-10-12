//
//  TouchFeelingViewController.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/12/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;
@class Feeling;

// The delegate protocol
@protocol TouchFeelingDelegate <NSObject>
- (void)didTouchFeeling:(Feeling*)feeling atIndex:(int)index;
@end

@interface TouchFeelingViewController : UIViewController
{
}

@property (assign, nonatomic) DataModel *dataModel;

@property (strong, nonatomic) id<TouchFeelingDelegate> delegate;

@property (strong, nonatomic) Feeling *touchFeeling;

@end
