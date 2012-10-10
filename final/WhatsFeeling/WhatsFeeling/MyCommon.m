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

+ (void)ChangeAppLanguage:(NSString*)langCode
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
            UILabel* lable = (UILabel*)v;
            lable.text = NSLocalizedString(lable.text, nil);
        }
        
        if ([v isKindOfClass:[UIButton class]])
        {
            UIButton* button = (UIButton*)v;
            button.titleLabel.text = NSLocalizedString(button.titleLabel.text, nil);
        }
    }
}

@end
