//
//  M185DefaultSDK.m
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185DefaultSDK.h"
#import <objc/runtime.h>
#import "BTWanRSDKManager.h"
#import "M185CustomServersManager.h"
#import "M185PayConfig.h"
#import "M185UserManager.h"

#import <BTWanSDK/BTWanSDK.h>


@interface M185DefaultSDK ()<BTWanCallBackDelegate>


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
    if (M185SDK.appID == nil) {
        M185Message(@"appID 错误");
        return;
    }
    if (M185SDK.clientKey == nil) {
        M185Message(@"clientKey 错误");
        return;
    }

    syLog(@"初始化 子 SDK");
    [BTWanSDK SDKShowMessage];
    [BTWanSDK initWithAppID:M185SDK.appID Appkey:M185SDK.clientKey CallBackDelegate:self];
    
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

#pragma mark - child sdk delegate
- (void)BTWanSDKInitCallBackWithSuccess:(BOOL)success Information:(NSDictionary * _Nonnull)dict {

    if ([M185SDK.delegate respondsToSelector:@selector(BTWanRSDKInitCallBackWithSuccess:Information:)]) {
        [M185SDK.delegate BTWanRSDKInitCallBackWithSuccess:success Information:dict];
    }
}

- (void)BTWanSDKLoginCallBackWithSuccess:(BOOL)success Information:(NSDictionary * _Nonnull)dict {
    if (success) {
        NSString *token  = dict[@"token"];
        NSString *username = dict[@"username"];
        NSString *extension = [NSString stringWithFormat:@"{\"username\":\"%@\",\"token\":\"%@\"}",username,token];
        [M185CustomServersManager getUserDataWithExtension:extension];
    } else {
        M185SDK.isLogin = NO;
    }
}

- (void)BTWanSDKLogOutCallBackWithSuccess:(BOOL)success Information:(NSDictionary * _Nullable)dict {
    if (success) {
        if ([M185SDK.delegate respondsToSelector:@selector(BTWanRSDKLogOutCallBackWithSuccess:Information:)]) {
            [M185SDK.delegate BTWanRSDKLogOutCallBackWithSuccess:YES Information:@{@"msg":@"退出登录"}];
        }
    }
}


- (void)BTWanSDKRechargeCallBackWithSuccess:(BOOL)success Information:(NSDictionary * _Nonnull)dict {
    M185PayResultCode code = CODE_PAY_UNKNOWN;
    if (success) {
        code = CODE_PAY_SUCCESS;
    } else {
        code = CODE_PAY_FAIL;
    }
    if ([M185SDK.delegate respondsToSelector:@selector(BTWanRSDKPayResultWithStatus:Information:)]) {
        [M185SDK.delegate  BTWanRSDKPayResultWithStatus:code Information:dict];
    }
}

- (void)BTWanSDKSwitchAccountCallBackWithSuccess:(BOOL)success Information:(NSDictionary * _Nonnull)dict {
    [M185UserManager currentUser].switchAccount = @"1";
    NSString *token  = dict[@"token"];
    NSString *username = dict[@"username"];
    NSString *extension = [NSString stringWithFormat:@"{\"username\":\"%@\",\"token\":\"%@\"}",username,token];
    [M185CustomServersManager getUserDataWithExtension:extension];
}

- (void)BTWanSDKGMFunctionSendPropsCallBackWithSuccess:(BOOL)success Information:(NSDictionary * _Nonnull)dict {

}



@end


