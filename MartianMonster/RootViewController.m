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
#import "UIColor+Custom.h"
#import "UIView+Layout.h"
#import "LayoutManager.h"
#import "UIDevice+DeviceType.h"

@interface RootViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, SoundboardCollectionViewCellDelegate, MenuCollectionViewCellDelegate>

#pragma mark - Data
@property NSMutableArray *soundboardsArray; //holds all the soundbites for each button
@property NSMutableArray *bgSoundItems; //holds the songs that can be played in background

#pragma  mark - Audio
@property (nonatomic, strong) AVAudioEngine *engine;

#pragma  mark - Layout
@property CGFloat menuMinLineSpacingPortrait;

#pragma  mark - Controllers
@property UIActivityViewController *activityVC;

#pragma  mark - IBOutlets
@property (strong, nonatomic) IBOutlet UICollectionView *soundboardCollectionView;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UICollectionView *menuCollectionView;

@end

#pragma  mark - Constants
NSString *const kPlistSoundInfo = @"SoundInfo";
NSString *const kPlistBgSongInfo = @"BgSongInfo";

NSString *const kShareText1 = @"My spaceship just blasted off";
NSString *const kShareText2 = @"My trip was short";
NSString *const kShareTextSuffix = @"via the Martian Monster App!";
NSString *const kAppLink = @"http://onelink.to/mmapp";

NSString *const kCellSample = @"SampleCell";
NSString *const kCellMenu = @"MenuCell";
NSString *const kGifFileName = @"space";

@implementation RootViewController {
    NSInteger currentRow;
    NSInteger lastPageBeforeRotate;
}

#pragma  mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialLoadSetUps];
    self.pageControl.numberOfPages = self.soundboardsArray.count;
    ((UICollectionViewFlowLayout *) self.soundboardCollectionView.collectionViewLayout).minimumLineSpacing = 0;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpAudioSessionAndEngine];
}

-(void)initialLoadSetUps {
    self.engine = [AVAudioEngine new];

    self.soundboardsArray = [SoundManager arrayOfSoundboardsFromPlist:kPlistSoundInfo forEngine:self.engine];
    self.bgSoundItems = [[SoundManager arrayOfSoundboardsFromPlist:kPlistBgSongInfo forEngine:self.engine] firstObject];

    [self setUpAudioSessionAndEngine];

    [self setUpDidBecomeActiveNotificationObserver];
    [self setUpAppExitNotificationObserver];

    [self setUpShareVC];
    [self setUpGif];
}

#pragma mark - UICollectionView DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 0) {
        return self.soundboardsArray.count;
    } else {
        return self.bgSoundItems.count + 1;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 0) {
        SoundboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellSample forIndexPath:indexPath];
        cell.delegate = self;

        currentRow = indexPath.row;
        cell.soundItems = self.soundboardsArray[currentRow];

        return cell;
    } else {
        MenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellMenu forIndexPath:indexPath];
        
        cell.delegate = self;

        NSString *rowString = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        [cell.menuButton setImage:[UIImage imageNamed:rowString] forState:UIControlStateNormal];
        [cell.menuButton.imageView setAccessibilityIdentifier:rowString];

        if (indexPath.row < self.bgSoundItems.count) {
            SoundItem *soundItem = self.bgSoundItems[indexPath.row];
            cell.isPlaying = soundItem.playerNode.isPlaying;
        } else {
            cell.isPlaying = NO; //this is the share cell; no soundItem to play
        }
        return cell;
    }
}

#pragma mark - Flow Layout Delegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 0) {
        return self.view.frame.size;
    } else {
        MenuCollectionViewCell *cell = (MenuCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
        UICollectionViewFlowLayout *flowLayout = (id) collectionView.collectionViewLayout;
        CGFloat cellLength = collectionView.frame.size.height - (flowLayout.sectionInset.top + flowLayout.sectionInset.bottom);
        return cell ? cell.frame.size : CGSizeMake(cellLength, cellLength);
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    if (collectionView.tag == 0) {
        return 0;
    }
    
    if ([UIDevice isIpad]) {
        return [LayoutManager menuMinLineSpacingIpad];
    }

    if (!self.menuMinLineSpacingPortrait) {
        UICollectionViewFlowLayout *flowLayout = (id) collectionView.collectionViewLayout;
        self.menuMinLineSpacingPortrait = flowLayout.minimumLineSpacing;
    }

    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        return [LayoutManager menuMinLineSpacingIphoneLandscape];
    }

    if ([UIDevice isIphone4]) {
        return [LayoutManager menuMinLineSpacingIphone4] + 6;
    }

    return self.menuMinLineSpacingPortrait + 7.8;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return [LayoutManager edgeInsetsForMenu];
}

#pragma mark - MenuCollectionViewCellDelegate
-(void)menuCollectionViewCell:(MenuCollectionViewCell *)cell didTapButton:(RoundButton *)button {

    if ([[self.menuCollectionView indexPathForCell:cell] row] == self.bgSoundItems.count)
    {
        [self presentActivityViewController];
        button.backgroundColor = [UIColor customTransluscentDark];
        return;
    }

    if (![self.engine isRunning]) {
        [self setUpAudioSessionAndEngine];
    }

    NSInteger selectedRow = [[self.menuCollectionView indexPathForCell:cell] row];

    SoundItem *soundItem = self.bgSoundItems[selectedRow];

    if (![soundItem.playerNode isPlaying])
    {
        [self stopAllBGsongs];
        [SoundManager scheduleAndPlaySoundItem:soundItem forEngine:self.engine withPitch:self.slider.value];
        cell.isPlaying = YES;
    }
    else {
        [soundItem.playerNode stop];
        cell.isPlaying = NO;
    }
    [self.menuCollectionView reloadData];
}


