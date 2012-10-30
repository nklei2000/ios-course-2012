//
//  Address.h
//  MyEventTest
//
//  Created by Nam Kin Lei on 10/30/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * building;
@property (nonatomic, retain) NSString * street;

@end
