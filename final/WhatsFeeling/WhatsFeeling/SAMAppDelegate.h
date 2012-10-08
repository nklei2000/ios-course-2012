//
//  SAMAppDelegate.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/5/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataModel.h"

@class SAMViewController;
@class DataModel;

@interface SAMAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

// @property (strong, nonatomic) SAMViewController *viewController;

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic) DataModel *dataModel;

@end
