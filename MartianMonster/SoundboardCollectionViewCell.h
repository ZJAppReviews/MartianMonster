//
//  SoundboardCollectionViewCell.h
//  MartianMonster
//
//  Created by Vik Denic on 9/13/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SoundboardCollectionViewCell;

@protocol SoundboardCollectionViewCellDelegate <NSObject>

@required

-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapTopLeftButton:(UIButton *)button;

-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapMiddleButton:(UIButton *)button;

@end

@interface SoundboardCollectionViewCell : UICollectionViewCell

@property id<SoundboardCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *topLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *topRightButton;
@property (strong, nonatomic) IBOutlet UIButton *middleButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomRightButton;

@end
