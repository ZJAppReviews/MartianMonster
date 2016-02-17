//
//  MenuCollectionViewCell.h
//  MartianMonster
//
//  Created by Vik Denic on 2/13/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundButton.h"
#import "SoundItem.h"
@class MenuCollectionViewCell;

@protocol MenuCollectionViewCellDelegate <NSObject>

@required

-(void)menuCollectionViewCell:(MenuCollectionViewCell *)cell didTapButton:(RoundButton *)button;

@end

@interface MenuCollectionViewCell : UICollectionViewCell

@property id<MenuCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet RoundButton *menuButton;

-(void)setUp;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) CABasicAnimation *pulseAnimation;

@end
