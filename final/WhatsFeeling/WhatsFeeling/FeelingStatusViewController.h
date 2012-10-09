//
//  FeelingStatusViewController.h
//  WhatsFeeling
//
//  Created by Nam Kins Lei on 10/10/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;

@interface FeelingStatusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
}

@property (assign, nonatomic) DataModel *dataModel;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end
