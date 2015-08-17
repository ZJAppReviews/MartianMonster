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

@property (strong, nonatomic) IBOutlet UIButton *topButton;
@property (strong, nonatomic) IBOutlet UIButton *middleButton;
@property (strong, nonatomic) IBOutlet UIButton *bottomButton;

@end

@implementation ViewController {
    SystemSoundID soundEffect;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.middleButton.titleLabel.numberOfLines = 1;
    self.middleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.middleButton.titleLabel.lineBreakMode = NSLineBreakByClipping;

    self.bottomButton.titleLabel.numberOfLines = 1;
    self.bottomButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.bottomButton.titleLabel.lineBreakMode = NSLineBreakByClipping;

    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)onTopButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:@"BlastOffBite"];
}

- (IBAction)onMiddleButtonTapped:(UIButton *)sender
{
    [self playSoundWithName:@"SpeedOfYourRocketBite"];
}

- (IBAction)onBottomButtonTapped:(UIButton *)sender
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

@end
