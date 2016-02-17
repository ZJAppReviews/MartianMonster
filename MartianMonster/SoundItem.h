//
//  SoundItem.h
//  MartianMonster
//
//  Created by Vik Denic on 9/14/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

/** A SoundItem is the most powerful type of object in the project. It carries with it all critical audio information pertaining to a particular soundbite or background track.
 *
 *  @class SoundItem
 */
@interface SoundItem : NSObject

/**
 *  The text to display on the button for the soundItem (i.e. "They Attack!").
 */
@property NSString *displayText;

/**
 *  The buffer option for the soundItem's playerNode (either AVAudioPlayerNodeBufferInterrupts or AVAudioPlayerNodeBufferLoops).
 */
@property AVAudioPlayerNodeBufferOptions bufferOption;

/**
 *  The audioFile that the soundItem will play (this data is housed within the .plist's).
 */
@property AVAudioFile *audioFile;

/**
 *  The buffer, which reads into the soundItem's AVAudioFile (the buffer contains information on format and capacity for the file). It helps to understand that an audio buffer is a reserved segment of memory used to hold an advance supply of audio data to compensate for momentary delays in processing.
 */
@property AVAudioPCMBuffer *audioPCMBuffer;

/**
 *  The playerNode for the soundItem. This is a prevalent object that gets attached to the engine and is used for playing and stopping audio.
 */
@property AVAudioPlayerNode *playerNode;

/**
 *  T
 */
@property AVAudioUnitTimePitch *utPitch;

/**
 *  The UTPitch property of the soundItem, who's pitch will be adjusted by the slider.
 */
@property BOOL pitchEffect;

/**
 *  The volume level of the soundItem (between 0 and 1).
 */
@property float volume;

/**
 *  Creates a new SoundItem, set with values from the provided dictionary
 *
 *  @param dict the dictionary containing info for the soundItem (the dictionaries are housed within .plist's)
 *
 *  @return a new SoundItem, set with values from the provided dictionary
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 *  Sets the soundItem's audio-related properties and attaches them to the provided AVAudioEngine
 *
 *  @param engine the engine to bond the soundItem's audio-related properties to (i.e. its AVAudioPlayerNode, AVAudioUnitTimePitch, and AVAudioFile)
 */
-(void)setUpAudioWithEngine:(AVAudioEngine *)engine;

@end