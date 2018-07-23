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
#import "M185GMDelegate.h"


#define M185SDK [M185SDKManager sharedManager]

typedef void(^M185SDKInitCallBackBlock)(NSDictionary *content, BOOL success);

@interface M185SDKManager : NSObject
<M185AppDelegate,
M185UserDelegate,
M185PayDelegate,
M185StatisticsDelegate,
M185GMDelegate>

@property (strong, nonatomic)           NSString *RH_appID;
@property (strong, nonatomic)           NSString *RH_appKey;
@property (strong, nonatomic)           NSString *RH_channelID;
@property (strong, nonatomic)           NSString *appID;
@property (strong, nonatomic)           NSString *clientKey;

@property (strong, nonatomic, readonly) NSString *channelID;
@property (strong, nonatomic, readonly) NSString *channelName;

@property (strong, nonatomic)           NSString *urlString;

@property (strong, nonatomic)           id<M185CallBackDelegate> delegate;


@property (assign, nonatomic)           BOOL     isLogin;


+ (M185SDKManager *)sharedManager;


- (void)initSDKWith:(id)info;


- (void)initWithRH_AppID:(NSString *)RH_appID
           WithRH_AppKey:(NSString *)RH_appKey
       WithRH_ChannelIDL:(NSString *)RH_channelID
               WithAppID:(NSString *)appID
           WithClientKey:(NSString *)clientKey
    WithCallBackDelegate:(id<M185CallBackDelegate>)callBackDelegate;




@end








