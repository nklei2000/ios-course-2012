//
//  FeelingStatusViewController.h
//  WhatsFeeling
//
//  Created by Nam Kins Lei on 10/10/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;
@class FeelingStatus;

@interface FeelingStatusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
}

@property (assign, nonatomic) DataModel *dataModel;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UITableView *feelingStatusTbl;

@end