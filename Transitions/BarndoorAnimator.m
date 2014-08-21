//
//  BarndoorAnimator.m
//  Transitions
//
//  Created by Matt Martel on 8/15/14.
//  Copyright (c) 2014 Mundue LLC. All rights reserved.
//

#import "BarndoorAnimator.h"

@implementation BarndoorAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    UIImage *leftImage = self.type == cloudsType ? [UIImage imageNamed:@"clouds-left"] : [UIImage imageNamed:@"doors-left"];
    UIImage *rightImage = self.type == cloudsType ? [UIImage imageNamed:@"clouds-right"] : [UIImage imageNamed:@"doors-right"];

    // Create two auxilliary image views to display the
    // images as they slide in and out of view.
    UIImageView* leftView = [[UIImageView alloc] initWithImage:leftImage];
    leftView.translatesAutoresizingMaskIntoConstraints = NO;
    [[transitionContext containerView] addSubview:leftView];
    UIImageView* rightView = [[UIImageView alloc] initWithImage:rightImage];
    rightView.translatesAutoresizingMaskIntoConstraints = NO;
    [[transitionContext containerView] addSubview:rightView];
    
    // Configure the left view to be initially offscreen.
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:leftView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:toViewController.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:-(leftView.frame.size.width)];
    [[transitionContext containerView] addConstraint:leftConstraint];
    
    // Configure the right view to be initially offscreen.
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:rightView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:toViewController.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:rightView.frame.size.width];
    [[transitionContext containerView] addConstraint:rightConstraint];
    
    // Keep the destination view hidden until the images are fully onscreen.
    toViewController.view.alpha = 0.0f;
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [[transitionContext containerView] layoutIfNeeded];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Move the views onscreen.
                         leftConstraint.constant = 0.0f;
                         rightConstraint.constant = 0.0f;
                         [[transitionContext containerView] layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         // Now show the destination view and open the views to reveal it.
                         toViewController.view.alpha = 1.0f;
                         [UIView animateWithDuration:duration
                                               delay:duration*0.66f
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              // Move the views back offscreen.
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
                     }];
}

@end
