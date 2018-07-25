//
//  M185ProgressManager.h
//  M185SDK
//
//  Created by Sans on 2018/7/25.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Start_network [M185ProgressManager start]
#define Stop_network [M185ProgressManager stop]

@interface M185ProgressManager : NSObject

+ (void)start;

+ (void)stop;


@end
