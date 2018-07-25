//
//  M185CallBackDelegate.h
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 支付结果 */
typedef NS_ENUM(NSUInteger, M185PayResultCode) {
    CODE_PAY_SUCCESS = 1,       //支付成功
    CODE_PAY_FAIL,              //支付失败
    CODE_PAY_CANCEL,            //支付取消
    CODE_PAY_UNKNOWN            //未知错误
};

/** 登录结果 */
typedef NS_ENUM(NSUInteger, M185LoginResultCode) {
    CODE_LOGIN_SUCCESS,
    CODE_LOGIN_FAIL
};

@protocol M185CallBackDelegate <NSObject>

/**
 *  SDK初始化回调:
 *  初始化成功后可以掉起登录页面,否则无法掉起登录页面;
 */
- (void)M185SDKInitCallBackWithSuccess:(BOOL)success
                           Information:(NSDictionary *_Nonnull)dict;

/**
 *  登录的回调:
 *  成功: success 返回 true,dict 里返回 username 和 userToken
 *  失败: success 返回 false,dict 里返回 error message
 */
- (void)M185SDKLoginResultWithCode:(M185LoginResultCode)code
                       Information:(NSDictionary *_Nonnull)dict;

/**
 *  登出的回调:
 *  这个回调是从 SDK 登出的回调
 */
- (void)M185SDKLogOutCallBackWithSuccess:(BOOL)success
                             Information:(NSDictionary *_Nullable)dict;

/**
 *  切换账号回调:
 *  从 SDK 中点击了切换账号的回调
 */
- (void)M185SDKSwitchAccountCallBackWith:(BOOL)success
                             Information:(NSDictionary *_Nullable)dict;

/**
 *  充值回调
 */
- (void)M185SDKPayResultWithStatus:(M185PayResultCode)code
                       Information:(NSDictionary *_Nonnull)dict;








@end
