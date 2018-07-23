//
//  M185PayDelegate.h
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M185PayConfig.h"

@protocol M185PayDelegate <NSObject>

+ (void)payStartWithConfig:(M185PayConfig *)config;

+ (void)payStartWithCustom:(id)customData;


@end
