//
//  UIDevice+DeviceType.m
//  MartianMonster
//
//  Created by Vik Denic on 2/17/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import "UIDevice+DeviceType.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@implementation UIDevice (DeviceType)

+ (BOOL)isIpad {
    if ( IDIOM == IPAD ) {
        return YES;
    }
    return NO;
}

+ (BOOL)isIpadPro
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat width = mainScreen.nativeBounds.size.width / mainScreen.nativeScale;
    CGFloat height = mainScreen.nativeBounds.size.height / mainScreen.nativeScale;
    BOOL isIpad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    BOOL hasIPadProWidth = fabs(width - 1024.f) < DBL_EPSILON;
    BOOL hasIPadProHeight = fabs(height - 1366.f) < DBL_EPSILON;
    return isIpad && hasIPadProHeight && hasIPadProWidth;
}

@end
