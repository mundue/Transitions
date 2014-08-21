//
//  SnowstormAnimator.m
//  Transitions
//
//  Created by Matt Martel on 8/15/14.
//  Copyright (c) 2014 Mundue LLC. All rights reserved.
//

#import "SnowstormAnimator.h"

@implementation SnowstormAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    // Create an auxilliary image view to display the
    // snowstorm as it slides into view.
    UIImageView* topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"snowstorm"]];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    topView.alpha = 0.75f;
    [[transitionContext containerView] addSubview:topView];
    
    // Configure the top view to be initially offscreen.
    topView.contentMode = UIViewContentModeCenter;
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toViewController.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:-(topView.frame.size.height)];
    [[transitionContext containerView] addConstraint:topConstraint];
    
    // Keep the destination view hidden until the snowstorm is fully onscreen.
    toViewController.view.alpha = 0.0f;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [[transitionContext containerView] layoutIfNeeded];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         // Snowstorm moves in from the top.
                         topConstraint.constant = 0.0f;
                         topView.alpha = 1.0f;
                         [[transitionContext containerView] layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         // Now show the destination view and fade the snowstorm to reveal it.
                         toViewController.view.alpha = 1.0f;
                         [UIView animateWithDuration:duration
                                          animations:^{
                                              // Snowstorm fades away.
                                              topView.alpha = 0.0f;
                                          } completion:^(BOOL finished) {
                                              // Cleanup the temporary views.
                                              [topView removeFromSuperview];
                                              // You must call this method to notify the
                                              // system that the animation has completed.
                                              [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                              //TODO: notifiy destination view controller on completion
                                          }];
                     }];
}

@end
