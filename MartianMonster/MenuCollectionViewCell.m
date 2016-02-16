//
//  MenuCollectionViewCell.m
//  MartianMonster
//
//  Created by Vik Denic on 2/13/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import "MenuCollectionViewCell.h"

@implementation MenuCollectionViewCell

- (IBAction)didTapButton:(id)sender {
    [self.delegate menuCollectionViewCell:self didTapButton:sender];
}

-(void)prepareForReuse {
    [super prepareForReuse];

    if (![self.menuButton isAnimating]) {
        [self.menuButton.layer removeAllAnimations];
        self.menuButton.isAnimating = NO;
        self.menuButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.20];
    }
}

@end
