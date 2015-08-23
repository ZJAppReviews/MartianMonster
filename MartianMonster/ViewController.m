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
@property (nonatomic, strong) AVAudioPlayerNode *audioPlayerNode;
@property (nonatomic, strong) AVAudioFile *audioFile;

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
    [self shimmer];

    self.engine = [AVAudioEngine new];
}

#pragma mark - Banner Button
-(void)delayBanner
{
    [NSTimer scheduledTimerWithTimeInterval:2.75 target:self selector:@selector(showBanner) userInfo:nil repeats:NO];
}

//The bannerButton's vertical constant is set to -50 in Storyboard
-(void)showBanner
{
    self.bannerVerticalConstraint.constant += 50;
    [self.bannerButton setNeedsUpdateConstraints];

    [UIView animateWithDuration:1.0f animations:^{
        [self.bannerButton layoutIfNeeded];
    }];
}

-(void)hideBanner
{
    self.bannerVerticalConstraint.constant -= 50;
    [self.bannerButton setNeedsUpdateConstraints];

    [UIView animateWithDuration:1.0f animations:^{
        [self.bannerButton layoutIfNeeded];
    }];
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
    [self playSoundWithoutEffectsWithName:[@(sender.tag) stringValue]];
}

- (IBAction)onMiddleButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:[@(sender.tag) stringValue]];
}

- (IBAction)onBottomLeftButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:[@(sender.tag) stringValue]];
}

- (IBAction)onBottomRightButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:[@(sender.tag) stringValue]];
}

-(void)playSoundWithoutEffectsWithName:(NSString *)soundName
{
//    [self.audioPlayerNode stop];

    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"m4a"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    self.audioFile = [[AVAudioFile alloc] initForReading:soundURL error:nil];

    // Prepare AVAudioPlayerNode
    self.audioPlayerNode = [AVAudioPlayerNode new];
    [self.engine attachNode:self.audioPlayerNode];

    // Pitch
    AVAudioUnitTimePitch *utPitch = [AVAudioUnitTimePitch new];
    utPitch.pitch = 0;
    utPitch.rate = 1;

    // Connect Nodes
    AVAudioMixerNode *mixerNode = [self.engine mainMixerNode];
    [self.engine attachNode:utPitch];

    [self.engine connect:self.audioPlayerNode
                      to:utPitch
                  format:self.audioFile.processingFormat];

    //Pitch connection
    [self.engine connect:utPitch to:mixerNode format:self.audioFile.processingFormat];

    // Start engine
    NSError *error;
    [self.engine startAndReturnError:&error];
    if (error) {
        NSLog(@"error:%@", error);
    }

    // Schedule playing audio file
    [self.audioPlayerNode scheduleFile:self.audioFile
                                atTime:nil
                     completionHandler:nil];

    // Start playback
    [self.audioPlayerNode play];
}

-(void)playSoundWithName:(NSString *)soundName
{
    //    [self.audioPlayerNode stop];

    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"m4a"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    self.audioFile = [[AVAudioFile alloc] initForReading:soundURL error:nil];

    // Prepare AVAudioPlayerNode
    self.audioPlayerNode = [AVAudioPlayerNode new];
    [self.engine attachNode:self.audioPlayerNode];

    // Pitch
    AVAudioUnitTimePitch *utPitch = [AVAudioUnitTimePitch new];
    utPitch.pitch = selectedPitch;
    utPitch.rate = 1.0;

    // Connect Nodes
    AVAudioMixerNode *mixerNode = [self.engine mainMixerNode];
    [self.engine attachNode:utPitch];

    [self.engine connect:self.audioPlayerNode
                      to:utPitch
                  format:self.audioFile.processingFormat];

    //Pitch connection
    [self.engine connect:utPitch to:mixerNode format:self.audioFile.processingFormat];

    // Start engine
    NSError *error;
    [self.engine startAndReturnError:&error];
    if (error) {
        NSLog(@"error:%@", error);
    }

    // Schedule playing audio file
    [self.audioPlayerNode scheduleFile:self.audioFile
                                atTime:nil
                     completionHandler:nil];

    // Start playback
    [self.audioPlayerNode play];
}

- (IBAction)onSliderMoved:(UISlider *)sender
{
    selectedPitch = sender.value;
}

#pragma mark - Formatting
-(void)addMiddleButtonGIF
{
    NSURL *gifURL = [[NSBundle mainBundle] URLForResource:@"space" withExtension:@"gif"];
    [self.middleButton setBackgroundImage:[UIImage animatedImageWithAnimatedGIFURL:gifURL] forState:UIControlStateNormal];
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

#pragma mark - Easter Eggs
- (IBAction)onTripButtonHeldDown:(UILongPressGestureRecognizer *)sender
{
    [self hideBanner];
}

@end
