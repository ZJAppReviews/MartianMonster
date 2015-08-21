//
//  ViewController.m
//  MartianMonster
//
//  Created by Vik Denic on 8/16/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *topLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *topRightButton;
@property (strong, nonatomic) IBOutlet UIButton *middleButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomLeftButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomRightButton;
@property (strong, nonatomic) IBOutlet UIButton *bannerButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bannerVerticalConstraint;

@end

static NSString * const kAudioBlip = @"Blip";
static NSString * const kAudioUFO = @"UFO";
static NSString * const kAudioSpeed = @"Speed";
static NSString * const kAudioTrip = @"Trip";
static NSString * const kAudioBlastOff = @"BlastOff";
static NSString * const kURLiTunesAlbum = @"https://geo.itunes.apple.com/us/album/chilling-thrilling-sounds/id272258499?at=10lu5f&mt=1&app=music";

@implementation ViewController {
    SystemSoundID soundEffect;
}

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

    [self delayBanner];
}

-(void)delayBanner
{
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showBanner) userInfo:nil repeats:NO];
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)onTopLeftButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:kAudioBlip];
}

- (IBAction)onTopRightButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:kAudioUFO];
}

- (IBAction)onMiddleButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:kAudioBlastOff];
}

- (IBAction)onBottomLeftButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:kAudioSpeed];
}

- (IBAction)onBottomRightButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:kAudioTrip];
}

-(void)playSoundWithName:(NSString *)soundName
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"m4a"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL), &soundEffect);
    AudioServicesPlaySystemSound(soundEffect);
}

- (IBAction)onLinkButtonTapped:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURLiTunesAlbum]];
}

//Formats text of button's textLabel to adjust to size
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

@end
