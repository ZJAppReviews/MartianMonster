//
//  CABasicAnimation+Pulsate.m
//  MartianMonster
//
//  Created by Vik Denic on 2/17/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import "CABasicAnimation+Pulsate.h"

@implementation CABasicAnimation (Pulsate)

+(CABasicAnimation *)pulsateAnimation {
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = .5;
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulseAnimation.autoreverses = YES;
    pulseAnimation.repeatCount = FLT_MAX;
    return pulseAnimation;
}

@end
