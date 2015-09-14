//
//  AVAudioFile+Constructors.m
//  MartianMonster
//
//  Created by Vik Denic on 9/13/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "AVAudioFile+Constructors.h"

@implementation AVAudioFile (Constructors)

- (instancetype)initWithPathNamed:(NSString *)name ofType:(NSString *)type;
{
    NSString *pathZero = [[NSBundle mainBundle] pathForResource:name ofType:type];
    return [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:pathZero]
                                         error:nil];
}

@end