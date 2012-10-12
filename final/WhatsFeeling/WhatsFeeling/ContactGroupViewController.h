//
//  ContactGroupViewController.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/12/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;
@class FeelingViewController;

@interface ContactGroupViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    BOOL isDataLoaded;
}

@property (assign, nonatomic) DataModel *dataModel;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UITableView *contactGroupTbl;

@property (strong, nonatomic) FeelingViewController *feelingViewController;

@end
