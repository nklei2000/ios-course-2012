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

@end
