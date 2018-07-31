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
#import "M185SDKManager.h"

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
    Class SY185SDK = NSClassFromString(@"SY185SDK");
    if (SY185SDK) {
        SEL selector = NSSelectorFromString(@"showLoginView");
        IMP imp = [SY185SDK methodForSelector:selector];
        void (*func)(void) = (void *)imp;
        if ([SY185SDK respondsToSelector:selector]) {
            func();
        }
    } else {
        M185Message(@"未找到子SDK");
    }
}

+ (void)logOut {
    Class SY185SDK = NSClassFromString(@"SY185SDK");
    if (SY185SDK) {
        SEL selector = NSSelectorFromString(@"signOut");
        IMP imp = [SY185SDK methodForSelector:selector];
        void (*func)(void) = (void *)imp;
        if ([SY185SDK respondsToSelector:selector]) {
            func();
        }
        [[M185UserManager currentUser] removeAllProperty];
    } else {
        M185Message(@"未找到子SDK");
    }
    
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
//    // 获取当前类的所有属性
//    unsigned int count;// 记录属性个数
//    objc_property_t *properties = class_copyPropertyList([self class], &count);
//    // 遍历
//    NSMutableArray *names = [NSMutableArray array];
//    for (int i = 0; i < count; i++) {
//        // objc_property_t 属性类型
//        objc_property_t property = properties[i];
//        // 获取属性的名称 C语言字符串
//        const char *cName = property_getName(property);
//        // 转换为Objective C 字符串
//        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
//        [names addObject:name];
//    }
//
//    for (NSString *name in names) {
//        [self setValue:nil forKey:name];
//    }
    
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







