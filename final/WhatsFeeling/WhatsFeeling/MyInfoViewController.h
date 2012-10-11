//
//  MyInfoViewController.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/5/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;

@interface MyInfoViewController : UIViewController
{    
}

@property (strong, nonatomic) IBOutlet UILabel *udidLabel;
@property (strong, nonatomic) IBOutlet UILabel *deviceTokenLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (assign,nonatomic) DataModel *dataModel;

- (IBAction)signOut:(id)sender;

- (IBAction)deleteAccount:(id)sender;


@end
