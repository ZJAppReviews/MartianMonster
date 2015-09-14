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

    self.engine = [AVAudioEngine new];

    ((UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout).minimumLineSpacing = 0;
}

#pragma mark - UICollectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SoundboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SampleCell" forIndexPath:indexPath];
    cell.delegate = self;

    [self configureAudioForCell:cell atIndexPath:indexPath];

    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.buttonTitlesArrays.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size;
}

#pragma mark - Helpers for cell setup
-(void)configureAudioForCell:(SoundboardCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titlesArray = self.buttonTitlesArrays[indexPath.row];

    UIView *cellSuperview = cell.contentView.subviews.lastObject;

    int i = 0;
    for (UIView *view in cellSuperview.subviews)
    {
        if ([view isKindOfClass:[SoundboardButton class]])
        {
            SoundboardButton *button = (SoundboardButton *) view;
            [button setTitle:titlesArray[i] forState:UIControlStateNormal];
            NSLog(@"%@",button.titleLabel.text);

            // Prepare audio file
            button.audioFile = [[AVAudioFile alloc] initWithPathNamed:[NSString stringWithFormat:@"%i0", (int)indexPath.row]
                                                                           ofType:@"m4a"];
            // Prepare Buffer Zero
            AVAudioFormat *audioFormatZero = button.audioFile.processingFormat;
            AVAudioFrameCount lengthZero = (AVAudioFrameCount)button.audioFile.length;
            button.audioPCMBuffer = [[AVAudioPCMBuffer alloc]initWithPCMFormat:audioFormatZero frameCapacity:lengthZero];
            [button.audioFile readIntoBuffer:button.audioPCMBuffer error:nil];

            // Prepare AVAudioPlayerNode Zero
            button.playerNode = [AVAudioPlayerNode new];
            button.playerNode.volume = 0.55;
            [self.engine attachNode:button.playerNode];

            // Set pitch (if applicable) and connect nodes
            AVAudioMixerNode *mixerNode = [self.engine mainMixerNode];
            if (button.pitchEffect)
            {
                //pitches
                button.utPitch = [AVAudioUnitTimePitch new];
                button.utPitch.pitch = 0.0;
                button.utPitch.rate = 1.0;
                [self.engine attachNode:button.utPitch];

                //connect Nodes
                [self.engine connect:button.playerNode
                                  to:button.utPitch
                              format:button.audioFile.processingFormat];
                [self.engine connect:button.utPitch
                                  to:mixerNode
                              format:button.audioFile.processingFormat];
            }
            else
            {
                //only connect nodes (no pitches)
                [self.engine connect:button.playerNode
                                  to:mixerNode
                              format:button.audioFile.processingFormat];
            }
        }
        i++;
    }

    // Start engine
    NSError *error;
    [self.engine startAndReturnError:&error];
    if (error) {
        NSLog(@"error:%@", error);
    }
}

#pragma mark - SoundboardCollectionViewCellDelegate
-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapTopLeftButton:(SoundboardButton *)button
{
//    if ([button.playerNode isPlaying])
//    {
//        [button.playerNode stop];
//    }
//    else
//    {
        // Schedule playing audio buffer
        [button.playerNode scheduleBuffer:button.audioPCMBuffer
                                   atTime:nil
                                  options:AVAudioPlayerNodeBufferInterrupts
                        completionHandler:nil];
        
        [button.playerNode play];
//    }
}

-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapMiddleButton:(SoundboardButton *)button
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
