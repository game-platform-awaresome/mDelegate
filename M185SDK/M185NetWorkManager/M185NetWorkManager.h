//
//  FFNetWorkManager.h
//  M185SDK
//
//  Created by 燚 on 2018/7/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetWorkSuccessBlock)(id success, NSDictionary *content);
typedef void(^NetWorkFailureBlock)(id failure, NSDictionary *content);
typedef void(^NetWorkWarningBlock)(id warning, NSDictionary *content);

int postRequest(id param, id url, NetWorkSuccessBlock success, NetWorkFailureBlock failure, NetWorkWarningBlock warning);

NSString * sign(id param, NSArray *keys);


@interface FFNetWorkManager : NSObject



+ (void)postRequestWithUrl:(id)url
                     Param:(id)param
              SuccessBlock:(NetWorkSuccessBlock)success
              FailureBlock:(NetWorkFailureBlock)failure
              WarningBlock:(NetWorkWarningBlock)warning;




@end











