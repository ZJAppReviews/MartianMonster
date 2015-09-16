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

@end
