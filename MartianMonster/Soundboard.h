//
//  Soundboard.h
//  MartianMonster
//
//  Created by Vik Denic on 9/14/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Soundboard : NSObject

@property NSMutableArray *soundItems;

- (instancetype)initWithDisplayTexts:(NSArray *)displayTexts;

@end
