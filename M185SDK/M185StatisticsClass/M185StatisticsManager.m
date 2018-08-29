//
//  M185StatisticsManager.m
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185StatisticsManager.h"
#import "M185CustomServersManager.h"
#import <BTWanSDK/BTWanSDK.h>

@implementation M185StatisticsManager


+ (void)submitDataWith:(M185SubmitData *)data {
    
    NSLog(@"上报数据  == %@",data);
    
    [M185CustomServersManager submitGameData:data];
    
    [M185StatisticsManager submitChildSDKData:data];
}

+ (void)submitChildSDKData:(M185SubmitData *)data {
    BTWanSubmitData *btwanData = [[BTWanSubmitData alloc] init];
    btwanData.submitType = (NSUInteger)data.type;
    btwanData.serverID = data.serverID;
    btwanData.serverName = data.serverName;
    btwanData.roleID = data.roleID;
    btwanData.roleName = data.roleName;
    btwanData.roleLevel = data.roleLevel;
    btwanData.money = data.moneyNumber;
    btwanData.vipLevel = data.vipLevel;
    [BTWanSDK submitExtraData:btwanData];
}


+ (void)submitDataWithCustom:(id)customData {
    [M185CustomServersManager submitGameData:customData];
}



@end
