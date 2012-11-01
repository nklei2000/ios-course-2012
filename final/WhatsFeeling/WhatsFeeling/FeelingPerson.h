//
//  FeelingPerson.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/17/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeelingPerson : NSObject
{
}

@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;
@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *company;

- (NSString *)fullName;

@end
