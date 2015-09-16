//
//  SoundboardButton.h
//  MartianMonster
//
//  Created by Vik Denic on 9/13/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundItem.h"
#import "Soundboard.h"

@interface SoundboardButton : UIButton

@property Soundboard *soundboard;
@property SoundItem *soundItem;

@end
