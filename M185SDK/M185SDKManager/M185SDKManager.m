//
//  M185SDKManager.m
//  M185SDK
//
//  Created by 燚 on 2018/7/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185SDKManager.h"
#import "M185NetWorkManager.h"
#import <CommonCrypto/CommonDigest.h>

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

- (void)sayHi {
    NSLog(@"%s -> hi",__func__);

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setObject:@"1" forKey:@"page"];
    [dict setObject:[self signWithParms:dict WithKeys:@[@"page"]] forKey:@"sign"];
    postRequest(dict, @"http://www.mech1688.com/index.php?g=api&m=Dynamic&a=index", ^(NSDictionary *content) {
        NSLog(@" success ->  %@ ",content);
    }, ^(NSDictionary *content) {
        NSLog(@" failure ->  %@ ",content);
    }, ^(NSDictionary *content) {
        NSLog(@" warning ->  %@ ",content);
    });
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
- (void)setInteresing:(NSString *)interesing  {
    _interesting = interesing;
    NSLog(@"======%@" ,interesing);
}


- (NSString *)interesing {
    return _interesting;
}


/** 签名 */
- (NSString *)signWithParms:(NSDictionary *)params WithKeys:(NSArray *)keys {
    NSMutableString *signString = [NSMutableString string];
    [keys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [signString appendString:obj];
        [signString appendString:@"="];
        if (params[obj] == nil) {
            return ;
        }
        [signString appendString:params[obj]];
        if (idx < keys.count - 1) {
            [signString appendString:@"&"];
        }
    }];
    NSString *key = @"&#@KH^2892JY&@(220(@f";
    [signString appendString:key];
    return [self md5:signString];
}

- (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        //注意：这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}





@end
















