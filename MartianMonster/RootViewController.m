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
#import "SoundManager.h"
#import "Soundboard.h"
#import "SoundItem.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SoundboardCollectionViewCellDelegate>
#pragma mark - info
@property NSMutableArray *soundboardsArray;

#pragma  mark - audio properties
@property (nonatomic, strong) AVAudioEngine *engine;

#pragma  mark - view outlets
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISlider *slider;

@end

@implementation RootViewController
{
    NSInteger currentRow;
    NSInteger lastPageBeforeRotate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.engine = [AVAudioEngine new];
    self.soundboardsArray = [SoundManager arrayOfSoundboardsFromPlistforEngine:self.engine];
//    NSLog(@"%@", self.soundboardsArray);

    // Start engine
    NSError *error;
    [self.engine startAndReturnError:&error];
    if (error) {
        NSLog(@"error:%@", error);
    }

    ((UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout).minimumLineSpacing = 0;
}

#pragma mark - UICollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SoundboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SampleCell" forIndexPath:indexPath];
    cell.delegate = self;

    currentRow = indexPath.row;

    NSArray *soundItems = self.soundboardsArray[indexPath.row];

    UIView *cellSuperview = cell.contentView.subviews.lastObject;

    int i = 0;
    for (UIView *view in cellSuperview.subviews)
    {
        if ([view isKindOfClass:[SoundboardButton class]])
        {
            SoundboardButton *button = (SoundboardButton *) view;
            button.soundItem = soundItems[i];
            i++;
        }
    }

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.soundboardsArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size;
}

#pragma mark - SoundboardCollectionViewCellDelegate
-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapTopLeftButton:(SoundboardButton *)button
{
    [self.collectionView reloadData];
    NSArray *soundItems = self.soundboardsArray[currentRow];
    SoundItem *soundItem = soundItems[button.tag];

    if ([soundItem.playerNode isPlaying])
    {
        [soundItem.playerNode stop];
    }
    else
    {
        // Schedule playing audio buffer
        [soundItem.playerNode scheduleBuffer:soundItem.audioPCMBuffer
                                      atTime:nil
                                     options:soundItem.bufferOption
                           completionHandler:nil];

        [soundItem.playerNode play];
    }
}

-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapMiddleButton:(SoundboardButton *)button
{
    NSArray *soundItems = self.soundboardsArray[currentRow];
    SoundItem *soundItem = soundItems[button.tag];

    if ([soundItem.playerNode isPlaying])
    {
        [soundItem.playerNode stop];
    }
    else
    {
        // Schedule playing audio buffer
        [soundItem.playerNode scheduleBuffer:soundItem.audioPCMBuffer
                                      atTime:nil
                                     options:soundItem.bufferOption
                           completionHandler:nil];

        [soundItem.playerNode play];
    }
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
