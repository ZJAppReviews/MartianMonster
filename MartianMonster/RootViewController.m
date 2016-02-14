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
#import "MenuCollectionViewCell.h"
#import "SoundManager.h"
#import "Soundboard.h"
#import "SoundItem.h"

#import "RoundButton.h"
#import "UIImage+animatedGif.h"
#import "UICollectionView+CellRetrieval.h"
#import "LayoutManager.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, SoundboardCollectionViewCellDelegate, MenuCollectionViewCellDelegate>

#pragma mark - info
@property NSMutableArray *soundboardsArray; //holds all the soundbites for each button
@property NSMutableArray *bgSoundItems; //holds the songs that can be played in background

#pragma  mark - audio properties
@property (nonatomic, strong) AVAudioEngine *engine;

#pragma  mark - view outlets
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UICollectionView *menuCollectionView;

//@property (strong, nonatomic) IBOutletCollection(RoundButton) NSArray *menuButtons;

@property CABasicAnimation *pulseAnimation;

@property UIActivityViewController *activityVC;

@end

NSString *const kPlistSoundInfo = @"SoundInfo";
NSString *const kPlistBgSongInfo = @"BgSongInfo";
NSString *const kAppLink = @"http://onelink.to/mmapp";

@implementation RootViewController
{
    NSInteger currentRow;
    NSInteger lastPageBeforeRotate;
}

#pragma  mark - view lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.engine = [AVAudioEngine new];

    self.soundboardsArray = [SoundManager arrayOfSoundboardsFromPlist:kPlistSoundInfo forEngine:self.engine];
    self.bgSoundItems = [[SoundManager arrayOfSoundboardsFromPlist:kPlistBgSongInfo forEngine:self.engine] firstObject];

    [self didBecomeActive];

    self.pageControl.numberOfPages = self.soundboardsArray.count;
    ((UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout).minimumLineSpacing = 0;

    [self setupPulsateAnimation];

    [self handleAppReentrance];
    [self handleAppExit];

    [self setUpShareVC];
    [self spaceGif];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self didBecomeActive];
}

-(void)setUpShareVC
{
    NSArray *textArray = @[@"My spaceship just blasted off", @"My trip was short"];
    NSUInteger randomIndex = arc4random() % textArray.count;
    NSString *textSuffix = @"via the Martian Monster App!";
    NSString *shareText = [NSString stringWithFormat:@"♫ %@, %@", [textArray objectAtIndex:randomIndex], textSuffix];

    NSURL *shareURL = [NSURL URLWithString:kAppLink];

    NSArray *objectsToShare = @[shareText, shareURL];

    self.activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];

    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];

    self.activityVC.excludedActivityTypes = excludeActivities;
}

-(void)spaceGif
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;

    NSURL *gifURL = [[NSBundle mainBundle] URLForResource:@"space" withExtension:@"gif"];
    imageView.image = [UIImage animatedImageWithAnimatedGIFURL:gifURL];

    self.collectionView.backgroundView = imageView; // insertSubview:imageView atIndex:0];
    [self constrainView:imageView toSuperview:self.view];
}

-(void)presentActivityViewController
{
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:self.activityVC animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:self.activityVC];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - UICollectionView DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 0) {
        return self.soundboardsArray.count;
    } else {
        return self.bgSoundItems.count + 1;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        SoundboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SampleCell" forIndexPath:indexPath];
        cell.delegate = self;

        currentRow = indexPath.row;
        [self setUpViewsForCell:cell atIndexPath:indexPath];

        return cell;
    } else {
        MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MenuCell" forIndexPath:indexPath];
        cell.delegate = self;

        NSString *rowString = [NSString stringWithFormat:@"%ld", indexPath.row];
        [cell.menuButton setImage:[UIImage imageNamed:rowString] forState:UIControlStateNormal];

        //TODO: Layout something
        if (indexPath.row == 0) {
//            [self adjustMenuCollectionViewCellSpacingWithCell:cell];
            ((UICollectionViewFlowLayout *) self.menuCollectionView.collectionViewLayout).minimumLineSpacing = [LayoutManager minimumSpacingForMenuCellItemInPortrait];
        }

        return cell;
    }
}

#pragma mark - Flow Layout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 0) {
        return self.view.frame.size;
    } else {
        MenuCollectionViewCell *cell = (MenuCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];

        return cell ? cell.frame.size : CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return [LayoutManager edgeInsetsForMenuCellItem];
    }
}

//#pragma mark - Flow Layout
//-(void)adjustMenuCollectionViewCellSpacingWithCell:(MenuCollectionViewCell *)cell {
////    float screenWidth = [UIScreen mainScreen].bounds.size.width;
////    float itemGirth = (self.bgSoundItems.count + 1) * cell.frame.size.width;
////
//    ((UICollectionViewFlowLayout *) self.menuCollectionView.collectionViewLayout).minimumLineSpacing = [LayoutManager minimumSpacingForMenuCellItemInPortrait];
//}

