//
//  SoundboardCollectionViewCell.m
//  MartianMonster
//
//  Created by Vik Denic on 9/13/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "SoundboardCollectionViewCell.h"
#import "SoundItem.h"
#import "UIView+Layout.h"

@implementation SoundboardCollectionViewCell

- (IBAction)didTapButton:(UIButton *)sender {
    [self.delegate soundboardCollectionViewCell:self didTapButton:sender];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    for (UIButton *button in self.buttons) {
        button.titleLabel.numberOfLines = 1;
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.lineBreakMode = NSLineBreakByClipping;
    }
}

-(void)prepareForReuse {
    [super prepareForReuse];
    UIView *cellSuperview = self.contentView.subviews.lastObject;
    for (UIView *view in cellSuperview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.transform = CGAffineTransformIdentity;
        }
    }
}

-(void)setUp {
    UIView *cellSuperview = self.contentView.subviews.lastObject;

    for (UIView *view in cellSuperview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *) view;
            SoundItem *soundItem = self.soundItems[button.tag];
            [button setTitle:soundItem.displayText forState:UIControlStateNormal];

            if (soundItem.bufferOption == AVAudioPlayerNodeBufferLoops) {
                if ([soundItem.playerNode isPlaying]) {
                    [button setTitle:@"" forState:UIControlStateNormal];
                } else {
                    [button setTitle:soundItem.displayText forState:UIControlStateNormal];
                    [button setImage:nil forState:UIControlStateNormal];
                }
            }

            if (soundItem.invertText) {
                [view invertHorizontally];
            }
        }
    }
}

-(void)setSoundItems:(NSArray *)soundItems {
    _soundItems = soundItems;
    [self setUp];
}

@end
