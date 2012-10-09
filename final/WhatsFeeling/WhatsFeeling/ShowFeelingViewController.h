//
//  ShowFeelingViewController.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/9/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;

@interface ShowFeelingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
}

@property (assign, nonatomic) DataModel *dataModel;
//@property (strong, nonatomic) NSMutableArray *dataArray;

@end
