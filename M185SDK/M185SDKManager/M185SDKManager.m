//
//  M185SDKManager.m
//  M185SDK
//
//  Created by 燚 on 2018/7/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185SDKManager.h"


@interface M185SDKManager ()


@end

static M185SDKManager *_manager = nil;
@implementation M185SDKManager
{
    @public
    NSString *_interesting;

    @private

    @protected
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

- (void)sayHi {
    NSLog(@"%s -> hi",__func__);
    self.interesing = @"";
    NSLog(@"测试成功了");
    
}

#pragma mark - app delegate
// UIapplication 事件
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

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





@synthesize interesing = _interesting;



@end
















