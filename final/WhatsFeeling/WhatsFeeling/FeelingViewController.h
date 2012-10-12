//
//  FeelingViewController.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/5/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowFeelingViewController.h"

@class DataModel;
@class Feeling;
@class ContactGroup;

@interface FeelingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ShowFeelingDelegate>
{
    
}

@property (assign, nonatomic) DataModel *dataModel;
@property (assign, nonatomic) ContactGroup *selectedContactGroup;

@property (strong, nonatomic) IBOutlet UITableView *feelingTbl;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)showFeelingToFriend:(id)sender;

@end
