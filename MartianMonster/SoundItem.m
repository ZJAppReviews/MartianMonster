//
//  SoundItem.m
//  MartianMonster
//
//  Created by Vik Denic on 9/14/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "SoundItem.h"

@implementation SoundItem

#pragma  mark - Constants
NSString *const kLoopsKey = @"loops";
NSString *const kDisplayTextKey = @"displayText";
NSString *const kPitchEffectKey = @"pitchEffect";
NSString *const kVolumeKey = @"volume";
NSString *const kFileNameKey = @"fileName";
NSString *const kFileExtensionKey = @"fileExtension";
NSString *const kInvertTextKey = @"invertText";

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self.displayText = dict[kDisplayTextKey];

    self.bufferOption = AVAudioPlayerNodeBufferInterrupts;
    if ([dict[kLoopsKey] boolValue])
    {
        self.bufferOption = AVAudioPlayerNodeBufferLoops;
    }

    self.pitchEffect = [dict[kPitchEffectKey] boolValue];
    self.volume = [dict[kVolumeKey] floatValue];
    self.invertText = [dict[kInvertTextKey] floatValue];

    NSString *pathZero = [[NSBundle mainBundle] pathForResource:dict[kFileNameKey] ofType:dict[kFileExtensionKey]];
    self.audioFile = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:pathZero]
                                         error:nil];

    NSLog(@"%@",self.displayText);
    //Approximate audioFile duration
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:pathZero] options:nil];
    CMTime audioDuration = audioAsset.duration;
    self.duration = CMTimeGetSeconds(audioDuration);

    return self;
}

-(void)setUpAudio {
    // Prepare Buffer
    AVAudioFormat *audioFormatZero = self.audioFile.processingFormat;
    AVAudioFrameCount lengthZero = (AVAudioFrameCount)self.audioFile.length;
    self.audioPCMBuffer = [[AVAudioPCMBuffer alloc]initWithPCMFormat:audioFormatZero frameCapacity:lengthZero];
    [self.audioFile readIntoBuffer:self.audioPCMBuffer error:nil];
}

-(void)attachToEngine:(AVAudioEngine *)engine {
    // Prepare AVAudioPlayerNode
    if (!self.playerNode) {
        self.playerNode = [AVAudioPlayerNode new];
    }
    self.playerNode.volume = self.volume;
    
    [engine attachNode:self.playerNode];

    // Set pitch (if applicable) and connect nodes
    AVAudioMixerNode *mixerNode = [engine mainMixerNode];
    if (self.pitchEffect) {
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
    } else {
        //only connect nodes (no pitches)
        [engine connect:self.playerNode
                     to:mixerNode
                 format:self.audioFile.processingFormat];
    }
}

@end
