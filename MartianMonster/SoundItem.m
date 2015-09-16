//
//  SoundItem.m
//  MartianMonster
//
//  Created by Vik Denic on 9/14/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "SoundItem.h"
#import "AVAudioFile+Constructors.h"

@implementation SoundItem

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self.displayText = dict[@"displayText"];

    self.bufferOption = AVAudioPlayerNodeBufferInterrupts;
    if ([dict[@"loops"] boolValue])
    {
        self.bufferOption = AVAudioPlayerNodeBufferLoops;
    }

    self.pitchEffect = [dict[@"pitchEffect"] boolValue];

    NSLog(@"%@", dict[@"fileName"]);
    NSString *pathZero = [[NSBundle mainBundle] pathForResource:dict[@"fileName"] ofType:dict[@"fileExtension"]];
    self.audioFile = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:pathZero]
                                         error:nil];

    return self;
}

-(void)setUpAudioWithEngine:(AVAudioEngine *)engine
{
    // Prepare Buffer Zero
    AVAudioFormat *audioFormatZero = self.audioFile.processingFormat;
    AVAudioFrameCount lengthZero = (AVAudioFrameCount)self.audioFile.length;
    self.audioPCMBuffer = [[AVAudioPCMBuffer alloc]initWithPCMFormat:audioFormatZero frameCapacity:lengthZero];
    [self.audioFile readIntoBuffer:self.audioPCMBuffer error:nil];

    // Prepare AVAudioPlayerNode Zero
    self.playerNode = [AVAudioPlayerNode new];
    self.playerNode.volume = 0.55;
    [engine attachNode:self.playerNode];

    // Set pitch (if applicable) and connect nodes
    AVAudioMixerNode *mixerNode = [engine mainMixerNode];
    if (self.pitchEffect)
    {
        //pitches
        self.utPitch = [AVAudioUnitTimePitch new];
        self.utPitch.pitch = 0.0;
        self.utPitch.rate = 1.0;
        [engine attachNode:self.utPitch];

        //connect Nodes
        [engine connect:self.playerNode
                          to:self.utPitch
                      format:self.audioFile.processingFormat];
        [engine connect:self.utPitch
                          to:mixerNode
                      format:self.audioFile.processingFormat];
    }
    else
    {
        //only connect nodes (no pitches)
        [engine connect:self.playerNode
                          to:mixerNode
                      format:self.audioFile.processingFormat];
    }
}

@end
