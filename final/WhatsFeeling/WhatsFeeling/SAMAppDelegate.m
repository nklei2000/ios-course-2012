//
//  SAMAppDelegate.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/5/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "SAMAppDelegate.h"

#import "BPXLUUIDHandler.h"

#import "FeelingViewController.h"
#import "ContactGroupViewController.h"

#import "MyInfoViewController.h"
#import "LoginViewController.h"

#import "DataModel.h"
#import "Feeling.h"

#import "SoundEffectHelper.h"

@implementation SAMAppDelegate


- (void)addFeelingFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
	Feeling* feeling = [[Feeling alloc] init];
	feeling.date = [NSDate date];
    
	NSString* alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
    NSLog(@"alert value: %@", alertValue);
    
	NSMutableArray* parts = [NSMutableArray arrayWithArray:[alertValue componentsSeparatedByString:@": "]];
    
    NSLog(@"parts count: %d", [parts count]);
    
	feeling.senderName = [parts objectAtIndex:0];
	// [parts removeObjectAtIndex:0];
    
    if ( [[parts objectAtIndex:1] hasPrefix:@"##"] &&
         [[parts objectAtIndex:1] hasSuffix:@"##"] )
    {
        feeling.type = @"TOUCH";
        feeling.touchAction = [[parts objectAtIndex:1] stringByReplacingOccurrencesOfString:@"##" withString:@""];
        
        if ( [feeling.touchAction isEqualToString:@"SHAKE"] )
        {
            [SoundEffectHelper vibrate];
        }
    }
    else
    {
        feeling.type = @"TEXT";
        // feeling.text = [parts componentsJoinedByString:@": "];
        feeling.text = [parts objectAtIndex:1];
        feeling.reason = @"";
        if ( [parts count] > 1 ) {
            feeling.reason = [parts objectAtIndex:2];
        }
    }
    
    NSLog(@"feeling type: %@, text: %@, touch action: %@", feeling.type, feeling.text, feeling.touchAction);
    
	int index = [self.dataModel addFeeling:feeling];
    NSLog(@"remote notification added into row %d", index);
    
	if (updateUI)
    {
        if ( [feeling.type isEqualToString:@"TEXT"] )
        {
            [self.feelingViewController didShowFeeling:feeling atIndex:index];
        }
        else if ( [feeling.type isEqualToString:@"TOUCH"] )
        {
            [self.feelingViewController didTouchFeeling:feeling atIndex:index];
        }
    }
    
}


- (void)addJsonFeelingFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
	Feeling* feeling = [[Feeling alloc] init];
	feeling.date = [NSDate date];
    
	NSDictionary *alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
    
    if ( alertValue != nil )
    {
        NSLog(@"alert value: %@", alertValue);

        NSString *feelingType = [alertValue objectForKey:@"type"];
        if ( [feelingType isEqualToString:@"TEXT"] )
        {
            feeling.type = @"TEXT";
            feeling.text = [alertValue objectForKey:@"text"];
            feeling.reason = [alertValue objectForKey:@"reason"];
        }
        else if ( [feelingType isEqualToString:@"TOUCH"] )
        {
            feeling.type = @"TOUCH";
            feeling.touchAction = [alertValue objectForKey:@"action"];
            
            if ( [feeling.touchAction isEqualToString:@"SHAKE"] )
            {
                [SoundEffectHelper vibrate];
            }
        }
            
    }
    
    if ( feeling.type != nil )
    {
        NSLog(@"feeling type: %@, text: %@, touch action: %@", feeling.type, feeling.text, feeling.touchAction);
        
        int index = [self.dataModel addFeeling:feeling];
        NSLog(@"remote notification added into row %d", index);
        
        if (updateUI)
        {
            if ( [feeling.type isEqualToString:@"TEXT"] )
            {
                [self.feelingViewController didShowFeeling:feeling atIndex:index];
            }
            else if ( [feeling.type isEqualToString:@"TOUCH"] )
            {
                [self.feelingViewController didTouchFeeling:feeling atIndex:index];
            }
        }
    }
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Create data model
    self.dataModel = [[DataModel alloc]init];
    [self.dataModel loadFeelings];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.feelingViewController = [[FeelingViewController alloc] initWithNibName:@"FeelingViewController" bundle:nil];
    self.feelingViewController.dataModel = self.dataModel;
    
    ContactGroupViewController *contactGroupViewController = [[ContactGroupViewController alloc] initWithNibName:@"ContactGroupViewController" bundle:nil];
    contactGroupViewController.feelingViewController = self.feelingViewController;
    
    MyInfoViewController *myInfoViewController = [[MyInfoViewController alloc] initWithNibName:@"MyInfoViewController" bundle:nil];
    
    contactGroupViewController.dataModel = self.dataModel;
    myInfoViewController.dataModel = self.dataModel;
    
    // Create universally unique identifier (object)
//    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
//    NSString *udid = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
//    self.dataModel.udid = [udid stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    CFRelease(uuidObject);
    
    // [BPXLUUIDHandler setAccessGroup:@"mo.gov.spu"];
    NSString *udid = [BPXLUUIDHandler UUID];
    self.dataModel.udid = [udid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@", self.dataModel.udid);
    
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:contactGroupViewController];
    
    self.tabBarController = [[UITabBarController alloc] init];
    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navController, myInfoViewController, nil];
    
    self.window.rootViewController = self.tabBarController;
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |
      UIRemoteNotificationTypeBadge |
      UIRemoteNotificationTypeSound)];
    
    if (![self.dataModel joined])
    {
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
			[self addFeelingFromRemoteNotification:dictionary updateUI:NO];
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
	// [self addFeelingFromRemoteNotification:userInfo updateUI:YES];
    [self addJsonFeelingFromRemoteNotification:userInfo updateUI:YES];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
    
#if !TARGET_IPHONE_SIMULATOR
    
    NSLog(@"remote notification: %@",[userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    NSString *alert = [apsInfo objectForKey:@"alert"];
    NSLog(@"Received Push Alert: %@", alert);
    
    NSString *badge = [apsInfo objectForKey:@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
#endif
    
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
