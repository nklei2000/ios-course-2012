//
//  LoginViewController.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/8/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nickNameTextField;

@property (strong, nonatomic) IBOutlet UITextField *secretCodeTextField;

@property (assign, nonatomic) DataModel *dataModel;

- (IBAction)joinAction:(id)sender;

@end
