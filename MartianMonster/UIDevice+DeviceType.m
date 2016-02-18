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

+ (BOOL)isIphone6Plus
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat width = mainScreen.nativeBounds.size.width / mainScreen.nativeScale;
    CGFloat height = mainScreen.nativeBounds.size.height / mainScreen.nativeScale;
    BOOL has6PlusProHeight = fabs(width - 414.f) < DBL_EPSILON;
    BOOL has6PlusWidth = fabs(height - 736.f) < DBL_EPSILON;
    return has6PlusProHeight && has6PlusWidth;
}

+ (BOOL)isIphone4
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat width = mainScreen.nativeBounds.size.width / mainScreen.nativeScale;
    CGFloat height = mainScreen.nativeBounds.size.height / mainScreen.nativeScale;
    BOOL hasIphone4height = fabs(width - 320.f) < DBL_EPSILON;
    BOOL hasIphone4width = fabs(height - 480.f) < DBL_EPSILON;
    return hasIphone4height && hasIphone4width;
}

+ (BOOL)isIpadSplitScreen {
    return !CGRectEqualToRect([UIApplication sharedApplication].delegate.window.frame, [UIApplication sharedApplication].delegate.window.screen.bounds);
}

@end
