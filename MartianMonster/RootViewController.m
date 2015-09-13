//
//  RootViewController.m
//  MartianMonster
//
//  Created by Vik Denic on 9/12/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISlider *slider;

@end

@implementation RootViewController {
    NSInteger lastPageBeforeRotate;
//    UIPanGestureRecognizer *scrollViewPanGestureRecognzier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ((UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout).minimumLineSpacing = 0;

//    self.slider.exclusiveTouch = YES;
}

#pragma mark - UICollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SampleCell" forIndexPath:indexPath];

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size;
}

#pragma mark - Orientation
- (void)viewWillLayoutSubviews;
{
    [super viewWillLayoutSubviews];

    UICollectionViewFlowLayout *flowLayout = (id)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = self.view.frame.size;

    [flowLayout invalidateLayout]; //force the elements to get laid out again with the new size
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    int pageWidth = self.collectionView.contentSize.width / 3;
    int scrolledX = self.collectionView.contentOffset.x;
    lastPageBeforeRotate = 0;

    if (pageWidth > 0) {
        lastPageBeforeRotate = scrolledX / pageWidth;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (lastPageBeforeRotate != -1) {
        self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width * lastPageBeforeRotate, 0);
        lastPageBeforeRotate = -1;
    }
}

@end
