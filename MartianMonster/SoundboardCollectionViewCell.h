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

/**
 *  Notifies the delegate that a button within a particular cell has been tapped
 *
 *  @param cell   the cell in which the tapped button resides
 *  @param button the button that was tapped
 */
-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapButton:(UIButton *)button;

@end

/** The SoundboardCollectionViewCell is used for to house information about audio from a Soundboard instance. They populate the RootViewController's soundboardCollectionView.
 *
 *  @class SoundboardCollectionViewCell
 */
@interface SoundboardCollectionViewCell : UICollectionViewCell

@property id<SoundboardCollectionViewCellDelegate> delegate;

@property (nonatomic) NSArray *soundItems;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@end
