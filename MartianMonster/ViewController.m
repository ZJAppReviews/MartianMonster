//
//  ViewController.m
//  MartianMonster
//
//  Created by Vik Denic on 8/16/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;
#import "UIImage+animatedGif.h"
#import "FBShimmeringView.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *topLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *topRightButton;
@property (strong, nonatomic) IBOutlet UIButton *middleButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomRightButton;
@property (strong, nonatomic) IBOutlet UIButton *bannerButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bannerVerticalConstraint;

//One audio engine to manage many nodes
@property (nonatomic, strong) AVAudioEngine *engine;

//Many audioPlayer nodes to control each sound effect independently
@property (nonatomic, strong) AVAudioPlayerNode *audioPlayerNodeZero;
@property (nonatomic, strong) AVAudioPlayerNode *audioPlayerNodeOne;
@property (nonatomic, strong) AVAudioPlayerNode *audioPlayerNodeTwo;
@property (nonatomic, strong) AVAudioPlayerNode *audioPlayerNodeThree;
@property (nonatomic, strong) AVAudioPlayerNode *audioPlayerNodeFour;

@property (nonatomic, strong) AVAudioFile *audioFileZero;
@property (nonatomic, strong) AVAudioFile *audioFileOne;
@property (nonatomic, strong) AVAudioFile *audioFileTwo;
@property (nonatomic, strong) AVAudioFile *audioFileThree;
@property (nonatomic, strong) AVAudioFile *audioFileFour;


@property (nonatomic, strong) AVAudioPCMBuffer *audioPCMBufferZero;
@property (nonatomic, strong) AVAudioPCMBuffer *audioPCMBufferOne;
@property (nonatomic, strong) AVAudioPCMBuffer *audioPCMBufferTwo;
@property (nonatomic, strong) AVAudioPCMBuffer *audioPCMBufferThree;
@property (nonatomic, strong) AVAudioPCMBuffer *audioPCMBufferFour;

//A unitTimePitch object for each audio file that needs pitch manipulation
@property (nonatomic, strong) AVAudioUnitTimePitch *utPitchTwo;
@property (nonatomic, strong) AVAudioUnitTimePitch *utPitchThree;
@property (nonatomic, strong) AVAudioUnitTimePitch *utPitchFour;

@property (strong, nonatomic) IBOutlet UISlider *slider;

@end

static NSString * const kURLiTunesAlbum = @"https://geo.itunes.apple.com/us/album/chilling-thrilling-sounds/id272258499?at=10lu5f&mt=1&app=music";

@implementation ViewController {
    SystemSoundID soundEffect;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    for (UIButton *button in self.view.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            [self formatButtonLabel:button];
        }
    }

    [self addGIFtoMiddleButton];
    [self initiateBannerPresentation];
    [self hideAndShowBannerEvery15secs];
    [self shimmer];
    [self audioSetUp];
}

#pragma mark - Banner Button
-(void)initiateBannerPresentation
{
    [NSTimer scheduledTimerWithTimeInterval:2.75 target:self selector:@selector(showBanner) userInfo:nil repeats:NO];
}

//Shows and hides banner every 15 seconds
-(void)hideAndShowBannerEvery15secs
{
    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(hideBanner) userInfo:nil repeats:YES];

    [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(showBannerEvery15secs) userInfo:nil repeats:NO];
}

-(void)showBannerEvery15secs
{
    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(showBanner) userInfo:nil repeats:YES];
}

//The bannerButton's vertical constant is set to -50 in Storyboard
-(void)showBanner
{
    if (self.bannerVerticalConstraint.constant == -50.0)
    {
        self.bannerVerticalConstraint.constant += 50;
        [self.bannerButton setNeedsUpdateConstraints];

        [UIView animateWithDuration:1.0f animations:^{
            [self.bannerButton layoutIfNeeded];
        }];
    }
}

-(void)hideBanner
{
    if (self.bannerVerticalConstraint.constant == 0)
    {
        self.bannerVerticalConstraint.constant -= 50;
        [self.bannerButton setNeedsUpdateConstraints];

        [UIView animateWithDuration:1.0f animations:^{
            [self.bannerButton layoutIfNeeded];
        }];
    }
}

//FBShimmeringView installed via cocoapod: https://github.com/facebook/Shimmer
-(void)shimmer
{
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.bannerButton.bounds];
    shimmeringView.alpha = 0.50;
    shimmeringView.shimmeringSpeed = 230;
    shimmeringView.shimmeringPauseDuration = 0;
    [self.bannerButton addSubview:shimmeringView];

    UIView *cView = [[UIView alloc] initWithFrame:shimmeringView.bounds];
    [cView setBackgroundColor:[UIColor blueColor]];
    shimmeringView.contentView = cView;

    shimmeringView.shimmering = YES;
    shimmeringView.userInteractionEnabled = NO;
}

- (IBAction)onBannerButtonTapped:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURLiTunesAlbum]];
}

