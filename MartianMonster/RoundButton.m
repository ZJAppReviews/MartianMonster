//
//  RoundButton.m
//  MartianMonster
//
//  Created by Vik Denic on 10/1/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.width / 2;
    [self formatImageView];
}

-(void)formatImageView
{
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

    float edgeInset = self.bounds.size.width / 6;
    self.imageEdgeInsets = UIEdgeInsetsMake(edgeInset, edgeInset, edgeInset, edgeInset);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    [self addTarget:self action:@selector(clearBgColorForButton:) forControlEvents:UIControlEventTouchCancel];

    self.adjustsImageWhenHighlighted = NO;
}

#pragma  mark - highlight backgroundcolor selectors
-(void)setBgColorForButton:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:245/255.0 green:248/255.0 blue:255/255.0 alpha:0.8]];

}

-(void)clearBgColorForButton:(UIButton*)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:11/255.0 green:11/255.0 blue:11/255.0 alpha:0.33]];
}

@end
