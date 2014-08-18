//
//  UIViewController+CWPopup.m
//  CWPopupDemo
//
//  Created by Cezary Wojcik on 8/21/13.
//  Copyright (c) 2013 Cezary Wojcik. All rights reserved.
//

#import "UIViewController+CWPopup.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "MJPopupBackgroundView.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
@import Accelerate;
#endif
#import <float.h>


#define ANIMATION_TIME 0.3f
#define STATUS_BAR_SIZE 22

NSString const *CWPopupKey = @"CWPopupkey";
NSString const *CWBlurViewKey = @"CWFadeViewKey";
NSString const *CWUseBlurForPopup = @"CWUseBlurForPopup";

@implementation UIViewController (CWPopup)

@dynamic popupViewController, useBlurForPopup;
- (void)addBlurView {
    MJPopupBackgroundView *backgroundView = [[MJPopupBackgroundView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.alpha = 0.0f;
    [self.view addSubview:backgroundView];
    [self.view bringSubviewToFront:self.popupViewController.view];
    objc_setAssociatedObject(self, &CWBlurViewKey, backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - present/dismiss

- (void)presentPopupViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (self.popupViewController == nil) {
        self.popupViewController = viewControllerToPresent;
        self.popupViewController.view.autoresizesSubviews = NO;
        self.popupViewController.view.autoresizingMask = UIViewAutoresizingNone;
        CGRect finalFrame = [self getPopupFrameForViewController:viewControllerToPresent];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
//        if (platform >= 7.0) {
//            UIInterpolatingMotionEffect *interpolationHorizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
//            interpolationHorizontal.minimumRelativeValue = @-10.0;
//            interpolationHorizontal.maximumRelativeValue = @10.0;
//            UIInterpolatingMotionEffect *interpolationVertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
//            interpolationHorizontal.minimumRelativeValue = @-10.0;
//            interpolationHorizontal.maximumRelativeValue = @10.0;
//            [self.popupViewController.view addMotionEffect:interpolationHorizontal];
//            [self.popupViewController.view addMotionEffect:interpolationVertical];
//        }
#endif
        if (self.useBlurForPopup) {
            [self addBlurView];
        } else {
            UIView *fadeView = [UIView new];
            fadeView.frame = [UIScreen mainScreen].bounds;
           
            fadeView.backgroundColor = [UIColor blackColor];
            fadeView.alpha = 0.0f;
            [self.view addSubview:fadeView];
            objc_setAssociatedObject(self, &CWBlurViewKey, fadeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        UIView *blurView = objc_getAssociatedObject(self, &CWBlurViewKey);
        // setup
        if (flag) { // animate
            CGRect initialFrame = CGRectMake(finalFrame.origin.x, [UIScreen mainScreen].bounds.size.height + viewControllerToPresent.view.frame.size.height/2, finalFrame.size.width, finalFrame.size.height);
            viewControllerToPresent.view.frame = initialFrame;
            [self.view addSubview:viewControllerToPresent.view];
            [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                viewControllerToPresent.view.frame = finalFrame;
                blurView.alpha = self.useBlurForPopup ? 1.0f : 0.4f;
            } completion:^(BOOL finished) {
                [completion invoke];
            }];
        } else {
            viewControllerToPresent.view.frame = finalFrame;
            [self.view addSubview:viewControllerToPresent.view];
            [completion invoke];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenOrientationChanged) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
}

- (void)dismissPopupViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    UIView *blurView = objc_getAssociatedObject(self, &CWBlurViewKey);
    [self.popupViewController viewWillDisappear:YES];
    if (flag) { // animate
        CGRect initialFrame = self.popupViewController.view.frame;
        [UIView animateWithDuration:ANIMATION_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.popupViewController.view.frame = CGRectMake(initialFrame.origin.x, [UIScreen mainScreen].bounds.size.height + initialFrame.size.height/2, initialFrame.size.width, initialFrame.size.height);
            blurView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.popupViewController viewDidDisappear:YES];
            [self.popupViewController.view removeFromSuperview];
            [blurView removeFromSuperview];
            self.popupViewController = nil;
            [completion invoke];
        }];
    } else { // don't animate
        [self.popupViewController viewDidDisappear:YES];
        [self.popupViewController.view removeFromSuperview];
        [blurView removeFromSuperview];
        self.popupViewController = nil; 
        blurView = nil;
        [completion invoke];
    }
    // remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - handling screen orientation change

- (CGRect)getPopupFrameForViewController:(UIViewController *)viewController {
    CGRect frame = viewController.view.frame;
    CGFloat x;
    CGFloat y;
    x = ([UIScreen mainScreen].bounds.size.width - frame.size.width)/2;
    AppDelegate *appDel = [AppDelegate shareIntance];
    if (appDel.popFrom == 0) {
        y = ([UIScreen mainScreen].bounds.size.height-64-44 - frame.size.height)/2;
    }else {
        y = [UIScreen mainScreen].bounds.size.height-64 - frame.size.height;
    }
    
    
    return CGRectMake(x, y, frame.size.width, frame.size.height);
}

- (void)screenOrientationChanged {
    // make blur view go away so that we can re-blur the original back
    UIView *blurView = objc_getAssociatedObject(self, &CWBlurViewKey);
    [UIView animateWithDuration:ANIMATION_TIME animations:^{
        self.popupViewController.view.frame = [self getPopupFrameForViewController:self.popupViewController];
        if (UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            blurView.frame = [UIScreen mainScreen].bounds;
        } else {
            blurView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        }
        if (self.useBlurForPopup) {
            [UIView animateWithDuration:1.0f animations:^{
                // for delay
            } completion:^(BOOL finished) {
                [blurView removeFromSuperview];
                // popup view alpha to 0 so its not in the blur image
                self.popupViewController.view.alpha = 0.0f;
                [self addBlurView];
                self.popupViewController.view.alpha = 1.0f;
                // display blurView again
                UIView *blurView = objc_getAssociatedObject(self, &CWBlurViewKey);
                blurView.alpha = 1.0f;
            }];
        }
    }];
}

#pragma mark - popupViewController getter/setter

- (void)setPopupViewController:(UIViewController *)popupViewController {
    objc_setAssociatedObject(self, &CWPopupKey, popupViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)popupViewController {
    return objc_getAssociatedObject(self, &CWPopupKey);

}

- (void)setUseBlurForPopup:(BOOL)useBlurForPopup {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 && useBlurForPopup) {
        NSLog(@"ERROR: Blur unavailable prior to iOS 7");
        objc_setAssociatedObject(self, &CWUseBlurForPopup, [NSNumber numberWithBool:NO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, &CWUseBlurForPopup, [NSNumber numberWithBool:useBlurForPopup], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (BOOL)useBlurForPopup {
    NSNumber *result = objc_getAssociatedObject(self, &CWUseBlurForPopup);
    return [result boolValue];

}

@end
