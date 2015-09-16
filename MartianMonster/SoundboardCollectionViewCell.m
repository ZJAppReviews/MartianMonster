//
//  SoundboardCollectionViewCell.m
//  MartianMonster
//
//  Created by Vik Denic on 9/13/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "SoundboardCollectionViewCell.h"

@implementation SoundboardCollectionViewCell

- (IBAction)didTapTopLeftButton:(UIButton *)sender
{
    [self.delegate soundboardCollectionViewCell:self didTapTopLeftButton:sender];
}

- (IBAction)didTapMiddleButton:(UIButton *)sender
{
    [self.delegate soundboardCollectionViewCell:self didTapMiddleButton:sender];
}



@end
