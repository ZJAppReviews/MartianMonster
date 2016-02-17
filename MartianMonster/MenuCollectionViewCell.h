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

/**
 *  Notifies the delegate that a button within a particular cell has been tapped
 *
 *  @param cell   the cell in which the tapped button resides
 *  @param button the RoundButton instance that was tapped
 */
-(void)menuCollectionViewCell:(MenuCollectionViewCell *)cell didTapButton:(RoundButton *)button;

@end

/** The MenuCollectionViewCell is used for the looped background tracks at the top of the app. They populate the RootViewController's MenuCollectionView.
 *
 *  @class MenuCollectionViewCell
 */
@interface MenuCollectionViewCell : UICollectionViewCell

@property id<MenuCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet RoundButton *menuButton;

/**
 *  Whether or not the cell's associated soundItem's playerNode is playing. This is used to determine whether or not to animate the button in its setUp method, which can be simply triggered by a reloadData call.
 */
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) CABasicAnimation *pulseAnimation;

/**
 *  Enacted on the cell whenever reloadData is called.
 */
-(void)setUp;

@end
