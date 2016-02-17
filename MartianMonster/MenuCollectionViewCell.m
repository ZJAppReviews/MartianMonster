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
    self.isPlaying = NO;
//
//    [self.menuButton.layer removeAllAnimations];
//    self.menuButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.20];
}

-(void)setUp {

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isPlaying) {
            [self.menuButton.layer addAnimation:[self pulsateAnimation]  forKey:@"pulse"];
            self.menuButton.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:255/255.0 alpha:0.8];
            self.menuButton.isAnimating = YES;
        } else {
            [self.menuButton.layer removeAllAnimations];
            self.menuButton.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.20];
            self.menuButton.isAnimating = NO; //used to control highlighting w/ touchevents
        }
    });
}

-(CABasicAnimation *)pulsateAnimation
{
    self.pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    self.pulseAnimation.duration = .5;
    self.pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
    self.pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.pulseAnimation.autoreverses = YES;
    self.pulseAnimation.repeatCount = FLT_MAX;
    return self.pulseAnimation;
}

-(void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    [self setUp];
}

@end
