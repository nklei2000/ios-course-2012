//
//  MyUtil.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/10/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "MyCommon.h"

@implementation MyCommon

+ (void)ShowErrorAlert:(NSString*)text
{
	UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:text
                              message:nil
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
    
	[alertView show];
}

+ (void)ShowInfoAlert:(NSString*)text
{
	UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:text
                              message:nil
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
    
	[alertView show];
}

+ (void)changeAppLanguage:(NSString*)langCode
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:langCode, nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)checkAppLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];

    NSString* preferredLang = [languages objectAtIndex:0];
    NSLog(@"Preferred language: %@", preferredLang);
    
    return [languages objectAtIndex:0];
}


+(void) replaceTextWithLocalizedTextInSubviewsForView:(UIView*)view
{
    for (UIView* v in view.subviews)
    {
        if (v.subviews.count > 0)
        {
            [self replaceTextWithLocalizedTextInSubviewsForView:v];
        }
        
        if ([v isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)v;
            NSLog(@"UILable text: %@", label.text);
            label.text = NSLocalizedString(label.text, nil);
            NSLog(@"UILable text (replaced): %@, localized string: %@", label.text, NSLocalizedString(label.text, nil));
        }
        
        if ([v isKindOfClass:[UIButton class]])
        {
            UIButton* button = (UIButton*)v;
            NSLog(@"UIButton text: %@", button.titleLabel.text);
            button.titleLabel.text = NSLocalizedString(button.titleLabel.text, nil);
            NSLog(@"UIButton text (replaced): %@, localized string: %@", button.titleLabel.text, NSLocalizedString(button.titleLabel.text, nil) );
            
        }
    }
}

+ (void)setApplicationIconBadgeNumber:(int)badgeNumber
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
}

+ (void)resetApplicationIconBadgeNumber
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSLog(@"reset ApplicationIconBadgeNumber.."); 
}

+ (NSString *)getMyPhoneNumber
{
    NSString *phoneNumber = @"+694 2870 9394";
    
#if !TARGET_IPHONE_SIMULATOR
     phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"SBFormattedPhoneNumber"];
#endif

    NSLog(@"Your phone number is %@", phoneNumber);
    return phoneNumber;
    
}

+ (void)showDeviceInfo
{
    NSLog(@"Device:\n\n");
    
    NSLog(@"name: %@",[[UIDevice currentDevice] name]);
    NSLog(@"model: %@",[[UIDevice currentDevice] model]);
    NSLog(@"localizedModel: %@",[[UIDevice currentDevice] localizedModel]);
    NSLog(@"systemName: %@",[[UIDevice currentDevice] systemName]);
    NSLog(@"systemVersion: %@",[[UIDevice currentDevice] systemVersion]);
    
    //UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    //NSLog(@"orientation: %d", orientation);
    
}

+ (BOOL) isNumeric:(NSString*) value {
    
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:value];
    
    BOOL valid = [alphaNums isSupersetOfSet:inStringSet];
    
    alphaNums = nil;
    inStringSet = nil;
    
    return valid;
}  

+(void)sortTheNSArray:(NSMutableArray*)theArray forKey:(NSString*)key
{
    NSLog(@"sorting data array with key: %@", key);
    
    NSSortDescriptor *lastDescriptor =
    [[NSSortDescriptor alloc]
     initWithKey:key
     ascending:YES
     selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray * descriptors = [NSArray arrayWithObjects:lastDescriptor, nil];
    [theArray sortUsingDescriptors:descriptors];
    
}

@end
