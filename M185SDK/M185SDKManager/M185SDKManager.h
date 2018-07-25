//
//  M185SDKManager.h
//  M185SDK
//
//  Created by 燚 on 2018/7/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M185CallBackDelegate.h"
#import "M185AppDelegate.h"
#import "M185UserDelegate.h"
#import "M185PayDelegate.h"
#import "M185StatisticsDelegate.h"


#define M185SDK [M185SDKManager sharedManager]

typedef void(^M185SDKInitCallBackBlock)(NSDictionary *content, BOOL success);

@interface M185SDKManager : NSObject
<M185AppDelegate,
M185UserDelegate,
M185PayDelegate,
M185StatisticsDelegate>

//游戏研发参数
@property (strong, nonatomic)           NSString *RH_appID;
@property (strong, nonatomic)           NSString *RH_appKey;

//出包的时候改参数
@property (strong, nonatomic)           NSString *RH_channelID;

//子渠道 SDK 参数 , 也需要修改
@property (strong, nonatomic)           NSString *appID;
@property (strong, nonatomic)           NSString *clientKey;



@property (strong, nonatomic, readonly) NSString *channelID;
@property (strong, nonatomic, readonly) NSString *channelName;

@property (strong, nonatomic)           NSString *urlString;

@property (strong, nonatomic)           id<M185CallBackDelegate> delegate;


@property (assign, nonatomic)           BOOL     isLogin;


+ (M185SDKManager *)sharedManager;


- (void)setCallBackDelegate:(id<M185CallBackDelegate>)delegate;


@end








