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

-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapButton:(UIButton *)button;

@end

/** The SoundboardCollectionViewCell is used for to house information about audio from a SoundItem instance. They populate the main collectionView.
 *
 *  @class SoundboardCollectionViewCell
 */
@interface SoundboardCollectionViewCell : UICollectionViewCell

@property id<SoundboardCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@end
