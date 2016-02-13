//
//  SoundItem.h
//  MartianMonster
//
//  Created by Vik Denic on 9/14/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface SoundItem : NSObject

@property NSString *displayText;
@property AVAudioPlayerNodeBufferOptions bufferOption;

@property AVAudioFile *audioFile;
@property AVAudioPCMBuffer *audioPCMBuffer;
@property AVAudioPlayerNode *playerNode;
@property AVAudioUnitTimePitch *utPitch;

@property BOOL pitchEffect;
@property float volume;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
-(void)setUpAudioWithEngine:(AVAudioEngine *)engine;

@end
