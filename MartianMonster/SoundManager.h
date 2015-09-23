//
//  SoundManager.h
//  MartianMonster
//
//  Created by Vik Denic on 9/16/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;
#import "SoundItem.h"

@interface SoundManager : NSObject

+(NSMutableArray *)arrayOfSoundboardsFromPlist:(NSString *)plist forEngine:(AVAudioEngine *)engine;

+(void)scheduleAndPlaySoundItem:(SoundItem *)soundItem;

+(void)startEngine:(AVAudioEngine *)engine;

+(void)activateAudioSessionForBackgroundPlay;

@end
