//
//  MenuCollectionViewCell.m
//  MartianMonster
//
//  Created by Vik Denic on 2/13/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import "MenuCollectionViewCell.h"
#import "CABasicAnimation+Pulsate.h"
#import "UIColor+Custom.h"

@implementation MenuCollectionViewCell

- (IBAction)didTapButton:(id)sender {
    [self.delegate menuCollectionViewCell:self didTapButton:sender];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.isPlaying = NO;
}

-(void)setUp {
    if (self.isPlaying) {
        [self.menuButton.layer addAnimation:[CABasicAnimation pulsateAnimation]  forKey:@"pulse"];
        self.menuButton.backgroundColor = [UIColor customTransluscentWhite];
        self.menuButton.isAnimating = YES;
    } else {
        [self.menuButton.layer removeAllAnimations];
        self.menuButton.backgroundColor = [UIColor customTransluscentDark];
        self.menuButton.isAnimating = NO; //controls highlighting w/ touchevents
    }
    self.menuButton.clipsToBounds = YES;
    self.menuButton.layer.cornerRadius = self.bounds.size.width / 2;
    [self.menuButton formatImageView];
}

-(void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    [self setUp];
}

@end
