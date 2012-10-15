//
//  SoundEffectHelper.h
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/15/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioPlayer;

@interface SoundEffectHelper : NSObject

+ (void)playSystemSound:(NSString*)fileName ofType:(NSString*)fileType;

+ (void)playWithAudioPlayer:(AudioPlayer*)player fileName:(NSString*)file ofType:(NSString*)fileType;

+ (void)vibrate;

@end
