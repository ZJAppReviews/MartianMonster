//
//  SoundManager.m
//  MartianMonster
//
//  Created by Vik Denic on 9/16/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "SoundManager.h"
#import "SoundItem.h"

@implementation SoundManager

+(void)activateAudioSessionForBackgroundPlay {
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
}

+(NSMutableArray *)arrayOfSoundboardsFromPlist:(NSString *)plist forEngine:(AVAudioEngine *)engine {
    NSURL *path = [[NSBundle mainBundle] URLForResource:plist withExtension:@"plist"];
    NSArray *soundListsArray = [NSArray arrayWithContentsOfURL:path];

    NSMutableArray *soundboardsArray = [NSMutableArray new];

    for (NSArray *soundList in soundListsArray) {
        NSMutableArray *soundItemArray = [NSMutableArray new];

        for (NSDictionary *soundDict in soundList) {
            SoundItem *soundItem = [[SoundItem alloc] initWithDictionary:soundDict];
            [soundItem setUpAudio];
            [soundItemArray addObject:soundItem];
        }
        [soundboardsArray addObject:soundItemArray];
    }
    return soundboardsArray;
}

+(void)scheduleAndPlaySoundItem:(SoundItem *)soundItem forEngine:(AVAudioEngine *)engine withPitch:(float)pitch {

    @try {
        [soundItem attachToEngine: engine];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }

    NSDate *dateBefore = [NSDate date];

    soundItem.utPitch.pitch = pitch;
    // Schedule playing audio buffer
    [soundItem.playerNode scheduleBuffer:soundItem.audioPCMBuffer
                                  atTime:nil
                                 options:soundItem.bufferOption
                       completionHandler:^{

                           NSTimeInterval timePassed = [[NSDate date] timeIntervalSinceDate:dateBefore];
                           float audioTimeRemaining = soundItem.duration - timePassed;

                           if (audioTimeRemaining < 0.05) {
                               [engine detachNode:soundItem.playerNode];

                               if (soundItem.utPitch) {
                                   [engine detachNode:soundItem.utPitch];
                               }
                           }
                       }];

    [SoundManager startEngine:engine];

    [soundItem.playerNode play];
}

+(void)startEngine:(AVAudioEngine *)engine {
    // Start engine
    NSError *error;
    [engine startAndReturnError:&error];
    if (error) {
        NSLog(@"error:%@", error);
    }
}

@end