#pragma mark - SoundboardCollectionViewCellDelegate
-(void)soundboardCollectionViewCell:(SoundboardCollectionViewCell *)cell didTapButton:(UIButton *)button {
    [self playAudioForButton:button];
}

#pragma mark - Orientation Change
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    UICollectionViewFlowLayout *flowLayout = (id)self.soundboardCollectionView.collectionViewLayout;
    flowLayout.itemSize = self.view.frame.size;

    [flowLayout invalidateLayout]; //force the elements to get laid out again with the new size

    [self.menuCollectionView reloadData]; //need to call this or menu button animation stops when soundboard collectionview is scrolled.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    int pageWidth = self.soundboardCollectionView.contentSize.width / 3;
    int scrolledX = self.soundboardCollectionView.contentOffset.x;
    lastPageBeforeRotate = 0;

    if (pageWidth > 0) {
        lastPageBeforeRotate = scrolledX / pageWidth;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //handle self.collectionView:
    if (lastPageBeforeRotate != -1) {
        self.soundboardCollectionView.contentOffset = CGPointMake(self.soundboardCollectionView.bounds.size.width * lastPageBeforeRotate, 0);
        lastPageBeforeRotate = -1;
        [self updateCurrentRowBasedOnOrientation];
    }

    //handle self.menuCollectionView:
    [self.menuCollectionView reloadData];
}

-(void)updateCurrentRowBasedOnOrientation {
    CGFloat pageWidth = self.soundboardCollectionView.frame.size.width;
    currentRow = self.pageControl.currentPage = self.soundboardCollectionView.contentOffset.x / pageWidth;
}


#pragma mark - Start / Stop Audio Helpers
-(void)playAudioForButton:(UIButton *)button {
    if (![self.engine isRunning]) {
        [self setUpAudioSessionAndEngine];
    }

    NSArray *soundItems = self.soundboardsArray[currentRow];
    SoundItem *soundItem = soundItems[button.tag];
    [SoundManager scheduleAndPlaySoundItem:soundItem forEngine:self.engine withPitch:self.slider.value];
}

-(void)stopPlayingAllNodes {
    for (NSArray *sb in self.soundboardsArray) {
        for (SoundItem *si in sb)
        {
            [si.playerNode stop];
        }
    }
}

-(void)stopAllBGsongs {
    for (SoundItem *soundItem in self.bgSoundItems) {
        if ([soundItem.playerNode isPlaying]) {
            [soundItem.playerNode stop];
        }
    }

    NSArray *cells = [self.menuCollectionView allCells];
    for (MenuCollectionViewCell *cell in cells) {
        RoundButton *button = cell.menuButton;
        [button.layer removeAllAnimations];
        button.isAnimating = NO;
        button.backgroundColor = [UIColor customTransluscentDark];
    }
}

#pragma mark - Scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateCurrentRowBasedOnOrientation];

    [self onSliderMoved:self.slider]; // Resets pitch when moving back to previous screen
}

#pragma mark - Slider
- (IBAction)onSliderMoved:(UISlider *)sender {
    NSArray *soundItems = self.soundboardsArray[currentRow];

    for (SoundItem *soundItem in soundItems) {
        soundItem.utPitch.pitch = sender.value;
    }
}

#pragma  mark - App exit / ReEntrance
-(void)setUpDidBecomeActiveNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setUpAudioSessionAndEngine)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void)setUpAppExitNotificationObserver {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResign)
     name:UIApplicationWillResignActiveNotification
     object:nil];
}

-(void)applicationWillResign {
    [self stopPlayingAllNodes];
    [self stopAllBGsongs];
    [self.engine stop];
}

-(void)setUpAudioSessionAndEngine {
    [self.soundboardCollectionView reloadData];
    [SoundManager activateAudioSessionForBackgroundPlay];
//    [SoundManager startEngine:self.engine];
}


#pragma  mark - Share Activity
-(void)presentActivityViewController {
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:self.activityVC animated:YES completion:nil];
    } else { //if iPad
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:self.activityVC]; // Change Rect to position Popover
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(void)setUpShareVC {
    NSArray *textArray = @[kShareText1, kShareText2];
    NSUInteger randomIndex = arc4random() % textArray.count;
    NSString *shareText = [NSString stringWithFormat:@"♫ %@, %@", [textArray objectAtIndex:randomIndex], kShareTextSuffix];

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

#pragma  mark - Gif
-(void)setUpGif {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;

    NSURL *gifURL = [[NSBundle mainBundle] URLForResource:kGifFileName withExtension:@"gif"];
    imageView.image = [UIImage animatedImageWithAnimatedGIFURL:gifURL];

    self.soundboardCollectionView.backgroundView = imageView; // insertSubview:imageView atIndex:0];

    [imageView constrainToSuperview:self.view];
}

#pragma  mark - Orientation Support
//Enables upside-down orientation
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskAll;
}

-(void)didReceiveMemoryWarning {
    
}

@end
