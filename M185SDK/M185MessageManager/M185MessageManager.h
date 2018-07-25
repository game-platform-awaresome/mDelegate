//
//  M185MessageManager.h
//  M185SDK
//
//  Created by Sans on 2018/7/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>


#define M185Message(message) [M185MessageManager showAlertMessage:message]

@interface M185MessageManager : NSObject

+ (void)showAlertMessage:(NSString *)message;

+ (void)showMessage:(NSString *)message dismissAfter:(float)second;



@end
