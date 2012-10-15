//
//  Feeling.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/9/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feeling : NSObject
{
}

// touch or text only
@property (nonatomic, copy) NSString* type;

// The sender name
@property (nonatomic, copy) NSString* senderName;

// When the feeling was sent
@property (nonatomic, copy) NSDate* date;

// The text of the feeling
@property (nonatomic, copy) NSString* text;

// The another text of the feeling caused by
@property (nonatomic, copy) NSString* reason;

// The action of touch
@property (nonatomic, copy) NSString* touchAction;

@property (nonatomic, copy) NSString* felt;

@property (nonatomic, assign) CGSize balloonSize;

- (BOOL)isSentByUser;

- (BOOL)isTouch;

@end
