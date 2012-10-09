//
//  SAMAppDelegate.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/5/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "SAMAppDelegate.h"

#import "FeelingViewController.h"
#import "MyInfoViewController.h"
#import "LoginViewController.h"

#import "DataModel.h"
#import "Feeling.h"

@implementation SAMAppDelegate


- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
	Feeling* feeling = [[Feeling alloc] init];
	feeling.date = [NSDate date];
    
	NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
	NSMutableArray* parts = [NSMutableArray arrayWithArray:[alertValue componentsSeparatedByString:@": "]];
	feeling.senderName = [parts objectAtIndex:0];
	[parts removeObjectAtIndex:0];
	feeling.text = [parts componentsJoinedByString:@": "];
    
	// int index = [self.dataModel addMessage:message];
    
	if (updateUI) {
		// [self.feelingViewController didSaveMessage:message atIndex:index];
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Create data model
    self.dataModel = [[DataModel alloc]init];
    [self.dataModel loadFeelings];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    FeelingViewController *feelingViewController = [[FeelingViewController alloc] initWithNibName:@"FeelingViewController" bundle:nil];
            
    MyInfoViewController *myInfoViewController = [[MyInfoViewController alloc] initWithNibName:@"MyInfoViewController" bundle:nil];
    
    feelingViewController.dataModel = self.dataModel;
    myInfoViewController.dataModel = self.dataModel;
    
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *udid = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    self.dataModel.udid = [udid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(uuidObject);
    NSLog(@"%@", self.dataModel.udid);
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:feelingViewController, myInfoViewController, nil];
    
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    
    if (![self.dataModel joined]) {
        LoginViewController *loginViewController = [[LoginViewController alloc]
                            initWithNibName:@"LoginViewController" bundle:nil];
        loginViewController.dataModel = self.dataModel;
        [self.tabBarController presentModalViewController:loginViewController animated:NO];
    }
    
	if (launchOptions != nil)
	{
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			[self addMessageFromRemoteNotification:dictionary updateUI:NO];
		}
	}
    
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"recieved deviceToken: %@", deviceToken);
    NSString *oldToken = self.dataModel.deviceToken;
    NSLog(@"Old Token: %@", oldToken);
    
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"New Token: %@", newToken);
    
    self.dataModel.deviceToken = newToken;
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Remote Notifications error: %@", [error localizedDescription]);
    
#if TARGET_IPHONE_SIMULATOR
    // Simulator only
    NSString *myDeviceToken = @"1a2adff7 163c960a 1f4737dd c2174db9 148ab412 11bce7ea a8d2715b 9b9398fc";
    self.dataModel.deviceToken = [myDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
#endif
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
	NSLog(@"Received notification: %@", userInfo);
	[self addMessageFromRemoteNotification:userInfo updateUI:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
