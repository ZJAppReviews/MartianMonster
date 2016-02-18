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

+(UIEdgeInsets) edgeInsetsForMenu;
+(CGFloat) menuMinLineSpacingIpad;
+(CGFloat) menuMinLineSpacingIphoneLandscape;
+(CGFloat) menuMinLineSpacingIphone4;

@end
