//
//  RootViewController.m
//  MartianMonster
//
//  Created by Vik Denic on 9/12/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "RootViewController.h"
@import AVFoundation;
#import "AVAudioFile+Constructors.h"
#import "SoundboardCollectionViewCell.h"
#import "SoundboardButton.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SoundboardCollectionViewCellDelegate>
#pragma mark - info
@property NSArray *buttonTitlesArrays;

#pragma  mark - audio properties
@property (nonatomic, strong) AVAudioEngine *engine;

#pragma  mark - view outlets
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISlider *slider;

@end

@implementation RootViewController
{
    NSInteger lastPageBeforeRotate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *buttonTitlesArray1 =  @[@"(blip)", @"(ufo)", @"BLAST OFF!", @"SPEED", @"TRIP"];
    NSArray *buttonTitlesArray2 =  @[@"oOoOo", @"ahhHH", @"THEY ATTACK!", @"meow", @"MEOW"];
    NSArray *buttonTitlesArray3 =  @[@"vacuum", @"whale", @"BOMB", @"bell", @"drill"];
    self.buttonTitlesArrays = @[buttonTitlesArray1, buttonTitlesArray2, buttonTitlesArray3];

    ((UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout).minimumLineSpacing = 0;
}

#pragma mark - UICollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SoundboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SampleCell" forIndexPath:indexPath];
    cell.delegate = self;

    [self setButtonTitlesForCell:cell withIndexPath:indexPath];
    return cell;
}

-(void)setButtonTitlesForCell:(SoundboardCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titlesArray = self.buttonTitlesArrays[indexPath.row];

    [cell.topLeftButton setTitle:titlesArray[0] forState:UIControlStateNormal];
    [cell.topRightButton setTitle:titlesArray[1] forState:UIControlStateNormal];
    [cell.middleButton setTitle:titlesArray[2] forState:UIControlStateNormal];
    [cell.bottomLeftButton setTitle:titlesArray[3] forState:UIControlStateNormal];
    [cell.bottomRightButton setTitle:titlesArray[4] forState:UIControlStateNormal];

    cell.topLeftButton.audioFile = [[AVAudioFile alloc] initWithPathNamed:[NSString stringWithFormat:@"%i0", (int)indexPath.row]
                                                                                    ofType:@"m4a"];
    cell.topRightButton.audioFile = [[AVAudioFile alloc] initWithPathNamed:[NSString stringWithFormat:@"%i1", (int)indexPath.row]
                                                                   ofType:@"m4a"];
    cell.middleButton.audioFile = [[AVAudioFile alloc] initWithPathNamed:[NSString stringWithFormat:@"%i2", (int)indexPath.row]
                                                                   ofType:@"m4a"];
    cell.bottomLeftButton.audioFile = [[AVAudioFile alloc] initWithPathNamed:[NSString stringWithFormat:@"%i3", (int)indexPath.row]
                                                                   ofType:@"m4a"];
    cell.bottomRightButton.audioFile = [[AVAudioFile alloc] initWithPathNamed:[NSString stringWithFormat:@"%i4", (int)indexPath.row]
                                                                   ofType:@"m4a"];
}

-(AVAudioFile *)audioFileWithName:(NSString *)name
{
    NSString *pathZero = [[NSBundle mainBundle] pathForResource:name ofType:@"m4a"];
    return [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:pathZero]
                                                       error:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.buttonTitlesArrays.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size;
}

#pragma mark - SoundboardCollectionViewCell
-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapMiddleButton:(UIButton *)button
{

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
