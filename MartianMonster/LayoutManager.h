//
//  LayoutManager.h
//  MartianMonster
//
//  Created by Vik Denic on 2/14/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LayoutManager : NSObject

+(CGSize)sizeForMenuCellItem;

+(UIEdgeInsets)edgeInsetsForMenuCellItem;

+(float)minimumSpacingForMenuCellItemInPortrait;
+(float)minimumSpacingForMenuCellItemInLandscape;

@end
