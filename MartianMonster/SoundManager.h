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

/**
 *  The SoundManager class handles all processes related to audio. This includes: setting up and activating the app's AVAudioSession; starting the audioEngine; the generation of SoundBoard instances from plist data; scheduling the playing of a soundItem's playerNode;
 *  @class SoundManager
 */
@interface SoundManager : NSObject

/**
 *  Sets up the singleton audio session of category AVAudioSessionCategoryPlayback with option AVAudioSessionCategoryOptionMixWithOthers.
 
 * These settings allow for playback in silent mode, as well as not interrupting other audio sessions currently playing from other apps.
 */
+(void)activateAudioSessionForBackgroundPlay;

/**
 *  Starts the provided AVAudioEngine instance.
 *
 *  @param engine the provided AVAudioEngine (should be only one engine for the entire app).
 */
+(void)startEngine:(AVAudioEngine *)engine;

/**
 *  Generates the array of Soundboard objects (each of which contains an array of Sounditems).
 *
 *  @param plist  the plist of sound data (SoundInfo.plist or BgSongInfo.plist)
 *  @param engine the audio engine (to connect each soundItem's AVAudio properties to)
 *
 *  @return an array of Sounditems
 */
+(NSMutableArray *)arrayOfSoundboardsFromPlist:(NSString *)plist forEngine:(AVAudioEngine *)engine;

/**
 *  Attaches and connects a specified soundItem's nodes to the specified engine (if necessary), and then schedules and plays the sound. Upon completion of playing, the nodes are detached from the engine; this avoids a critical issue where too many nodes attached to the engine overloaded the CPU and broke the sound from playing.
 *
 *  @param soundItem the SoundItem whose audio will be played
 *  @param engine    the audio engine that the soundItem's nodes will be connected to
 *  @param pitch     the pitch level to initially set the sound to (i.e. based on the slider position)
 */
+(void)scheduleAndPlaySoundItem:(SoundItem *)soundItem forEngine:(AVAudioEngine *)engine withPitch:(float)pitch;

@end