#pragma mark - Audio
//Audio files' names correlate to a button's tag
- (IBAction)onTopRowButtonTapped:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        if (self.audioPlayerNodeZero.isPlaying)
        {
            [self.audioPlayerNodeZero stop];
//            [self playZero];
        } else {
            [self playZero];
        }
    }
    else
    {
        if (self.audioPlayerNodeOne.isPlaying)
        {
            [self.audioPlayerNodeOne stop];
//            [self playOne];
        } else {
            [self playOne];
        }
    }
}

- (IBAction)onMiddleButtonTapped:(UIButton *)sender
{
    [self playTwo];
}

- (IBAction)onBottomLeftButtonTapped:(UIButton *)sender
{
    [self playThree];
}

- (IBAction)onBottomRightButtonTapped:(UIButton *)sender
{
    [self playFour];
}

-(void)audioSetUp
{
    self.engine = [AVAudioEngine new];

    // Prepare AVAudioFile Zero
    NSString *pathZero = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"m4a"];
    self.audioFileZero = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:pathZero]
                                                   error:nil];

    // Prepare AVAudioFile One
    NSString *pathOne = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"m4a"];
    self.audioFileOne = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:pathOne]
                                                       error:nil];

    // Prepare AVAudioFile Two
    NSString *pathTwo = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"m4a"];
    self.audioFileTwo = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:pathTwo]
                                                      error:nil];

    // Prepare AVAudioFile Three
    NSString *pathThree = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"m4a"];
    self.audioFileThree = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:pathThree]
                                                      error:nil];

    // Prepare AVAudioFile Four
    NSString *pathFour = [[NSBundle mainBundle] pathForResource:@"4" ofType:@"m4a"];
    self.audioFileFour = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:pathFour]
                                                        error:nil];
    // Prepare Buffer Zero
    AVAudioFormat *audioFormatZero = self.audioFileZero.processingFormat;
    AVAudioFrameCount lengthZero = (AVAudioFrameCount)self.audioFileZero.length;
    self.audioPCMBufferZero = [[AVAudioPCMBuffer alloc]initWithPCMFormat:audioFormatZero frameCapacity:lengthZero];
    [self.audioFileZero readIntoBuffer:self.audioPCMBufferZero error:nil];

    // Prepare Buffer One
    AVAudioFormat *audioFormatOne = self.audioFileOne.processingFormat;
    AVAudioFrameCount lengthOne = (AVAudioFrameCount)self.audioFileOne.length;
    self.audioPCMBufferOne = [[AVAudioPCMBuffer alloc]initWithPCMFormat:audioFormatOne frameCapacity:lengthOne];
    [self.audioFileOne readIntoBuffer:self.audioPCMBufferOne error:nil];

    // Prepare Buffer Two
    AVAudioFormat *audioFormatTwo = self.audioFileTwo.processingFormat;
    AVAudioFrameCount lengthTwo = (AVAudioFrameCount)self.audioFileTwo.length;
    self.audioPCMBufferTwo = [[AVAudioPCMBuffer alloc]initWithPCMFormat:audioFormatTwo frameCapacity:lengthTwo];
    [self.audioFileTwo readIntoBuffer:self.audioPCMBufferTwo error:nil];

    // Prepare Buffer Three
    AVAudioFormat *audioFormatThree = self.audioFileThree.processingFormat;
    AVAudioFrameCount lengthThree = (AVAudioFrameCount)self.audioFileThree.length;
    self.audioPCMBufferThree = [[AVAudioPCMBuffer alloc]initWithPCMFormat:audioFormatThree frameCapacity:lengthThree];
    [self.audioFileThree readIntoBuffer:self.audioPCMBufferThree error:nil];

    // Prepare Buffer Four
    AVAudioFormat *audioFormatFour = self.audioFileFour.processingFormat;
    AVAudioFrameCount lengthFour = (AVAudioFrameCount)self.audioFileFour.length;
    self.audioPCMBufferFour = [[AVAudioPCMBuffer alloc]initWithPCMFormat:audioFormatFour frameCapacity:lengthFour];
    [self.audioFileFour readIntoBuffer:self.audioPCMBufferFour error:nil];

    // Prepare AVAudioPlayerNode Zero
    self.audioPlayerNodeZero = [AVAudioPlayerNode new];
    self.audioPlayerNodeZero.volume = 0.55;
    [self.engine attachNode:self.audioPlayerNodeZero];

    // Prepare AVAudioPlayerNode One
    self.audioPlayerNodeOne = [AVAudioPlayerNode new];
    self.audioPlayerNodeOne.volume = 0.55;
    [self.engine attachNode:self.audioPlayerNodeOne];

    // Prepare AVAudioPlayerNode Two
    self.audioPlayerNodeTwo = [AVAudioPlayerNode new];
    [self.engine attachNode:self.audioPlayerNodeTwo];

    // Prepare AVAudioPlayerNode Three
    self.audioPlayerNodeThree = [AVAudioPlayerNode new];
    [self.engine attachNode:self.audioPlayerNodeThree];

    // Prepare AVAudioPlayerNode Four
    self.audioPlayerNodeFour = [AVAudioPlayerNode new];
    [self.engine attachNode:self.audioPlayerNodeFour];

    self.utPitchTwo = [AVAudioUnitTimePitch new];
    self.utPitchTwo.pitch = 0.0;
    self.utPitchTwo.rate = 1.0;
    [self.engine attachNode:self.utPitchTwo];

    self.utPitchThree = [AVAudioUnitTimePitch new];
    self.utPitchThree.pitch = 0.0;
    self.utPitchThree.rate = 1.0;
    [self.engine attachNode:self.utPitchThree];

    self.utPitchFour = [AVAudioUnitTimePitch new];
    self.utPitchFour.pitch = 0.0;
    self.utPitchFour.rate = 1.0;
    [self.engine attachNode:self.utPitchFour];

    //Connect Nodes
    AVAudioMixerNode *mixerNode = [self.engine mainMixerNode];
    //0
    [self.engine connect:self.audioPlayerNodeZero
                      to:mixerNode
                  format:self.audioFileZero.processingFormat];
    // 1
    [self.engine connect:self.audioPlayerNodeOne
                      to:mixerNode
                  format:self.audioFileOne.processingFormat];
    // 2
    [self.engine connect:self.audioPlayerNodeTwo
                      to:self.utPitchTwo
                  format:self.audioFileTwo.processingFormat];
    [self.engine connect:self.utPitchTwo
                      to:mixerNode
                  format:self.audioFileTwo.processingFormat];
    // 3
    [self.engine connect:self.audioPlayerNodeThree
                      to:self.utPitchThree
                  format:self.audioFileThree.processingFormat];
    [self.engine connect:self.utPitchThree
                      to:mixerNode
                  format:self.audioFileThree.processingFormat];
    // 4
    [self.engine connect:self.audioPlayerNodeFour
                      to:self.utPitchFour
                  format:self.audioFileFour.processingFormat];
    [self.engine connect:self.utPitchFour
                      to:mixerNode
                  format:self.audioFileFour.processingFormat];

    // Start engine
    NSError *error;
    [self.engine startAndReturnError:&error];
    if (error) {
        NSLog(@"error:%@", error);
    }
}

