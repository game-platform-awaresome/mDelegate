//
//  M185SDKManager.m
//  M185SDK
//
//  Created by 燚 on 2018/7/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185SDKManager.h"
#import "M185NetWorkManager.h"
#import "M185DefaultSDK.h"

#import "M185PayManager.h"
#import "M185UserManager.h"
#import "M185StatisticsManager.h"
#import "M185CustomServersManager.h"


@interface M185SDKManager ()


@end

static M185SDKManager *_manager = nil;
@implementation M185SDKManager
{
    @public
    NSString *_interesting;

}

+ (M185SDKManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[M185SDKManager alloc] init];
        }
    });
    return _manager;
}


- (void)initSDKWith:(id)info {
    
}

- (void)initWithRH_AppID:(NSString *)RH_appID
           WithRH_AppKey:(NSString *)RH_appKey
       WithRH_ChannelIDL:(NSString *)RH_channelID
               WithAppID:(NSString *)appID
           WithClientKey:(NSString *)clientKey
    WithCallBackDelegate:(id<M185CallBackDelegate>)callBackDelegate {
    
    if (RH_appID == nil) {
        NSLog(@"%s -> param error",__func__);
        return;
    }
    if (RH_appKey == nil) {
        NSLog(@"%s -> param error",__func__);
        return;
    }
    if (RH_channelID == nil) {
        NSLog(@"%s -> param error",__func__);
        return;
    }
    if (appID == nil) {
        NSLog(@"%s -> param error",__func__);
        return;
    }
    if (clientKey == nil) {
        NSLog(@"%s -> param error",__func__);
        return;
    }
    if (callBackDelegate == nil) {
        NSLog(@"%s -> call back delelgate not found",__func__);
        return;
    }
    self.RH_appID = RH_appID;
    self.RH_appKey = RH_appKey;
    self.RH_channelID = RH_channelID;
    self.appID = appID;
    self.clientKey = clientKey;
    self.delegate = callBackDelegate;
    //上报设备
    [M185CustomServersManager upLoadDeviceInfo];
}

#pragma mark - app delegate
// UIapplication 事件
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[M185DefaultSDK sharedSDK] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[M185DefaultSDK sharedSDK] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[M185DefaultSDK sharedSDK] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[M185DefaultSDK sharedSDK] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[M185DefaultSDK sharedSDK] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[M185DefaultSDK sharedSDK] applicationWillTerminate:application];
}

// 推送通知相关事件
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    [[M185DefaultSDK sharedSDK] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    [[M185DefaultSDK sharedSDK] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification {
    [[M185DefaultSDK sharedSDK] application:application didReceiveLocalNotification:notification];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    [[M185DefaultSDK sharedSDK] application:application didReceiveRemoteNotification:userInfo];
}

// url处理
- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation {
    return [[M185DefaultSDK sharedSDK] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL*)url options:(NSDictionary *)options {
    return [[M185DefaultSDK sharedSDK] application:app openURL:url options:options];
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL *)url {
    return [[M185DefaultSDK sharedSDK] application:application handleOpenURL:url];
}

#pragma mark - user delegate
+ (void)login {
    if ([M185SDKManager sharedManager].isLogin == YES) {
        return;
    }
    [M185UserManager login];
}

+ (void)logOut {
    [M185SDKManager sharedManager].isLogin = NO;
    [M185UserManager logOut];
}

+ (void)showUserCenter {
    [M185UserManager showUserCenter];
}

+ (void)loginWithCustom:(id)customData {
    [M185UserManager loginWithCustom:customData];
}

#pragma pay delegate
+ (void)payStartWithConfig:(M185PayConfig *)config {
    [M185CustomServersManager pay:config];
}

+ (void)payStartWithCustom:(id)customData {
    [M185PayManager payStartWithCustom:customData];
}


#pragma mark - staitc delegate
+ (void)submitDataWith:(M185SubmitData *)data {
    [M185StatisticsManager submitDataWith:data];
}

+ (void)submitDataWithCustom:(id)customData {
    [M185StatisticsManager submitDataWithCustom:customData];
}


#pragma mark - gm delegate
+ (void)initGMWithDictionary:(NSDictionary *)dict {
    
}

+ (void)initGMWithServerid:(NSString *)serverID ServerName:(NSString *)serverName RoleID:(NSString *)roleID RoleName:(NSString *)roleName {
    
}



#pragma mark - getter
- (NSString *)urlString {
    return @"http://dev.185sy.com";
}






@end
















