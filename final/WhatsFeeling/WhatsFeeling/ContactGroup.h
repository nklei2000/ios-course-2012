//
//  ContactGroup.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/12/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feeling;

@interface ContactGroup : NSObject
{
}

@property (copy, nonatomic) NSString *groupId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *creationUser;

@property (copy, nonatomic) NSString *newestSender;
@property (copy, nonatomic) NSString *newestContent;

@end
