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

+ (NSString*)checkAppLanguage;

+(void) replaceTextWithLocalizedTextInSubviewsForView:(UIView*)view;

@end
