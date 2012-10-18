//
//  MyUtil.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/10/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommon
{
}

+ (void)ShowErrorAlert:(NSString*)text;
+ (void)ShowInfoAlert:(NSString*)text;

+ (NSString*)checkAppLanguage;
+ (void)changeAppLanguage:(NSString*)langCode;

+(void)replaceTextWithLocalizedTextInSubviewsForView:(UIView*)view;

+ (void)setApplicationIconBadgeNumber:(int)badgeNumber;
+ (void)resetApplicationIconBadgeNumber;

+ (NSString *) getMyPhoneNumber;

+ (BOOL) isNumeric:(NSString*)value;

+(void)sortTheNSArray:(NSMutableArray*)theArray forKey:(NSString*)key;

@end

