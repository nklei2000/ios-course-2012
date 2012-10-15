//
//  ContactGroupViewController.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/12/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGORefreshTableHeaderView.h"

@class DataModel;
@class FeelingViewController;

@interface ContactGroupViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL isDataLoaded;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (assign, nonatomic) DataModel *dataModel;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet UITableView *contactGroupTbl;

@property (assign, nonatomic) FeelingViewController *feelingViewController;


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
