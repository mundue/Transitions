//
//  BarndoorAnimator.h
//  Transitions
//
//  Created by Matt Martel on 8/15/14.
//  Copyright (c) 2014 Mundue LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ENUM(NSUInteger, effectType) {
    cloudsType = 0,
    doorsType,
};

@interface BarndoorAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) enum effectType type;

@end
