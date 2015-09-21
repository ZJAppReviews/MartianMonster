//
//  BubbularMenuView.m
//  Example
//
//  Created by Vik Denic on 9/18/15.
//  Copyright (c) 2015 vik denic. All rights reserved.
//

#import "BubbularMenuView.h"

@implementation BubbularMenuView

- (instancetype)initWithMenuItemCount:(int)count andButtonCircumference:(CGFloat)circ
{
    CGFloat totalWidth = circ * (count + 1);
    CGRect frameforEncasingView = CGRectMake(0, 0, totalWidth, circ);

    self = [[BubbularMenuView alloc] initWithFrame:frameforEncasingView];
    self.direction = BubbularDirectionHorizontal; //default value
    self.spacing = circ; //default value
    self.buttonCount = count;
    self.buttonCircumference = circ;

    for (int i = 0; i < count + 1; i++)
    {
//        NSString *buttonTitle = [NSString stringWithFormat:@"%i", i];
        UIButton *menuItemButton = [self createButtonWithTitle:nil withCircumference:circ];

        [self formatImageViewForButton:menuItemButton];

        menuItemButton.tag = i;

        [menuItemButton addTarget:self action:@selector(onMenuButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:menuItemButton];
        [self sendSubviewToBack:menuItemButton];

        if (i == 0)
        {
            self.mainButton = menuItemButton;
            [self.mainButton addTarget:self action:@selector(contractMenuButtons:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    [self resizeToFitSubviews];

    self.dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    return self;
}

-(void)expandMenuButtons
{
    UIButton *mainButton = self.subviews.lastObject;

    int i = 0;
    for (UIButton *menuButton in [[self.subviews reverseObjectEnumerator] allObjects])
    {

        if (self.direction == BubbularDirectionVertical)
        {
            [self snapButton:menuButton toPoint:CGPointMake(mainButton.center.x, mainButton.center.y  + (self.spacing * i))];
        }
        else
        {
            [self snapButton:menuButton toPoint:CGPointMake(mainButton.center.x + (self.spacing * i), mainButton.center.y)];
        }
        i++;
    }
}

-(void)contractMenuButtons:(id)sender
{
    [self.dynamicAnimator removeAllBehaviors];

    if (!self.isExpanded)
    {
        [self expandMenuButtons];
    }
    else
    {
        for (UIButton *menuButton in [[self.subviews reverseObjectEnumerator] allObjects])
        {
            [self snapButton:menuButton toPoint:self.mainButton.center];
        }
    }
    self.isExpanded = !self.isExpanded;
}

-(void)snapButton:(UIButton *)button toPoint:(CGPoint)point
{
    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc]initWithItem:button snapToPoint:point];
    [self.dynamicAnimator addBehavior:snapBehaviour];
}

-(void)onMenuButtonTapped:(UIButton *)sender
{
    [self.delegate bubbularMenuView:self didTapMenuButton:sender];
}

-(UIButton *)createButtonWithTitle:(NSString *)title withCircumference:(CGFloat)circ
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, circ, circ)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.borderColor = button.titleLabel.textColor.CGColor;
    //border color is CGColor because layer is a core graphic (CG) to the button

    button.layer.borderWidth = 1.0;
    button.layer.cornerRadius = button.frame.size.width/2;

    return button;
}

-(void)resizeToFitSubviews
{
    CGFloat totalLength = ( (self.buttonCircumference * (self.buttonCount + 1)) + ((self.spacing - self.buttonCircumference) * self.buttonCount) );

    if (self.direction == BubbularDirectionVertical)
    {
        self.frame = CGRectMake(0, 0, self.buttonCircumference, totalLength);

    }
    else
    {
        self.frame = CGRectMake(0, 0, totalLength, self.buttonCircumference);
    }
}

-(void)formatImageViewForButton:(UIButton *)button
{
    button.contentMode = UIViewContentModeScaleAspectFill;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;

    float edgeInset = self.buttonCircumference / 6;
    button.imageEdgeInsets = UIEdgeInsetsMake(edgeInset, edgeInset, edgeInset, edgeInset);
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor
{
    _buttonBackgroundColor = buttonBackgroundColor;

    for (UIButton *menuButton in [[self.subviews reverseObjectEnumerator] allObjects])
    {
        menuButton.backgroundColor = self.buttonBackgroundColor;
    }
}

-(void)setSpacing:(CGFloat)spacing
{
    _spacing = spacing;
    [self resizeToFitSubviews];
}

-(void)setDirection:(BubbularDirection)direction
{
    _direction = direction;
    [self resizeToFitSubviews];
}

-(void)setImages:(NSArray *)images
{
    _images = images;

    int i = 0;
    for (UIButton *menuButton in [[self.subviews reverseObjectEnumerator] allObjects])
    {
        [menuButton setImage:self.images[i] forState:UIControlStateNormal];
        i++;
    }
}

-(void)setMainMenuButtonImage:(UIImage *)mainMenuButtonImage
{
    _mainMenuButtonImage = mainMenuButtonImage;

    UIButton *mainButton = self.subviews.lastObject;
    mainButton.imageView.image =self.mainMenuButtonImage;
}

-(void)setButtonBorderColor:(UIColor *)buttonBorderColor
{
    _buttonBorderColor = buttonBorderColor;

    for (UIButton *menuButton in [[self.subviews reverseObjectEnumerator] allObjects])
    {
        menuButton.layer.borderColor = self.buttonBorderColor.CGColor;
    }
}

-(void)setButtonBorderWidth:(float)width
{
    _buttonBorderWidth = width;

    for (UIButton *menuButton in [[self.subviews reverseObjectEnumerator] allObjects])
    {
        menuButton.layer.borderWidth = self.buttonBorderWidth;
    }
}

@end
