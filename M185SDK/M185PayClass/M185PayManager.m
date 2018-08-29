//
//  M185PayManager.m
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185PayManager.h"
#import "M185CustomServersManager.h"

#import <BTWanSDK/BTWanSDK.h>

@implementation M185PayManager


+ (void)payStartWithConfig:(M185PayConfig *)config {
    BTWanPayData *data = [[BTWanPayData alloc] init];
    data.serverID = config.serverID;
    data.serverName = config.serverName;
    data.roleID = config.roleID;
    data.roleName = config.roleName;
    data.productID = config.productID;
    data.productName = config.productName;
    data.amount = config.amount;

    NSString *extensionUrl = [NSString stringWithFormat:@"{\"url\":\"%@\",\"u8orderID\":\"%@\"}",config.M185SDK_extension,config.orderID];

    NSData *base64Data = [extensionUrl dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64 = [base64Data base64EncodedStringWithOptions:kNilOptions];
    NSString *extension = [NSString stringWithFormat:@"SY185_%@",base64];
    syLog(@"\njsondata == %@",extensionUrl);
    syLog(@"\nbase64String == %@",base64);
    syLog(@"\nextenison == %@",extension);

    data.extension = extension;
    [BTWanSDK pay:data];
}

+ (void)payStartWithCustom:(id)customData {
    
}




@end
