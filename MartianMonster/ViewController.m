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

    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
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
    [self playSoundWithName:@"SpeedOfYourRocketBite"];
}

- (IBAction)onBottomRightButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:@"TripIsShortBite"];
}

-(void)playSoundWithName:(NSString *)soundName
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"m4a"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID(CFBridgingRetain(soundURL), &soundEffect);
    AudioServicesPlaySystemSound(soundEffect);
}

-(void)formatButtonLabel:(UIButton *)button
{
    button.titleLabel.numberOfLines = 1;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

@end
