//
//  LayoutManager.h
//  MartianMonster
//
//  Created by Vik Denic on 2/14/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** The LayoutManager is responsible for tweaking the layout of views (namely the MenuCollectionView). There are certain cases where the desired spacing could not be achieved solely in Storyboard. And so the LayoutManager provides information on spacing and insets for situations such as landscape mode, iPads, iPhone 4, and iPhone 6 plus. It leverages the Device Type Category on UIDevice to distinguish between devices.
 *  @class LayoutManager
 */
@interface LayoutManager : NSObject

/**
 *  Provides the proper edgeInsets for the MenuCollectionView
 *
 *  @return the proper edgeInsets for the MenuCollectionView
 */
+(UIEdgeInsets)edgeInsetsForMenu;

/**
 *  provides the proper minimumLineSpacing between menu items for all iPads
 *
 *  @return the proper minimumLineSpacing between menu items for all iPads
 */
+(CGFloat)menuMinLineSpacingIpad;

/**
 *  provides the proper minimumLineSpacing between menu items for all iPhones when in landscape orientation
 *
 *  @return the proper minimumLineSpacing between menu items for all iPhones when in landscape orientation
 */
+(CGFloat)menuMinLineSpacingIphoneLandscape;

/**
 *  provides the proper minimumLineSpacing between menu items for the iPhone 4 when in landscape orientation
 *
 *  @return the proper minimumLineSpacing between menu items for the iPhone 4 when in landscape orientation
 */
+(CGFloat)menuMinLineSpacingIphone4;

@end