- (void)playZero
{
    // Schedule playing audio buffer
    [self.audioPlayerNodeZero scheduleBuffer:self.audioPCMBufferZero
                                      atTime:nil
                                     options:AVAudioPlayerNodeBufferLoops
                           completionHandler:nil];
    // Start playback
    [self.audioPlayerNodeZero play];
}

- (void)playOne
{
    // Schedule playing audio buffer
    [self.audioPlayerNodeOne scheduleBuffer:self.audioPCMBufferOne
                                      atTime:nil
                                     options:AVAudioPlayerNodeBufferLoops
                           completionHandler:nil];
    // Start playback
    [self.audioPlayerNodeOne play];
}

- (void)playTwo
{
    // Schedule playing audio buffer
    [self.audioPlayerNodeTwo scheduleBuffer:self.audioPCMBufferTwo
                                     atTime:nil
                                    options:AVAudioPlayerNodeBufferInterrupts
                          completionHandler:nil];
    // Start playback
    [self.audioPlayerNodeTwo play];
}

- (void)playThree
{
    // Schedule playing audio buffer
    [self.audioPlayerNodeThree scheduleBuffer:self.audioPCMBufferThree
                                     atTime:nil
                                    options:AVAudioPlayerNodeBufferInterrupts
                          completionHandler:nil];
    // Start playback
    [self.audioPlayerNodeThree play];
}

- (void)playFour
{
    // Schedule playing audio buffer
    [self.audioPlayerNodeFour scheduleBuffer:self.audioPCMBufferFour
                                       atTime:nil
                                      options:AVAudioPlayerNodeBufferInterrupts
                            completionHandler:nil];
    // Start playback
    [self.audioPlayerNodeFour play];
}

- (IBAction)onSliderMoved:(UISlider *)sender
{
    self.utPitchTwo.pitch = sender.value;
    self.utPitchThree.pitch = sender.value;
    self.utPitchFour.pitch = sender.value;
}

#pragma mark - Formatting
-(void)addGIFtoMiddleButton
{
    NSURL *gifURL = [[NSBundle mainBundle] URLForResource:@"space" withExtension:@"gif"];
    [self.middleButton setBackgroundImage:[UIImage animatedImageWithAnimatedGIFURL:gifURL] forState:UIControlStateNormal];
    [self.middleButton setBackgroundImage:[UIImage animatedImageWithAnimatedGIFURL:gifURL] forState:UIControlStateSelected];
    [self.middleButton setBackgroundImage:[UIImage animatedImageWithAnimatedGIFURL:gifURL] forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.middleButton setTitleColor:[UIColor colorWithRed:53.0/255.0 green:50.0/255.0 blue:25.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
}

//Formats text of a button's textLabel to adjust to size
-(void)formatButtonLabel:(UIButton *)button
{
    button.titleLabel.numberOfLines = 1;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

//Enables upside-down orientation
-(NSUInteger)supportedInterfaceOrientations
{
    return (int) UIInterfaceOrientationMaskAll;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
