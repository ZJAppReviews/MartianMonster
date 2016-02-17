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

/** The MenuCollectionViewCell is used for the looped background tracks at the top of the app. They populate the MenuCollectionView.
 *
 *  @class MenuCollectionViewCell
 */
@interface MenuCollectionViewCell : UICollectionViewCell

@property id<MenuCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet RoundButton *menuButton;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) CABasicAnimation *pulseAnimation;

-(void)setUp;

@end
