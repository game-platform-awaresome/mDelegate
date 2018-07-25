//
//  M185ProgressManager.m
//  M185SDK
//
//  Created by Sans on 2018/7/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185ProgressManager.h"
#import "M185ProgressHUD.h"


@interface M185ProgressManager ()

@property (strong, nonatomic) M185ProgressHUD *hud;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *appKeyWindow;

@end

static M185ProgressManager *manager = nil;
@implementation M185ProgressManager


+ (M185ProgressManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[M185ProgressManager alloc] init];
        }
    });
    return manager;
}

+ (void)start {
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
        [M185ProgressManager sharedManager].hud = [M185ProgressHUD showHUDAddedTo:vc.view animated:YES];
    } else {
        [M185ProgressManager sharedManager].hud = [M185ProgressHUD showHUDAddedTo:[M185ProgressManager sharedManager].window.rootViewController.view animated:YES];
    }
}


+ (void)stop {
    [[M185ProgressManager sharedManager].hud hideAnimated:YES];
    [[M185ProgressManager sharedManager].window resignKeyWindow];
    if ([M185ProgressManager sharedManager].appKeyWindow) {
        [[M185ProgressManager sharedManager].appKeyWindow makeKeyAndVisible];
    }
    [M185ProgressManager sharedManager].window = nil;
}


- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _window.backgroundColor = [UIColor clearColor];
        UIViewController *vc  = [UIViewController new];
        vc.view.backgroundColor = [UIColor clearColor];
        _window.windowLevel = UIWindowLevelAlert;
        _window.rootViewController = vc;
        self.appKeyWindow = [UIApplication sharedApplication].keyWindow;
        [_window makeKeyAndVisible];
    }
    return _window;
}




@end
