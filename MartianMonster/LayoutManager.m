//
//  LayoutManager.m
//  MartianMonster
//
//  Created by Vik Denic on 2/14/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import "LayoutManager.h"
#import "UIDevice+DeviceType.h"

#pragma mark - Device size constants
CGFloat const iPadProHeight = 1366;
CGFloat const iphone6PlusWidth = 414;
CGFloat const iphone6PlusZoomWidth = 375;
CGFloat const iphone6Width = 375;
CGFloat const iphone6ZoomWidth = 320;
CGFloat const iphone5Width = 320;
CGFloat const iphone4Width = 320;
CGFloat const iphone4Height = 480;

#pragma mark - Image Constants
NSString * const accessIdSombreroImage = @"3";
NSString * const accessIdDogImage = @"5";
NSString * const accessIdShareImage = @"7";

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

//TODO: - Replace magic numbers
@implementation LayoutManager

+(UIEdgeInsets)edgeInsetsForMenu {

    if ( IDIOM == IPAD ) {
        return UIEdgeInsetsMake(25, 10, 0, 10);
    }

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return UIEdgeInsetsMake(-5, 10, 0, 10);
    }

    return UIEdgeInsetsMake(10, 10, 0, 10);
}

+(CGFloat) menuMinLineSpacingIpad {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;

    if ([UIDevice isIpadSplitScreen]) {
        return screenWidth * 0.027;
    }

    if ([UIDevice isIpadPro]) {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            return screenWidth * 0.1625;
        }
        return 94;
    }

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return screenWidth * 0.164;
    }

    return 74;
}

+(CGFloat) menuMinLineSpacingIphoneLandscape {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;

    if ([UIDevice isIphone6Plus]) {
        return screenHeight * 0.245;
    }

    if ([UIDevice isIphone4]) {
        return screenHeight * 0.218;
    }

    return screenHeight * 0.2775;
}

+(CGFloat)menuMinLineSpacingIphone4 {
    return 22.25;
}

+(UIEdgeInsets)edgeInsetForRoundButton:(RoundButton *)button {
    float edgeInset = button.bounds.size.width / 6;

    if ([button.imageView.accessibilityIdentifier isEqualToString:accessIdSombreroImage]) {
        edgeInset = button.bounds.size.width / 7.25;
        return UIEdgeInsetsMake(edgeInset, edgeInset, edgeInset, edgeInset);
    } else if ([button.imageView.accessibilityIdentifier isEqualToString:accessIdShareImage]) {
        edgeInset = button.bounds.size.width / 3.75;
        return UIEdgeInsetsMake(edgeInset, edgeInset - 1.75, edgeInset, edgeInset);
    } else if ([button.imageView.accessibilityIdentifier isEqualToString:accessIdDogImage]) {
        edgeInset = button.bounds.size.width / 4.5;
        return UIEdgeInsetsMake(edgeInset, edgeInset - 1.75, edgeInset, edgeInset);
    }

    return UIEdgeInsetsMake(edgeInset, edgeInset, edgeInset, edgeInset);
}

@end
