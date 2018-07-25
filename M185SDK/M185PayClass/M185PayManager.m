//
//  M185PayManager.m
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185PayManager.h"
#import "M185CustomServersManager.h"

@implementation M185PayManager


+ (void)payStartWithConfig:(M185PayConfig *)config {
//    [M185CustomServersManager pay:config];
    NSLog(@"子SDK 发起 支付");
    if ([config isKindOfClass:[M185PayConfig class]]) {
        Class SY185SDK = NSClassFromString(@"SY185SDK");
        if (SY185SDK) {
            SEL selector = NSSelectorFromString(@"payStartWithServerID:serverName:roleID:roleName:productID:productName:amount:extension:");
            IMP imp = [SY185SDK methodForSelector:selector];
            void (*func)(id target,SEL ,id,id,id,id,id,id,id,id) = (void *)imp;
            if ([SY185SDK respondsToSelector:selector]) {
                NSString *extensionUrl = [NSString stringWithFormat:@"{\"url\":\"%@\",\"u8orderID\":\"%@\"}",config.M185SDK_extension,config.orderID];
                NSData *data = [extensionUrl dataUsingEncoding:NSUTF8StringEncoding];
                NSString *base64 = [data base64EncodedStringWithOptions:kNilOptions];
                NSString *extension = [NSString stringWithFormat:@"SY185_%@",base64];
                
                syLog(@"\njsondata == %@",extensionUrl);
                syLog(@"\nbase64String == %@",base64);
                syLog(@"\nextenison == %@",extension);
                
                func(SY185SDK,selector, config.serverID,config.serverName,config.roleID,config.roleName,config.productID,config.productName,config.amount,extension);
            }
        } else {
            M185Message(@"未找到子SDK");
        }
    }
}

+ (void)payStartWithCustom:(id)customData {
    
}




@end
