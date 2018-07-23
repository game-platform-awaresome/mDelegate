//
//  M185DefaultSDK.m
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185DefaultSDK.h"
#import <objc/runtime.h>
#import "M185SDKManager.h"
#import "M185CustomServersManager.h"
#import "M185PayConfig.h"


@interface M185DefaultSDK ()


@end


static M185DefaultSDK *_defaultSDK = nil;
@implementation M185DefaultSDK

+ (M185DefaultSDK *)sharedSDK {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_defaultSDK) {
            _defaultSDK = [[M185DefaultSDK alloc] init];
        }
    });
    return _defaultSDK;
}

#pragma mark - cuntom method
- (void)initChildSDK {
    Class SY185SDK = NSClassFromString(@"SY185SDK");
    if (SY185SDK) {
        SEL selector = NSSelectorFromString(@"initWithAppID:Appkey:Delegate:UseWindow:");
        IMP imp = [SY185SDK methodForSelector:selector];
        void (*func)(id target, SEL, id appID,id appKey,id delegate,BOOL) = (void *)imp;
        if ([SY185SDK respondsToSelector:selector]) {
            func(SY185SDK, selector,M185SDK.appID,M185SDK.clientKey,self,YES);
        }
    } else {
        NSLog(@"m185SDK default SDK not found, reload after 2 seconds");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initChildSDK];
        });
    }
}

+ (void)initWithAppID:(id)appID Appkey:(id)appkey Delegate:(id)delegate UseWindow:(BOOL)useWindow {
    
}

+ (void)pay:(M185PayConfig *)config {

}

#pragma mark - app delegate
// UIapplication 事件
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initChildSDK];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

// 推送通知相关事件
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    
}

- (void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification {
   
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    
}

// url处理
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL*)url options:(NSDictionary *)options {
    return YES;
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL *)url {
    return YES;
}


#pragma mark - delegate
- (void)m185SDKInitCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    if ([M185SDK.delegate respondsToSelector:@selector(M185SDKInitCallBackWithSuccess:Information:)]) {
        [M185SDK.delegate M185SDKInitCallBackWithSuccess:success Information:dict];
    }
}

- (void)m185SDKLoginCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    if (success) {
        NSString *token  = dict[@"token"];
        NSString *username = dict[@"username"];
        NSString *extension = [NSString stringWithFormat:@"{\"username\":\"%@\",\"token\":\"%@\"}",username,token];
        [M185CustomServersManager getUserDataWithExtension:extension];
    } else {
        NSLog(@"登录失败");
        M185SDK.isLogin = NO;
    }
}

- (void)m185SDKLogOutCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    if (success) {
        NSLog(@"登出成功");
        if ([M185SDK.delegate respondsToSelector:@selector(M185SDKLogOutCallBackWithSuccess:Information:)]) {
            [M185SDK.delegate M185SDKLogOutCallBackWithSuccess:YES Information:@{@"msg":@"退出登录"}];
        }
    }
}

- (void)m185SDKRechargeCallBackWithSuccess:(BOOL)success withInformation:(NSDictionary *)dict {
    if ([M185SDK.delegate respondsToSelector:@selector(M185SDKRechargeCallBackWithSuccess:Information:)]) {
        [M185SDK.delegate  M185SDKRechargeCallBackWithSuccess:success Information:dict];
    }
}






@end


