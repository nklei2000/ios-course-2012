//
//  FeelingPerson.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/17/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "FeelingPerson.h"

@implementation FeelingPerson

-(NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

@end
