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
static NSString* const BodyTouchKey = @"BodyTouch";

@implementation Feeling

//@synthesize type, senderName, date, text, type, reason, bodyTouch,balloonSize;

- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super init]))
	{
		self.senderName = [decoder decodeObjectForKey:SenderNameKey];
		self.date = [decoder decodeObjectForKey:DateKey];
		self.text = [decoder decodeObjectForKey:TextKey];
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
	[encoder encodeObject:self.bodyTouch forKey:BodyTouchKey];
}

- (BOOL)isSentByUser
{
	return self.senderName == nil;
}

- (BOOL)isBodyTouch
{
    return ([@"TOUCH" isEqualToString:type]);
}

@end
