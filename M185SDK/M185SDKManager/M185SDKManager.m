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
#import "M185MessageManager.h"


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

- (void)setCallBackDelegate:(id<M185CallBackDelegate>)delegate {
    self.delegate = delegate;
}

- (void)initWithRH_AppID:(NSString *)RH_appID
           WithRH_AppKey:(NSString *)RH_appKey
       WithRH_ChannelIDL:(NSString *)RH_channelID
               WithAppID:(NSString *)appID
           WithClientKey:(NSString *)clientKey
    WithCallBackDelegate:(id<M185CallBackDelegate>)callBackDelegate {

    if (RH_appID == nil) {
        M185Message(@"RH_appID 有误.");
        return;
    }
    if (RH_appKey == nil) {
        M185Message(@"RH_appKey 有误.");
        return;
    }
    if (RH_channelID == nil) {
        M185Message(@"RH_channelID 有误.");
        return;
    }
    if (appID == nil) {
        M185Message(@"appID 有误.");
        return;
    }
    if (clientKey == nil) {
        M185Message(@"clientKey 有误.");
        return;
    }
    if (callBackDelegate == nil) {
        M185Message(@"接收回调信息的代理不能为空");
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

- (void)getInfoWithPlist {
     NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"M185Config" ofType:@"plist"]];
    if (dict) {
        self.RH_appID = dict[@"RH_AppID"] ? [NSString stringWithFormat:@"%@",dict[@"RH_AppID"]] : nil;
        self.RH_appKey = dict[@"RH_AppKey"] ? [NSString stringWithFormat:@"%@",dict[@"RH_AppKey"]] : nil;
        self.RH_channelID = dict[@"RH_ChannelID"] ? [NSString stringWithFormat:@"%@",dict[@"RH_ChannelID"]] : nil;
        self.appID = dict[@"AppID"] ? [NSString stringWithFormat:@"%@",dict[@"AppID"]] : nil;
        self.clientKey = dict[@"ClientKey"] ? [NSString stringWithFormat:@"%@",dict[@"ClientKey"]] : nil;
        if (self.RH_appID == nil) {
            M185Message(@"RH_appID 有误.");
            return;
        }
        if (self.RH_appKey == nil) {
            M185Message(@"RH_appKey 有误.");
            return;
        }
        if (self.RH_channelID == nil) {
            M185Message(@"RH_channelID 有误.");
            return;
        }
        if (self.appID == nil) {
            M185Message(@"appID 有误.");
            return;
        }
        if (self.clientKey == nil) {
            M185Message(@"clientKey 有误.");
            return;
        }
        //上报设备
        [M185CustomServersManager upLoadDeviceInfo];
    } else {
        M185Message(@"未找到配置文件");
    }
}

#pragma mark - app delegate
// UIapplication 事件
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self getInfoWithPlist];
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

+ (void)switchAccount {
    [M185UserManager switchAccount];
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



#pragma mark - getter
- (NSString *)urlString {
    return @"http://dev.185sy.com";
}






@end
















