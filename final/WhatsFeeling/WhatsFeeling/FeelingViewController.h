//
//  FeelingViewController.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/5/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;
@class Feeling;

@interface FeelingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (strong, nonatomic) IBOutlet UITableView *feelingTbl;
@property (assign,nonatomic) DataModel *dataModel;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)showFeelingToFriend:(id)sender;

@end
