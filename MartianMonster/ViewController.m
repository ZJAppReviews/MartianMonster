//
//  ViewController.m
//  MartianMonster
//
//  Created by Vik Denic on 8/16/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "ViewController.h"
//#import <AudioToolbox/AudioToolbox.h>
#import "FBShimmeringView.h"
#import "UIImage+animatedGif.h"

@import AVFoundation;

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *topLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *topRightButton;
@property (strong, nonatomic) IBOutlet UIButton *middleButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomRightButton;
@property (strong, nonatomic) IBOutlet UIButton *bannerButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bannerVerticalConstraint;

@property (nonatomic, strong) AVAudioEngine *engine;
@property (nonatomic, strong) AVAudioPlayerNode *audioPlayerNodeZero;
@property (nonatomic, strong) AVAudioPlayerNode *audioPlayerNodeOne;

@property (nonatomic, strong) AVAudioFile *audioFileZero;
@property (nonatomic, strong) AVAudioFile *audioFileOne;

@property (nonatomic, strong) AVAudioPCMBuffer *audioPCMBufferZero;
@property (nonatomic, strong) AVAudioPCMBuffer *audioPCMBufferOne;

//@property (nonatomic, strong) AVAudioEngine *engine;
//@property (nonatomic, strong) AVAudioPlayerNode *audioPlayerNode;
//
//@property (nonatomic, strong) AVAudioPlayerNode *middleAudioPlayerNode;
//@property (nonatomic, strong) AVAudioPlayerNode *bottomLeftAudioPlayerNode;
//@property (nonatomic, strong) AVAudioPlayerNode *bottomRightAudioPlayerNode;
//
//@property (nonatomic, strong) AVAudioFile *audioFile;

@property (strong, nonatomic) IBOutlet UISlider *slider;

@end

static NSString * const kURLiTunesAlbum = @"https://geo.itunes.apple.com/us/album/chilling-thrilling-sounds/id272258499?at=10lu5f&mt=1&app=music";

@implementation ViewController {
    SystemSoundID soundEffect;

    float selectedPitch;
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

    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];

    [self addMiddleButtonGIF];
    [self delayBanner];
    [self scheduleBanner];
    [self shimmer];
    [self audioSetUp];
}

#pragma mark - Banner Button
-(void)delayBanner
{
    [NSTimer scheduledTimerWithTimeInterval:2.75 target:self selector:@selector(showBanner) userInfo:nil repeats:NO];
}

-(void)scheduleBanner
{
    [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(hideBanner) userInfo:nil repeats:YES];

    [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(scheduleBannerTwo) userInfo:nil repeats:NO];
}

-(void)scheduleBannerTwo
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

- (IBAction)onLinkButtonTapped:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURLiTunesAlbum]];
}

#pragma mark - Audio
//Audio files' names correlate to a button's tag
- (IBAction)onTopRowButtonTapped:(UIButton *)sender
{
//    [self playSoundWithoutEffectsWithName:[@(sender.tag) stringValue]];
    if (sender.tag == 0)
    {
        if (self.audioPlayerNodeZero.isPlaying)
        {
            [self.audioPlayerNodeZero stop];
            [self playZero];
        } else {
            [self playZero];
        }
    }
    else
    {
        if (self.audioPlayerNodeOne.isPlaying)
        {
            [self.audioPlayerNodeOne stop];
            [self playOne];
        } else {
            [self playOne];
        }
    }
}

- (IBAction)onMiddleButtonTapped:(UIButton *)sender
{
//    [self playMiddleSoundEffect];
}

- (IBAction)onBottomLeftButtonTapped:(UIButton *)sender
{
//    [self playBottomLeftSoundEffect];
}

- (IBAction)onBottomRightButtonTapped:(UIButton *)sender
{
//    [self playBottomRightSoundEffect];
}

