//
//  M185StatisticsManager.m
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185StatisticsManager.h"
#import "M185CustomServersManager.h"

@implementation M185StatisticsManager


+ (void)submitDataWith:(M185SubmitData *)data {
    
    NSLog(@"上报数据  == %@",data);
    
    [M185CustomServersManager submitGameData:data];
    
    [M185StatisticsManager submitChildSDKData:data];
}

+ (void)submitChildSDKData:(M185SubmitData *)data {
    Class SY185SDK = NSClassFromString(@"SY185SDK");
    if (SY185SDK) {
        SEL selector = NSSelectorFromString(@"submitExtraDataWithType:ServerID:ServerName:RoleID:RoleName:RoleLevel:Money:VipLevel:");
        IMP imp = [SY185SDK methodForSelector:selector];
        void (*func)(id target,SEL ,NSUInteger,id,id,id,id,id,id,id) = (void *)imp;
        if ([SY185SDK respondsToSelector:selector]) {
            func(SY185SDK,
                 selector,
                 data.type,
                 data.serverID,
                 data.serverName,
                 data.roleID,
                 data.roleName,
                 data.roleLevel,
                 data.moneyNumber,
                 data.vipLevel);
        }
    } else {
        M185Message(@"未找到子SDK");
    }
}


+ (void)submitDataWithCustom:(id)customData {
    [M185CustomServersManager submitGameData:customData];
}



@end
