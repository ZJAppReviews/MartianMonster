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
}

@end
