//
//  M185StatisticsDelegate.h
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M185SubmitData.h"

@protocol M185StatisticsDelegate <NSObject>


+ (void)submitDataWith:(M185SubmitData *)data;


+ (void)submitDataWithCustom:(id)customData;






@end
