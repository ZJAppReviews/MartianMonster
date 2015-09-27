//
//  BubbularMenuView.h
//  Example
//
//  Created by Vik Denic on 9/18/15.
//  Copyright (c) 2015 vik denic. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BubbularMenuView;

typedef NS_ENUM(NSInteger, BubbularDirection) {
    BubbularDirectionHorizontal,
    BubbularDirectionVertical
};

@protocol BubbularMenuViewDelegate <NSObject>

@required

-(void)bubbularMenuView:(BubbularMenuView *)menuView didTapMenuButton:(UIButton *)menuButton;

@end

@interface BubbularMenuView : UIView

@property id<BubbularMenuViewDelegate> delegate;

@property UIDynamicAnimator *dynamicAnimator;
@property UIButton *mainButton;

@property (nonatomic) NSArray *images;
@property (nonatomic) UIImage *mainMenuButtonImage;

@property (nonatomic) UIColor *buttonBorderColor;
@property (nonatomic) UIColor *buttonBackgroundColor;
@property (nonatomic) float buttonBorderWidth;
@property (nonatomic) float buttonBackgroundAlpha;

@property int buttonCount;
@property CGFloat buttonCircumference;
@property (nonatomic) CGFloat spacing; //from one button's center to the next
@property BOOL isExpanded;

@property (nonatomic) BubbularDirection direction;

-(instancetype)initWithMenuItemCount:(int)count andButtonCircumference:(CGFloat)circ;
-(void)expandMenuButtons;

@end

