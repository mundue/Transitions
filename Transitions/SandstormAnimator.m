//
//  SandstormAnimator.m
//  Transitions
//
//  Created by Matt Martel on 8/15/14.
//  Copyright (c) 2014 Mundue LLC. All rights reserved.
//

#import "SandstormAnimator.h"

@implementation SandstormAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    // Create an auxilliary image view to display the
    // sandstorm as it slides into view.
    UIImageView* leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sandstorm"]];
    leftView.translatesAutoresizingMaskIntoConstraints = NO;
    leftView.alpha = 0.75f;
    [[transitionContext containerView] addSubview:leftView];
    
    // Configure the left view to be initially offscreen.
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:toViewController.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:-(leftView.frame.size.width)];
    [[transitionContext containerView] addConstraint:leftConstraint];
    
    // Keep the destination view hidden until the sandstorm is fully onscreen.
    toViewController.view.alpha = 0.0f;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [[transitionContext containerView] layoutIfNeeded];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         // Sandstorm moves in from the left.
                         leftConstraint.constant = 0.0f;
                         leftView.alpha = 1.0f;
                         [[transitionContext containerView] layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         // Now show the destination view and fade the sandstorm to reveal it.
                         toViewController.view.alpha = 1.0f;
                         [UIView animateWithDuration:duration*0.5f
                                          animations:^{
                                              // Sandstorm fades away.
                                              leftView.alpha = 0.0f;
                                          } completion:^(BOOL finished) {
                                              // Cleanup the temporary views.
                                              [leftView removeFromSuperview];
                                              // You must call this method to notify the
                                              // system that the animation has completed.
                                              [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                                              //TODO: Notify the destination view controller on completion.
                                          }];
                     }];
}

@end
