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
@property (nonatomic, copy) NSString* reason;
@property (nonatomic, copy) NSString* bodyTouch;

@property (nonatomic, copy) NSString* senderName;

// When the feeling was sent
@property (nonatomic, copy) NSDate* date;

// The text of the feeling
@property (nonatomic, copy) NSString* text;

@property (nonatomic, assign) CGSize balloonSize;

- (BOOL)isSentByUser;

- (BOOL)isBodyTouch;

@end
