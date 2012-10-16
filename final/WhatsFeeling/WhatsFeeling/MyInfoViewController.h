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
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *languageButton;

@property (assign,nonatomic) DataModel *dataModel;

- (IBAction)signOut:(id)sender;

- (IBAction)changeLanguage:(id)sender;

- (IBAction)deleteAccount:(id)sender;

@property (strong, nonatomic) IBOutlet UINavigationBar *myInfoNavigationBar;

@end
