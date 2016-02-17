//
//  UIView+Layout.m
//  MartianMonster
//
//  Created by Vik Denic on 2/17/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

//Constraint helper
-(void)constrainToSuperview:(UIView *)superview {
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];

    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];

    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];

    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
}

@end
