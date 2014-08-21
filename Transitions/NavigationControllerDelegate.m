//
//  NavigationControllerDelegate.m
//  Transitions
//
//  Created by Matt Martel on 8/15/14.
//  Copyright (c) 2014 Mundue LLC. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "BarndoorAnimator.h"
#import "BubblesAnimator.h"
#import "ClosingAnimator.h"
#import "OpeningAnimator.h"
#import "SandstormAnimator.h"
#import "SnowstormAnimator.h"
#import "ViewController.h"

@interface NavigationControllerDelegate ()

@property (nonatomic, weak) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;
@property (nonatomic, strong) BarndoorAnimator *barndoorAnimator;
@property (nonatomic, strong) BubblesAnimator *bubblesAnimator;
@property (nonatomic, strong) ClosingAnimator *closingAnimator;
@property (nonatomic, strong) OpeningAnimator *openingAnimator;
@property (nonatomic, strong) SandstormAnimator *sandstormAnimator;
@property (nonatomic, strong) SnowstormAnimator *snowstormAnimator;

@end

@implementation NavigationControllerDelegate

- (void)awakeFromNib {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.navigationController.view addGestureRecognizer:panRecognizer];
    self.barndoorAnimator = [[BarndoorAnimator alloc] init];
    self.bubblesAnimator = [[BubblesAnimator alloc] init];
    self.closingAnimator = [[ClosingAnimator alloc] init];
    self.openingAnimator = [[OpeningAnimator alloc] init];
    self.sandstormAnimator = [[SandstormAnimator alloc] init];
    self.snowstormAnimator = [[SnowstormAnimator alloc] init];
}

- (void)pan:(UIPanGestureRecognizer*)recognizer
{
    UIView* view = self.navigationController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:view];
        if (location.x <  CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) { // left half
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactionController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:view].x > 0) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    ViewController *destinationVC = (ViewController *)toVC;
    if (operation == UINavigationControllerOperationPush) {
        NSString *sceneName = [destinationVC sceneName];
        if ([sceneName isEqualToString:@"worldmap"]) {
            return self.openingAnimator;
        }
        if ([sceneName isEqualToString:@"mountains"]) {
            return self.snowstormAnimator;
        }
        if ([sceneName isEqualToString:@"desert"]) {
            return self.sandstormAnimator;
        }
        if ([sceneName isEqualToString:@"jungle"]) {
            self.barndoorAnimator.type = doorsType;
            return self.barndoorAnimator;
        }
        if ([sceneName isEqualToString:@"undersea"]) {
            return self.bubblesAnimator;
        }
    }
    if (operation == UINavigationControllerOperationPop) {
        NSString *sceneName = [destinationVC sceneName];
        if ([sceneName isEqualToString:@"worldmap"]) {
            self.barndoorAnimator.type = cloudsType;
            return self.barndoorAnimator;
        }
        if ([sceneName isEqualToString:@"main"]) {
            return self.closingAnimator;
        }
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return self.interactionController;
}

@end
