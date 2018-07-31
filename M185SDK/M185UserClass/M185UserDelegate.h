//
//  M185UserDelegate.h
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol M185UserDelegate <NSObject>

//普通账户功能

/** 登录 */
+ (void)login;

/** 登出 */
+ (void)logOut;

/** 显示用户中电信 */
+ (void)showUserCenter;

/** 自定义登陆事件 */
+ (void)loginWithCustom:(id)customData;

/** 切换账号 */
+ (void)switchAccount;

/** 退出游戏 */
+ (void)GameExit;


@end
