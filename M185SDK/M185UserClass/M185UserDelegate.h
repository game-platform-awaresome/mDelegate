//
//  M185UserDelegate.h
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol M185UserDelegate <NSObject>

/** 普通账户功能 */
+ (void)login;

+ (void)logOut;

+ (void)showUserCenter;

+ (void)loginWithCustom:(id)customData;

+ (void)switchAccount;


@end
