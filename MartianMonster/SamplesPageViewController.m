//
//  SamplesPageViewController.m
//  MartianMonster
//
//  Created by Vik Denic on 9/12/15.
//  Copyright (c) 2015 vikzilla. All rights reserved.
//

#import "SamplesPageViewController.h"
#import "OuterSpaceViewController.h"

@interface SamplesPageViewController ()

@end

@implementation SamplesPageViewController {
    NSArray *myViewControllers;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.delegate = self;
    self.dataSource = self;

    OuterSpaceViewController *p1 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"OuterSpaceViewController"];
    p1.sampleType = OuterSpace;

    OuterSpaceViewController *p2 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"OuterSpaceViewController"];
    p2.sampleType = Creatures;

    OuterSpaceViewController *p3 = [self.storyboard
                                    instantiateViewControllerWithIdentifier:@"OuterSpaceViewController"];
    p3.sampleType = Phun;

    myViewControllers = @[p1, p2, p3];

    [self setViewControllers:@[p1]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO completion:nil];
}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return myViewControllers[index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{

    NSUInteger currentIndex = [myViewControllers indexOfObject:viewController];

    if (currentIndex == 0) {
        return nil;
    }

    --currentIndex;
    currentIndex = currentIndex % (myViewControllers.count);
    return [myViewControllers objectAtIndex:currentIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [myViewControllers indexOfObject:viewController];

    if (currentIndex == myViewControllers.count - 1) {
        return nil;
    }

    ++currentIndex;
    currentIndex = currentIndex % (myViewControllers.count);
    return [myViewControllers objectAtIndex:currentIndex];
}

-(NSInteger)presentationCountForPageViewController:
(UIPageViewController *)pageViewController
{
    return 2;
}

-(NSInteger)presentationIndexForPageViewController:
(UIPageViewController *)pageViewController
{
    return 0;
}

@end
