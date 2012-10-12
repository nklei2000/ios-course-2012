//
//  ShowFeelingViewController.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/9/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;
@class Feeling;
@class FeelingStatusViewController;

// The delegate protocol
@protocol ShowFeelingDelegate <NSObject>
- (void)didShowFeeling:(Feeling*)feeling atIndex:(int)index;
@end

@interface ShowFeelingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
}
@property (strong, nonatomic) IBOutlet UITableView *feelingStatusTbl;

@property (assign, nonatomic) DataModel *dataModel;

@property (strong, nonatomic) IBOutlet UITextField *reasonTextField;

@property (strong, nonatomic) FeelingStatusViewController *feelingStatusViewController;

@property (strong, nonatomic) id<ShowFeelingDelegate> delegate;

@property (strong, nonatomic) Feeling *showFeeling;

@end
