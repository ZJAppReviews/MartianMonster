//
//  UIColor+Custom.m
//  MartianMonster
//
//  Created by Vik Denic on 2/17/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor *) customTransluscentWhite {
    UIColor *customWhite = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:255/255.0 alpha:0.8];
    return customWhite;
}

+ (UIColor *) customTransluscentDark {
    UIColor *customDark = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.20];
    return customDark;
}

@end
