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
}


@end
