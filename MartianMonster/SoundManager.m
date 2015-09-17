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

+(NSMutableArray *)arrayOfSoundboardsFromPlistforEngine:(AVAudioEngine *)engine
{
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"SoundInfo" withExtension:@"plist"];
    NSArray *soundListsArray = [NSArray arrayWithContentsOfURL:path];

    NSMutableArray *soundboardsArray = [NSMutableArray new];

    for (NSArray *soundList in soundListsArray)
    {
        NSMutableArray *soundItemArray = [NSMutableArray new];

        for (NSDictionary *soundDict in soundList)
        {
            SoundItem *soundItem = [[SoundItem alloc] initWithDictionary:soundDict];
            [soundItem setUpAudioWithEngine:engine];
            [soundItemArray addObject:soundItem];
        }
        [soundboardsArray addObject:soundItemArray];
    }
    return soundboardsArray;
}

+(void)scheduleAndPlaySoundItem:(SoundItem *)soundItem
{
    // Schedule playing audio buffer
    [soundItem.playerNode scheduleBuffer:soundItem.audioPCMBuffer
                                  atTime:nil
                                 options:soundItem.bufferOption
                       completionHandler:nil];

    [soundItem.playerNode play];
}

+(void)startEngine:(AVAudioEngine *)engine
{
    // Start engine
    NSError *error;
    [engine startAndReturnError:&error];
    if (error) {
        NSLog(@"error:%@", error);
    }
}

+(void)activateAudioSessionForBackgroundPlay
{
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
}

@end
