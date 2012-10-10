//
//  FeelingStatus.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/9/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeelingStatus : NSObject
{
}

@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *feeling;
@property (copy, nonatomic) NSString *category;
@property (copy, nonatomic) NSString *lang;

@end
