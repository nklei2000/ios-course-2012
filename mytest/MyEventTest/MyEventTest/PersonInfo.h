//
//  PersonInfo.h
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/30/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PersonInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * name;

@end
