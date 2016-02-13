//
//  UICollectionView+CellRetrieval.m
//  MartianMonster
//
//  Created by Vik Denic on 2/13/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import "UICollectionView+CellRetrieval.h"

@implementation UICollectionView (CellRetrieval)

-(NSArray *) allCells {
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for (NSInteger j = 0; j < [self numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self numberOfItemsInSection:j]; ++i)
        {
            [cells addObject:[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]]];
        }
    }
    return [cells copy];
}

@end
