//
//  LayoutManager.m
//  MartianMonster
//
//  Created by Vik Denic on 2/14/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import "LayoutManager.h"
#import "UIDevice+DeviceType.h"

CGFloat const iPadProHeight = 1366;
CGFloat const iphone6PlusWidth = 414;
CGFloat const iphone6PlusZoomWidth = 375;
CGFloat const iphone6Width = 375;
CGFloat const iphone6ZoomWidth = 320;
CGFloat const iphone5Width = 320;
CGFloat const iphone4Width = 320;
CGFloat const iphone4Height = 480;

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@implementation LayoutManager

+(UIEdgeInsets)edgeInsetsForMenuCellItem {

//    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;

    if (screenHeight == iphone4Height) {
        return UIEdgeInsetsMake(5.5, 10, 0, 10);
    }
    
    if ( IDIOM == IPAD ) {
        return UIEdgeInsetsMake(25, 10, 0, 10);
    }

    return UIEdgeInsetsMake(10, 10, 0, 10);
}

+(CGFloat) menuMinLineSpacingIpad {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;

    if ([UIDevice isIpadPro]) {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            return screenWidth * 0.1625;
        }
        return 94;
    }

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        return screenWidth * 0.164;
    }
    return 74;
}

+(CGFloat) menuMinLineSpacingIphoneLandscape {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;

    if ([UIDevice isIphone6Plus]) {
        return screenHeight * 0.245;
    }

    return screenHeight * 0.2775;
}

+(float)minimumSpacingForMenuCellItemInPortrait {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;

    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == iphone4Height) {
        return screenWidth * 0.0552;
    }

    if ( IDIOM == IPAD ) {
        return screenWidth * 0.073;
    }
    return screenWidth * 0.02415;
}

+(float)minimumSpacingForMenuCellItemInLandscape {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;

    if (screenWidth == iphone4Height) {
        return screenWidth * 0.105;
    } else if (screenHeight == iphone6Width) {
        return screenWidth * 0.12;
    }

    if ( IDIOM == IPAD ) {
        return screenWidth * 0.1475;
    }

    NSLog(@"screenWidth %f", screenWidth);
    return screenWidth * 0.121;
}

-(BOOL)deviceIsIpad {
    if ( IDIOM == IPAD ) {
        return YES;
    }
    return NO;
}

-(BOOL)deviceIsIphone4 {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == iphone4Height) {
        return YES;
    }
    return NO;
}

@end
