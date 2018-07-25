//
//  M185MessageManager.m
//  M185SDK
//
//  Created by Sans on 2018/7/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185MessageManager.h"
#import <UIKit/UIKit.h>

static UIWindow *appKeyWindow;
@implementation M185MessageManager


+ (void)showAlertMessage:(NSString *)message {
    [M185MessageManager showMessage:message dismissAfter:0.7];
}

+ (void)showMessage:(NSString *)message dismissAfter:(float)second {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIWindow *defaultWindow;
    NSArray<UIWindow *> *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        if ((window.windowLevel == UIWindowLevelNormal) && (window.bounds.size.width == [UIScreen mainScreen].bounds.size.width)) {
            defaultWindow = window;
            break;
        } else {
            continue;
        }
    }
    UIViewController *vc = defaultWindow ? defaultWindow.rootViewController : nil;
    
    if (vc) {
        [vc presentViewController:alertController animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
    } else {
        appKeyWindow = [UIApplication sharedApplication].keyWindow;
        [[M185MessageManager defaultWindow] makeKeyAndVisible];
        vc = [M185MessageManager defaultWindow].rootViewController;
        [vc presentViewController:alertController animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:^{
                [[M185MessageManager defaultWindow] resignKeyWindow];
                if (appKeyWindow) {
                    [appKeyWindow makeKeyAndVisible];
                }
                window = nil;
            }];
        });
    }
}

static UIWindow *window = nil;
+ (UIWindow *)defaultWindow {
    if (window == nil) {
        window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        window.windowLevel = UIWindowLevelAlert;
        window.rootViewController = [UIViewController new];
    }
    return window;
}



@end
