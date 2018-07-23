//
//  M185CustomServersManager.h
//  M185SDK
//
//  Created by Sans on 2018/7/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M185CustomServersManager : NSObject

/** 收集信息 */
+ (void)upLoadDeviceInfo;

/** 获取用户信息 */
+ (void)getUserDataWithExtension:(NSString *)extension;

/** 上报数据 */
+ (void)submitGameData:(id)data;

/** 发起支付 */
+ (void)pay:(id)data;

+ (NSString *)notifyUrl;

@end
