//
//  SoundEffectHelper.m
//  WhatsFeeling
//
//  Created by Nam Kin Lei on 10/15/12.
//  Copyright (c) 2012 Nam Kin Lei. All rights reserved.
//

#import "SoundEffectHelper.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@implementation SoundEffectHelper


+ (void)playSystemSound:(NSString*)fileName ofType:(NSString*)fileType
{
    SystemSoundID soundID;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:soundPath];
    
    CFURLRef soundFileRef = (CFURLRef)CFBridgingRetain(url);
    
    AudioServicesCreateSystemSoundID(soundFileRef, &soundID);
    
    AudioServicesPlaySystemSound(soundID);
    
}

+ (void)playWithAudioPlayer:(AVAudioPlayer*)player fileName:(NSString*)fileName ofType:(NSString *)fileType
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];

    NSURL *url = [NSURL fileURLWithPath:soundPath];
    
    NSError *error;
    if ( player == nil ) {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    }
    
    [player play];
    
}

+ (void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
