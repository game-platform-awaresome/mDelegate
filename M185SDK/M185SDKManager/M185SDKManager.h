//
//  M185SDKManager.h
//  M185SDK
//
//  Created by 燚 on 2018/7/19.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M185AppDelegate.h"

#define M185SDK [M185SDKManager sharedManager]

@interface M185SDKManager : NSObject <M185AppDelegate>

+ (M185SDKManager *)sharedManager;


- (void)sayHi;





@end








