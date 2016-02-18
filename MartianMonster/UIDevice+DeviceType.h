//
//  UIDevice+DeviceType.h
//  MartianMonster
//
//  Created by Vik Denic on 2/17/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (DeviceType)

+ (BOOL)isIpad;
+ (BOOL)isIpadPro;
+ (BOOL)isIphone6Plus;
+ (BOOL)isIphone4;
+ (BOOL)isIpadSplitScreen;

@end