#pragma mark - SoundboardCollectionViewCellDelegate
-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapButton:(UIButton *)button
{
    [self playAudioForButton:button];
}

//Not getting called?
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 200;
}

#pragma mark - MenuCollectionViewCellDelegate
-(void)menuCollectionViewCell:(MenuCollectionViewCell *)cell didTapButton:(RoundButton *)button {

    if ([[self.menuCollectionView indexPathForCell:cell] row] == self.bgSoundItems.count)
    {
        [self presentActivityViewController];
        button.backgroundColor = [UIColor colorWithRed:11/255.0 green:11/255.0 blue:11/255.0 alpha:0.33];
        return;
    }

    if (![self.engine isRunning]) {
        [self didBecomeActive];
    }

    NSInteger selectedRow = [[self.menuCollectionView indexPathForCell:cell] row];

    SoundItem *soundItem = self.bgSoundItems[selectedRow];

    if (![soundItem.playerNode isPlaying])
    {
        [self stopAllBGsongs];
        [SoundManager scheduleAndPlaySoundItem:soundItem];
        [button.layer addAnimation:self.pulseAnimation forKey:nil];
        button.isAnimating = YES;
        button.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:255/255.0 alpha:0.8];
    }
    else
    {
        [soundItem.playerNode stop];
        [button.layer removeAllAnimations];
        button.isAnimating = NO;
        button.backgroundColor = [UIColor colorWithRed:11/255.0 green:11/255.0 blue:11/255.0 alpha:0.33];
    }
}

#pragma mark - SoundboardCell View Helper
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

#pragma mark - Animation helper

-(void)setupPulsateAnimation
{
    self.pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    self.pulseAnimation.duration = .5;
    self.pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
    self.pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    self.pulseAnimation.autoreverses = YES;
    self.pulseAnimation.repeatCount = FLT_MAX;
}

#pragma  mark - app exit / reentrance
-(void)handleAppReentrance
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void)didBecomeActive
{
    [self.collectionView reloadData];
    [SoundManager startEngine:self.engine];
    [SoundManager activateAudioSessionForBackgroundPlay];
}

-(void)handleAppExit
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResign)
     name:UIApplicationWillResignActiveNotification
     object:nil];
}

-(void)applicationWillResign
{
    //    [self.engine stop];
    [self stopPlayingAllNodes];
    [self stopAllBGsongs];
    [self.engine stop];
}

#pragma mark - play / stop audio helpers
-(void)playAudioForButton:(UIButton *)button
{
    if (![self.engine isRunning]) {
        [self didBecomeActive];
    }

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

-(void)stopPlayingAllNodes
{
    for (NSArray *sb in self.soundboardsArray)
    {
        for (SoundItem *si in sb)
        {
            [si.playerNode stop];
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

    NSArray *cells = [self.menuCollectionView allCells];

    for (MenuCollectionViewCell *cell in cells)
    {
        RoundButton *button = cell.menuButton;
        [button.layer removeAllAnimations];
        button.isAnimating = NO;
        button.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.20];
    }
}

#pragma mark - Scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentRowBasedOnOrientation];

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
    MenuCollectionViewCell *cell = (MenuCollectionViewCell *) [self.menuCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    //TODO: Layout something
//    [self adjustMenuCollectionViewCellSpacingWithCell:cell];
    ((UICollectionViewFlowLayout *) self.menuCollectionView.collectionViewLayout).minimumLineSpacing = [LayoutManager minimumSpacingForMenuCellItemInLandscape];

    if (lastPageBeforeRotate != -1)
    {
        self.collectionView.contentOffset = CGPointMake(self.collectionView.bounds.size.width * lastPageBeforeRotate, 0);
        lastPageBeforeRotate = -1;
        [self updateCurrentRowBasedOnOrientation];
    }

    NSArray *cells = [self.menuCollectionView allCells];

    for (MenuCollectionViewCell *cell in cells)
    {
        RoundButton *button = cell.menuButton;
        button.layer.cornerRadius = button.bounds.size.width / 2;
    }
}

-(void)updateCurrentRowBasedOnOrientation
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    currentRow = self.pageControl.currentPage = self.collectionView.contentOffset.x / pageWidth;
}

//Enables upside-down orientation
-(NSUInteger)supportedInterfaceOrientations
{
    return (int) UIInterfaceOrientationMaskAll;
}

//Constraint helper
-(void)constrainView:(UIView *)containerView toSuperview:(UIView *)superview
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:containerView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:containerView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:containerView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:containerView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:superview
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
}

@end