-(void)audioSetUp
{
    self.engine = [AVAudioEngine new];

    // Prepare AVAudioFile
    NSString *pathZero = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"m4a"];
    self.audioFileZero = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:pathZero]
                                                   error:nil];

    // Prepare AVAudioFile
    NSString *pathOne = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"m4a"];
    self.audioFileOne = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:pathOne]
                                                       error:nil];

    // Prepare Buffer
    AVAudioFormat *audioFormatZero = self.audioFileZero.processingFormat;
    AVAudioFrameCount lengthZero = (AVAudioFrameCount)self.audioFileZero.length;
    self.audioPCMBufferZero = [[AVAudioPCMBuffer alloc]initWithPCMFormat:audioFormatZero frameCapacity:lengthZero];
    [self.audioFileZero readIntoBuffer:self.audioPCMBufferZero error:nil];

    // Prepare Buffer
    AVAudioFormat *audioFormatOne = self.audioFileOne.processingFormat;
    AVAudioFrameCount lengthOne = (AVAudioFrameCount)self.audioFileOne.length;
    self.audioPCMBufferOne = [[AVAudioPCMBuffer alloc]initWithPCMFormat:audioFormatOne frameCapacity:lengthOne];
    [self.audioFileOne readIntoBuffer:self.audioPCMBufferOne error:nil];

    // Prepare AVAudioPlayerNode
    self.audioPlayerNodeZero = [AVAudioPlayerNode new];
    [self.engine attachNode:self.audioPlayerNodeZero];

    // Prepare AVAudioPlayerNode
    self.audioPlayerNodeOne = [AVAudioPlayerNode new];
    [self.engine attachNode:self.audioPlayerNodeOne];

    // Connect Nodes
    AVAudioMixerNode *mixerNode = [self.engine mainMixerNode];
    [self.engine connect:self.audioPlayerNodeZero
                      to:mixerNode
                  format:self.audioFileZero.processingFormat];

    [self.engine connect:self.audioPlayerNodeOne
                      to:mixerNode
                  format:self.audioFileOne.processingFormat];

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
                                     options:AVAudioPlayerNodeBufferInterrupts
                           completionHandler:nil];

    // Start playback
    [self.audioPlayerNodeZero play];
}

- (void)playOne
{
    // Schedule playing audio buffer

    [self.audioPlayerNodeOne scheduleBuffer:self.audioPCMBufferOne
                                      atTime:nil
                                     options:AVAudioPlayerNodeBufferInterrupts
                           completionHandler:nil];

    // Start playback
    [self.audioPlayerNodeOne play];
}

//-(void)playSoundWithoutEffectsWithName:(NSString *)soundName
//{
//    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"m4a"];
//    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
//    self.audioFile = [[AVAudioFile alloc] initForReading:soundURL error:nil];
//
//    // Prepare AVAudioPlayerNode
//    AVAudioPlayerNode *audioPlayerNode = [AVAudioPlayerNode new];
//    [self.engine attachNode:audioPlayerNode];
//
//    // Pitch
//    AVAudioUnitTimePitch *utPitch = [AVAudioUnitTimePitch new];
//    utPitch.pitch = 0;
//    utPitch.rate = 1;
//
//    // Connect Nodes
//    AVAudioMixerNode *mixerNode = [self.engine mainMixerNode];
//    [self.engine attachNode:utPitch];
//
//    [self.engine connect:audioPlayerNode
//                      to:utPitch
//                  format:self.audioFile.processingFormat];
//
//    //Pitch connection
//    [self.engine connect:utPitch to:mixerNode format:self.audioFile.processingFormat];
//
//    // Start engine
//    NSError *error;
//    [self.engine startAndReturnError:&error];
//    if (error) {
//        NSLog(@"error:%@", error);
//    }
//
//    // Schedule playing audio file
//    [audioPlayerNode scheduleFile:self.audioFile
//                                atTime:nil
//                     completionHandler:nil];
//
//    // Start playback
//    [audioPlayerNode play];
//}

