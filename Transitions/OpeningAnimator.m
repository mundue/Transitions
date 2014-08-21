//
//  OpeningAnimator.m
//  Transitions
//
//  Created by Matt Martel on 8/17/14.
//  Copyright (c) 2014 Mundue LLC. All rights reserved.
//

#import "OpeningAnimator.h"

@implementation OpeningAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    // Create two auxilliary image views to display
    // the images as they slide out of view.
    UIImageView* leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doors-left"]];
    leftView.translatesAutoresizingMaskIntoConstraints = NO;
    leftView.layer.shadowOpacity = 1.0f;
    [[transitionContext containerView] addSubview:leftView];
    UIImageView* rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doors-right"]];
    rightView.translatesAutoresizingMaskIntoConstraints = NO;
    rightView.layer.shadowOpacity = 1.0f;
    [[transitionContext containerView] addSubview:rightView];
    
    // Configure the left view to be initially onscreen.
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:toViewController.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    [[transitionContext containerView] addConstraint:leftConstraint];
    
    // Configure the right view to be initially onscreen.
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:rightView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:toViewController.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    [[transitionContext containerView] addConstraint:rightConstraint];

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [[transitionContext containerView] layoutIfNeeded];
   
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         // Move the views offscreen.
                         leftConstraint.constant = -(leftView.frame.size.width);
                         rightConstraint.constant = rightView.frame.size.width;
                         [[transitionContext containerView] layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         // Cleanup the temporary views.
                         [leftView removeFromSuperview];
                         [rightView removeFromSuperview];
                         // You must call this method to notify the
                         // system that the animation has completed.
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         //TODO: Notify the destination view controller on completion.
                     }];
}

@end
