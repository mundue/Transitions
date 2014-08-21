//
//  BubblesAnimator.m
//  Transitions
//
//  Created by Matt Martel on 8/15/14.
//  Copyright (c) 2014 Mundue LLC. All rights reserved.
//

#import "BubblesAnimator.h"

@implementation BubblesAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    // Create two auxilliary image views to display the
    // bubbles as they slide into view.
    
    // This example does not use Auto Layout.
    
    // Configure the water view to be initially offscreen.
    UIImageView* waterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"water"]];
    waterView.contentMode = UIViewContentModeCenter;
    CGPoint centerOnscreenWater = toViewController.view.center;
    CGPoint centerOffscreenWater = toViewController.view.center;
    centerOffscreenWater.y += waterView.frame.size.height;
    waterView.center = centerOffscreenWater;
    waterView.alpha = 0.75f;
    [[transitionContext containerView] addSubview:waterView];
    
    // Configure the bubbles view to be initially offscreen.
    UIImageView* bubblesView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubbles"]];
    bubblesView.contentMode = UIViewContentModeCenter;
    CGPoint centerOnscreenBubbles = toViewController.view.center;
    CGPoint centerOffscreenBubbles = toViewController.view.center;
    centerOffscreenBubbles.y += bubblesView.frame.size.height;
    bubblesView.center = centerOffscreenBubbles;
    bubblesView.alpha = 0.75f;
    [[transitionContext containerView] addSubview:bubblesView];
    
    // Keep the destination view hidden until the bubbles are fully onscreen.
    toViewController.view.alpha = 0.0f;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration*0.1f
                          delay:0.0f
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         // Water shimmy side to side.
                         waterView.transform = CGAffineTransformScale(waterView.transform, 0.75f, 1.0f);
                     } completion:nil];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Water moves up.
                         waterView.center = centerOnscreenWater;
                     } completion:nil];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Bubbles move up.
                         bubblesView.center = centerOnscreenBubbles;
                         waterView.alpha = 1.0f;
                         bubblesView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         // Now show the destination view and fade the bubbles to reveal it.
                         toViewController.view.alpha = 1.0f;
                         [UIView animateWithDuration:duration*0.5f
                                          animations:^{
                                              // Water and bubbles fade away.
                                              waterView.alpha = 0.0f;
                                              bubblesView.alpha = 0.0f;
                                          } completion:^(BOOL finished) {
                                              [waterView removeFromSuperview];
                                              [bubblesView removeFromSuperview];
                                              // You must call this method to notify the
                                              // system that the animation has completed.
                                              [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                              //TODO: Notify the destination view controller on completion.
                                          }];
                     }];
}

@end
