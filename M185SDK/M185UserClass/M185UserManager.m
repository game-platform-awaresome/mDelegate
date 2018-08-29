//
//  M185UserManager.m
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185UserManager.h"
#import <objc/runtime.h>
#import "M185NetWorkManager.h"
#import "BTWanRSDKManager.h"

#import <BTWanSDK/BTWanSDK.h>

static M185UserManager *_currentuser = nil;
@implementation M185UserManager

+ (M185UserManager *)currentUser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_currentuser) {
            _currentuser = [[M185UserManager alloc] init];
        }
    });
    return _currentuser;
}


+ (void)login {
    syLog(@"登录");
    [BTWanSDK login];
}

+ (void)logOut {
    syLog(@"登出");
    [BTWanSDK logOut];
}

+ (void)showUserCenter {
    
}

+ (void)loginWithCustom:(id)customData {
    
}

+ (void)switchAccount {
    
}

+ (void)GameExit {
    
}

- (void)removeAllProperty {
    self.userID = nil;
    self.token = nil;
    self.username = nil;
    self.extension = nil;
    self.sdkUserID = nil;
    self.sdkUserName = nil;
    self.timestamp = nil;
}

+ (void)setCurrentUserDataWith:(NSDictionary *)data {
    [M185UserManager currentUser].userID = [NSString stringWithFormat:@"%@",data[@"userID"]];
    [M185UserManager currentUser].token = [NSString stringWithFormat:@"%@",data[@"token"]];
    [M185UserManager currentUser].username = [NSString stringWithFormat:@"%@",data[@"username"]];
    [M185UserManager currentUser].extension = [NSString stringWithFormat:@"%@",data[@"extension"]];
    [M185UserManager currentUser].sdkUserID = [NSString stringWithFormat:@"%@",data[@"sdkUserID"]];
    [M185UserManager currentUser].sdkUserName = [NSString stringWithFormat:@"%@",data[@"sdkUserName"]];
    [M185UserManager currentUser].timestamp = data[@"timestamp"];
}




@end







