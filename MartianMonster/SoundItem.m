//
//  SoundItem.m
//  MartianMonster
//
//  Created by Vik Denic on 9/14/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "SoundItem.h"

@implementation SoundItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self.displayText = dict[@"displayText"];

    self.bufferOption = AVAudioPlayerNodeBufferInterrupts;
    if (dict[@"loops"])
    {
        self.bufferOption = AVAudioPlayerNodeBufferLoops;
    }

    self.pitchEffect = [dict[@"pitchEffect"] boolValue];

    return self;
}

@end
