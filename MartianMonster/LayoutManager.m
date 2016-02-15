//
//  LayoutManager.m
//  MartianMonster
//
//  Created by Vik Denic on 2/14/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import "LayoutManager.h"

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

+(CGSize)sizeForMenuCellItem {
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float cellLength = screenWidth * 0.175;

    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == iphone4Height) {
        cellLength = screenWidth * 0.15;
        return CGSizeMake(cellLength, cellLength);
    }

    if ( IDIOM == IPAD ) {
        cellLength = screenWidth * 0.14;
        return CGSizeMake(cellLength, cellLength);
    }

    return CGSizeMake(cellLength, cellLength);
}

+(UIEdgeInsets)edgeInsetsForMenuCellItem {

    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;

    if (screenHeight == iphone4Height) {
        return UIEdgeInsetsMake(5.5, 10, 0, 10);
    }
    
    if ( IDIOM == IPAD ) {
        return UIEdgeInsetsMake(25, 10, 0, 10);
    }

    return UIEdgeInsetsMake(10, 10, 0, 10);
}

+(float)minimumSpacingForMenuCellItemInPortrait {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;

    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == iphone4Height) {
        return screenWidth * 0.0552;
    }

    if ( IDIOM == IPAD ) {
        return screenWidth * 0.069;
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

+(BOOL)deviceIsIphone4 {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == iphone4Height) {
        return YES;
    }
    return NO;
}

+(BOOL)deviceIsIpad {
    if ( IDIOM == IPAD ) {
        return YES;
    }
    return NO;
}

+(CGSize)iPhone4CellItemSize {
    return CGSizeMake(53.815, 53.815);
}

@end
