//
//  M185SubmitData.h
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    M185SubmitTypeSelectServer = 1,
    M185SubmitTypeCreatingARole,
    M185SubmitTypeEnterTheGame,
    M185SubmitTypeUpgradeLevel,
    M185SubmitTypeExitGame
} M185SubmitType;


@interface M185SubmitData : NSObject

@property (assign, nonatomic) M185SubmitType    type;
@property (strong, nonatomic) NSString          *moneyNumber;
@property (strong, nonatomic) NSString          *roleID;
@property (strong, nonatomic) NSString          *roleName;
@property (strong, nonatomic) NSString          *roleLevel;
@property (strong, nonatomic) NSString          *serverID;
@property (strong, nonatomic) NSString          *serverName;
@property (strong, nonatomic) NSString          *vipLevel;

@property (strong, nonatomic) NSString          *extension1;
@property (strong, nonatomic) NSString          *extension2;
@property (strong, nonatomic) NSString          *extension3;




@end
