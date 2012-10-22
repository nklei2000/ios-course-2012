//
//  SAMAppDelegate.m
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/19/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "SAMAppDelegate.h"

#import "SAMViewController.h"

@implementation SAMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    // Override point for customization after application launch.
    self.viewController = [[SAMViewController alloc] initWithNibName:@"SAMViewController" bundle:nil];
    // self.window.rootViewController = self.viewController;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if ( localNotif != nil )
    {
        NSLog(@"Local Notification: %@", localNotif);
        
        NSDictionary *userInfo = localNotif.userInfo;
        NSLog(@"description: %@", [userInfo description]);
        NSLog(@"code string: %@", [userInfo objectForKey:@"test-key"]);
    }
    
    return YES;
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Received local notification");
    
    if (application.applicationState == UIApplicationStateInactive)
    {
        NSLog(@"application state is inactive");
    }
    else if (application.applicationState == UIApplicationStateActive)
    {
        NSLog(@"application state is active");
    } else if ( application.applicationState == UIApplicationStateBackground)
    {
        NSLog(@"application state is backgroud");
    }
    
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"code string: %@", [userInfo objectForKey:@"test-key"]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Received local in app"
                                                    message:notification.alertBody
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    // application.applicationIconBadgeNumber -= 1;
    
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
