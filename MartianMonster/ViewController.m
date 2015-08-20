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

@implementation ViewController {
    SystemSoundID soundEffect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self formatButtonLabel:self.topLeftButton];
    [self formatButtonLabel:self.topRightButton];
    [self formatButtonLabel:self.middleButton];
    [self formatButtonLabel:self.bottomLeftButton];
    [self formatButtonLabel:self.bottomRightButton];
    [self formatButtonLabel:self.bannerButton];

    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];

    [self delayBanner];
}

-(void)delayBanner
{
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showBanner) userInfo:nil repeats:NO];
}

-(void)showBanner
{
    self.bannerVerticalConstraint.constant += 50;
    [self.bannerButton setNeedsUpdateConstraints];

    [UIView animateWithDuration:2.0f animations:^{
        [self.bannerButton layoutIfNeeded];
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)onTopLeftButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:@"RadarBite"];
}

- (IBAction)onTopRightButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:@"SirenBite"];
}

- (IBAction)onMiddleButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:@"BlastOffBite"];
}

- (IBAction)onBottomLeftButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:@"IncredibleSpeedBite"];
}

- (IBAction)onBottomRightButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:@"TripShortBite"];
}

-(void)playSoundWithName:(NSString *)soundName
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"m4a"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL), &soundEffect);
    AudioServicesPlaySystemSound(soundEffect);
}

-(void)animateLinkBanner
{
    
}

- (IBAction)onLinkButtonTapped:(UIButton *)sender
{

    NSString *iTunesLink = @"https://geo.itunes.apple.com/us/album/chilling-thrilling-sounds/id272258499?at=10lu5f&mt=1&app=music";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

-(void)formatButtonLabel:(UIButton *)button
{
    button.titleLabel.numberOfLines = 1;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return (int) UIInterfaceOrientationMaskAll;
}

@end
