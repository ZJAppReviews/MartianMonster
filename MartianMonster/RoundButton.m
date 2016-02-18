//
//  RoundButton.m
//  MartianMonster
//
//  Created by Vik Denic on 10/1/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "RoundButton.h"
#import "UIColor+Custom.h"
#import "LayoutManager.h"

@implementation RoundButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width / 2;
    [self formatImageView];
}

-(void)formatImageView {
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

    self.imageEdgeInsets = [LayoutManager edgeInsetForRoundButton:self];                                                                                         
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchCancel];

    self.adjustsImageWhenHighlighted = NO;
}

#pragma  mark - Highlight backgroundcolor selectors
-(void)setBgColorForButton:(UIButton*)sender {
    [sender setBackgroundColor:[UIColor customTransluscentWhite]];
}

-(void)clearBgColorForButton:(UIButton*)sender {
    //TODO: If button is animating, don't do this
    if (self.isAnimating == NO) {
        [sender setBackgroundColor:[UIColor customTransluscentDark]];
    }
}

@end
