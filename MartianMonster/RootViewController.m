//
//  RootViewController.m
//  MartianMonster
//
//  Created by Vik Denic on 9/12/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "RootViewController.h"
@import AVFoundation;
#import "SoundboardCollectionViewCell.h"
#import "SoundManager.h"
#import "Soundboard.h"
#import "SoundItem.h"

#import "BubbularMenuView.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, SoundboardCollectionViewCellDelegate, BubbularMenuViewDelegate>

#pragma mark - info
@property NSMutableArray *soundboardsArray; //holds all the soundbites for each button
@property NSMutableArray *bgSoundItems; //holds the songs that can be played in background

#pragma  mark - audio properties
@property (nonatomic, strong) AVAudioEngine *engine;

#pragma  mark - view outlets
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end

NSString *const kPlistSoundInfo = @"SoundInfo";
NSString *const kPlistBgSongInfo = @"BgSongInfo";

@implementation RootViewController
{
    NSInteger currentRow;
    NSInteger lastPageBeforeRotate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.engine = [AVAudioEngine new];

    self.soundboardsArray = [SoundManager arrayOfSoundboardsFromPlist:kPlistSoundInfo forEngine:self.engine];
    self.bgSoundItems = [[SoundManager arrayOfSoundboardsFromPlist:kPlistBgSongInfo forEngine:self.engine] firstObject];

    [SoundManager startEngine:self.engine];
    [SoundManager activateAudioSessionForBackgroundPlay];

    self.pageControl.numberOfPages = self.soundboardsArray.count;
    ((UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout).minimumLineSpacing = 0;

    [self addBubbularMenuView];
}

-(void)addBubbularMenuView
{
    BubbularMenuView *menuView = [[BubbularMenuView alloc] initWithMenuItemCount:3 andButtonCircumference:self.view.frame.size.width / 7.25];
    menuView.delegate = self;
    menuView.spacing = self.view.frame.size.width / 3.5;
    menuView.direction = BubbularDirectionHorizontal;
    menuView.images = [self menuImages];
//    menuView.buttonBorderColor = [self customRedColor];
    menuView.buttonBackgroundColor = [UIColor grayColor];
    menuView.alpha = 1.0;
    menuView.buttonBorderWidth = 0;

    [self.view addSubview:menuView];
}

-(NSArray *)menuImages
{
    UIImage *image0 = [UIImage imageNamed:@"play"];
    UIImage *image1 = [UIImage imageNamed:@"rocket"];
    UIImage *image2 = [UIImage imageNamed:@"cat"];
    UIImage *image3 = [UIImage imageNamed:@"ghost"];

    return @[image0,image1,image2,image3];
}

-(void)bubbularMenuView:(BubbularMenuView *)menuView didTapMenuButton:(UIButton *)button
{
    if (button.tag == 0)
    {
        //play or pause the currently playing bg song
        //change this buttons image between play and pause button
    }
    else
    {
        SoundItem *soundItem = self.bgSoundItems[button.tag - 1];

        if (![soundItem.playerNode isPlaying])
        {
            [self stopAllBGsongs];
            [SoundManager scheduleAndPlaySoundItem:soundItem];
        }
        else
        {
            [soundItem.playerNode stop];
        }
    }
}

-(void)stopAllBGsongs
{
    for (SoundItem *soundItem in self.bgSoundItems)
    {
        if ([soundItem.playerNode isPlaying])
        {
            [soundItem.playerNode stop];
        }
    }
}

#pragma mark - UICollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SoundboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SampleCell" forIndexPath:indexPath];
    cell.delegate = self;

    currentRow = indexPath.row;

    [self setUpViewsForCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - View setup
-(void)setUpViewsForCell:(SoundboardCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *soundItems = self.soundboardsArray[currentRow];

    UIView *cellSuperview = cell.contentView.subviews.lastObject;

    for (UIView *view in cellSuperview.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton *) view;
            SoundItem *soundItem = soundItems[button.tag];
            [button setTitle:soundItem.displayText forState:UIControlStateNormal];

            if (soundItem.bufferOption == AVAudioPlayerNodeBufferLoops)
            {
                if ([soundItem.playerNode isPlaying])
                {
                    [button setTitle:@"" forState:UIControlStateNormal];
                }
                else
                {
                    [button setTitle:soundItem.displayText forState:UIControlStateNormal];
                    [button setImage:nil forState:UIControlStateNormal];
                }
            }
        }
    }
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
-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapButton:(UIButton *)button
{
    [self playAudioForButton:button];
}

#pragma mark - Play audio helpers
-(void)playAudioForButton:(UIButton *)button
{
    NSArray *soundItems = self.soundboardsArray[currentRow];
    SoundItem *soundItem = soundItems[button.tag];

    if (soundItem.bufferOption == AVAudioPlayerNodeBufferLoops)
    {
        if ([soundItem.playerNode isPlaying])
        {
            [soundItem.playerNode stop];
            [button setTitle:soundItem.displayText forState:UIControlStateNormal];
            [button setImage:nil forState:UIControlStateNormal];
        }
        else
        {
            [SoundManager scheduleAndPlaySoundItem:soundItem];
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            button.tintColor = [UIColor whiteColor];
        }
    }
    else
    {
        [SoundManager scheduleAndPlaySoundItem:soundItem];
    }
}

#pragma mark - Scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    currentRow = self.pageControl.currentPage = self.collectionView.contentOffset.x / pageWidth;

    [self onSliderMoved:self.slider]; // Resets pitch appropriately when moving back to a previous screen
}

#pragma mark - Slider
- (IBAction)onSliderMoved:(UISlider *)sender
{
    NSArray *soundItems = self.soundboardsArray[currentRow];

    for (SoundItem *soundItem in soundItems)
    {
        soundItem.utPitch.pitch = sender.value;
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    int pageWidth = self.collectionView.contentSize.width / 3;
    int scrolledX = self.collectionView.contentOffset.x;
    lastPageBeforeRotate = 0;

    if (pageWidth > 0)
    {
        lastPageBeforeRotate = scrolledX / pageWidth;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (lastPageBeforeRotate != -1)
    {
        self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width * lastPageBeforeRotate, 0);
        lastPageBeforeRotate = -1;
    }
}

//Enables upside-down orientation
-(NSUInteger)supportedInterfaceOrientations
{
    return (int) UIInterfaceOrientationMaskAll;
}

@end
