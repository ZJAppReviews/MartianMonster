//
//  ViewController.h
//  MartianMonster
//
//  Created by Vik Denic on 8/16/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SampleType) {
    OuterSpace,
    Creatures,
    Phun
};

@interface OuterSpaceViewController : UIViewController

@property SampleType sampleType;

@end

