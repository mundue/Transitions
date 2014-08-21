//
//  ViewController.m
//  Transitions
//
//  Created by Matt Martel on 8/15/14.
//  Copyright (c) 2014 Mundue LLC. All rights reserved.
//

#import "ViewController.h"
#import "NavigationControllerDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.backgroundImageView];
    [self updateConstraints];
    if (self.sceneName) {
        self.backgroundImageView.image = [UIImage imageNamed:self.sceneName];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.sceneName = segue.identifier;
}

#pragma mark - Setup

- (void)updateConstraints {
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
