//
//  Feeling.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/9/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "Feeling.h"

static NSString* const SenderNameKey = @"SenderName";
static NSString* const DateKey = @"Date";
static NSString* const TextKey = @"Text";
static NSString* const TypeKey = @"Type";
static NSString* const ReasonKey = @"Reason";
static NSString* const TouchActionKey = @"TouchAction";

@implementation Feeling

//@synthesize type, senderName, date, text, type, reason, bodyTouch,balloonSize;

- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super init]))
	{
		self.senderName = [decoder decodeObjectForKey:SenderNameKey];
		self.date = [decoder decodeObjectForKey:DateKey];
		self.text = [decoder decodeObjectForKey:TextKey];
        
		self.type = [decoder decodeObjectForKey:TypeKey];
		self.reason = [decoder decodeObjectForKey:ReasonKey];
		self.touchAction = [decoder decodeObjectForKey:TouchActionKey];
        
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:self.senderName forKey:SenderNameKey];
	[encoder encodeObject:self.date forKey:DateKey];
	[encoder encodeObject:self.text forKey:TextKey];
    
	[encoder encodeObject:self.type forKey:TypeKey];
	[encoder encodeObject:self.reason forKey:ReasonKey];
	[encoder encodeObject:self.touchAction forKey:TouchActionKey];
}

- (BOOL)isSentByUser
{
	return self.senderName == nil;
}

- (BOOL)isTouch
{
    return ([@"TOUCH" isEqualToString:self.type]);
}

- (NSString *)displayText
{
    NSString *_displayText = @"";
    if ( [self.type isEqualToString:@"TOUCH"])
    {
        if ( !self.isSentByUser ) {
            _displayText = [NSString stringWithFormat:@"%@ sent %@ to you", self.senderName, self.touchAction];
        } else {
            _displayText = [NSString stringWithFormat:@"I sent %@ to you", self.touchAction];
        }
    }
    else
    {
        if ( !self.isSentByUser )
        {
            if ( self.reason.length == 0 ) {
                _displayText = [NSString stringWithFormat:@"%@ is %@", self.senderName, self.text];
            } else {
                _displayText = [NSString stringWithFormat:@"%@ is %@, caused by %@", self.senderName, self.text, self.reason];
            }
        }
        else
        {
            if ( self.reason.length == 0 ) {
                _displayText = [NSString stringWithFormat:@"I am %@", self.text];
            } else {
                _displayText = [NSString stringWithFormat:@"I am %@, caused by %@", self.text, self.reason];
            }
        }
    }
    
    return _displayText;
}

@end
