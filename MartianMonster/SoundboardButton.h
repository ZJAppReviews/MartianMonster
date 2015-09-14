//
//  SoundboardButton.h
//  MartianMonster
//
//  Created by Vik Denic on 9/13/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface SoundboardButton : UIButton

@property AVAudioFile *audioFile;
@property AVAudioPCMBuffer *audioPCMBuffer;
@property AVAudioPlayerNode *playerNode;
@property AVAudioUnitTimePitch *utPitch;
@property AVAudioPlayerNodeBufferOptions bufferOption;
@property BOOL pitchEffect;

@end