//-(void)playBottomRightSoundEffect
//{
//    [self.bottomRightAudioPlayerNode stop];
//
//    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"4" ofType:@"m4a"];
//    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
//    self.audioFile = [[AVAudioFile alloc] initForReading:soundURL error:nil];
//
//    // Prepare AVAudioPlayerNode
//    self.bottomRightAudioPlayerNode = [AVAudioPlayerNode new];
//    [self.engine attachNode:self.bottomRightAudioPlayerNode];
//
//    // Pitch
//    AVAudioUnitTimePitch *utPitch = [AVAudioUnitTimePitch new];
//    utPitch.pitch = selectedPitch;
//    utPitch.rate = 1.0;
//
//    // Connect Nodes
//    AVAudioMixerNode *mixerNode = [self.engine mainMixerNode];
//    [self.engine attachNode:utPitch];
//
//    [self.engine connect:self.bottomRightAudioPlayerNode
//                      to:utPitch
//                  format:self.audioFile.processingFormat];
//
//    //Pitch connection
//    [self.engine connect:utPitch to:mixerNode format:self.audioFile.processingFormat];
//
//    // Start engine
//    NSError *error;
//    [self.engine startAndReturnError:&error];
//    if (error) {
//        NSLog(@"error:%@", error);
//    }
//
//    // Schedule playing audio file
//    [self.bottomRightAudioPlayerNode scheduleFile:self.audioFile
//                                atTime:nil
//                     completionHandler:nil];
//
//    // Start playback
//    [self.bottomRightAudioPlayerNode play];
//}
//
//-(void)playBottomLeftSoundEffect
//{
//    [self.bottomLeftAudioPlayerNode stop];
//
//    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"m4a"];
//    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
//    self.audioFile = [[AVAudioFile alloc] initForReading:soundURL error:nil];
//
//    // Prepare AVAudioPlayerNode
//    self.bottomLeftAudioPlayerNode = [AVAudioPlayerNode new];
//    [self.engine attachNode:self.bottomLeftAudioPlayerNode];
//
//    // Pitch
//    AVAudioUnitTimePitch *utPitch = [AVAudioUnitTimePitch new];
//    utPitch.pitch = selectedPitch;
//    utPitch.rate = 1.0;
//
//    // Connect Nodes
//    AVAudioMixerNode *mixerNode = [self.engine mainMixerNode];
//    [self.engine attachNode:utPitch];
//
//    [self.engine connect:self.bottomLeftAudioPlayerNode
//                      to:utPitch
//                  format:self.audioFile.processingFormat];
//
//    //Pitch connection
//    [self.engine connect:utPitch to:mixerNode format:self.audioFile.processingFormat];
//
//    // Start engine
//    NSError *error;
//    [self.engine startAndReturnError:&error];
//    if (error) {
//        NSLog(@"error:%@", error);
//    }
//
//    // Schedule playing audio file
//    [self.bottomLeftAudioPlayerNode scheduleFile:self.audioFile
//                                           atTime:nil
//                                completionHandler:nil];
//
//    // Start playback
//    [self.bottomLeftAudioPlayerNode play];
//}

//-(void)playMiddleSoundEffect
//{
//    [self.middleAudioPlayerNode stop];
//
//    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"m4a"];
//    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
//    self.audioFile = [[AVAudioFile alloc] initForReading:soundURL error:nil];
//
//    // Prepare AVAudioPlayerNode
//    self.middleAudioPlayerNode = [AVAudioPlayerNode new];
//    [self.engine attachNode:self.middleAudioPlayerNode];
//
//    // Pitch
//    AVAudioUnitTimePitch *utPitch = [AVAudioUnitTimePitch new];
//    utPitch.pitch = selectedPitch;
//    utPitch.rate = 1.0;
//
//    // Connect Nodes
//    AVAudioMixerNode *mixerNode = [self.engine mainMixerNode];
//    [self.engine attachNode:utPitch];
//
//    [self.engine connect:self.middleAudioPlayerNode
//                      to:utPitch
//                  format:self.audioFile.processingFormat];
//
//    //Pitch connection
//    [self.engine connect:utPitch to:mixerNode format:self.audioFile.processingFormat];
//
//    // Start engine
//    NSError *error;
//    [self.engine startAndReturnError:&error];
//    if (error) {
//        NSLog(@"error:%@", error);
//    }
//
//    // Schedule playing audio file
//    [self.middleAudioPlayerNode scheduleFile:self.audioFile
//                                          atTime:nil
//                               completionHandler:nil];
//
//    // Start playback
//    [self.middleAudioPlayerNode play];
//}

- (IBAction)onSliderMoved:(UISlider *)sender
{
    selectedPitch = sender.value;
}

#pragma mark - Formatting
-(void)addMiddleButtonGIF
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
