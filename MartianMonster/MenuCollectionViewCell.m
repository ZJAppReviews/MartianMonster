//
//  MenuCollectionViewCell.m
//  MartianMonster
//
//  Created by Vik Denic on 2/13/16.
//  Copyright © 2016 vikzilla. All rights reserved.
//

#import "MenuCollectionViewCell.h"

@implementation MenuCollectionViewCell

- (IBAction)didTapButton:(id)sender {
    [self.delegate menuCollectionViewCell:self didTapButton:sender];
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//}

@end
