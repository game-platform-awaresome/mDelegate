//
//  M185DefaultSDK.h
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M185AppDelegate.h"

@interface M185DefaultSDK : NSObject <M185AppDelegate>

+ (M185DefaultSDK *)sharedSDK;


+ (void)pay:(id)config;

@end
