//
//  ViewController.m
//  MartianMonster
//
//  Created by Vik Denic on 8/16/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FBShimmeringView.h"
#import "UIImage+animatedGif.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *topLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *topRightButton;
@property (strong, nonatomic) IBOutlet UIButton *middleButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomRightButton;
@property (strong, nonatomic) IBOutlet UIButton *bannerButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bannerVerticalConstraint;

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

    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];

    [self addMiddleButtonGIF];
    [self delayBanner];
    [self shimmer];
}

#pragma mark - Banner Button
-(void)delayBanner
{
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(showBanner) userInfo:nil repeats:NO];
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
- (IBAction)onAudioButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:[@(sender.tag) stringValue]];
}

-(void)playSoundWithName:(NSString *)soundName
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"m4a"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL), &soundEffect);
    AudioServicesPlaySystemSound(soundEffect);
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//Enables upside-down orientation
-(NSUInteger)supportedInterfaceOrientations
{
    return (int) UIInterfaceOrientationMaskAll;
}

@end
