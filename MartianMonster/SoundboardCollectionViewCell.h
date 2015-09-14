//
//  SoundboardCollectionViewCell.h
//  MartianMonster
//
//  Created by Vik Denic on 9/13/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundboardButton.h"
@class SoundboardCollectionViewCell;

@protocol SoundboardCollectionViewCellDelegate <NSObject>

@required

-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapTopLeftButton:(SoundboardButton *)button;

-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapMiddleButton:(SoundboardButton *)button;

@end

@interface SoundboardCollectionViewCell : UICollectionViewCell

@property id<SoundboardCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet SoundboardButton *topLeftButton;
@property (strong, nonatomic) IBOutlet SoundboardButton *topRightButton;
@property (strong, nonatomic) IBOutlet SoundboardButton *middleButton;
@property (strong, nonatomic) IBOutlet SoundboardButton *bottomLeftButton;
@property (strong, nonatomic) IBOutlet SoundboardButton *bottomRightButton;

@end
