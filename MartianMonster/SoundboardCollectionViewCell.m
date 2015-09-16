//
//  SoundboardCollectionViewCell.m
//  MartianMonster
//
//  Created by Vik Denic on 9/13/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "SoundboardCollectionViewCell.h"

@implementation SoundboardCollectionViewCell

- (IBAction)didTapButton:(UIButton *)sender
{
    [self.delegate soundboardCollectionViewCell:self didTapButton:sender];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    for (UIButton *button in self.buttons)
    {
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.lineBreakMode = NSLineBreakByClipping;
    }
}

@end
