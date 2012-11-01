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
    if ( (self.firstName != nil && self.firstName.length > 0) &&
         (self.lastName != nil && self.lastName.length > 0) )
    {
        return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    }
    else if ( self.firstName != nil && self.firstName.length > 0  )
    {
        return self.firstName;
    }
    else if ( self.lastName != nil && self.lastName.length > 0 )
    {
        return self.lastName;
    }
    else
    {
        if ( self.company != nil && self.company.length > 0 ) {
            return self.company;
        }
    }
    
    return @"";
}

@end
