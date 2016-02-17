//
//  Soundboard.h
//  MartianMonster
//
//  Created by Vik Denic on 9/14/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A Soundboard has a simple responsibility: carry with it an array of soundItems. For each SoundboardCollectionViewCell will exist a correlating Soundboard object.
 *  @class Soundboard
 */
@interface Soundboard : NSObject

/**
 *  The array of soundItems (to populate the SoundboardCollectionViewCell's with
 */
@property NSMutableArray *soundItems;

@end
