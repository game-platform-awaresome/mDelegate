//
//  M185SubmitData.m
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185SubmitData.h"

#define Sub(name) (name && [name isKindOfClass:[NSString class]] && ![name isEqualToString:@"error"] && name.length > 0)

@implementation M185SubmitData
/** @property (assign, nonatomic) M185SubmitType    type;
 @property (strong, nonatomic) NSString          *moneyNumber;
 @property (strong, nonatomic) NSString          *roleID;
 @property (strong, nonatomic) NSString          *roleName;
 @property (strong, nonatomic) NSString          *roleLevel;
 @property (strong, nonatomic) NSString          *serverID;
 @property (strong, nonatomic) NSString          *serverName;
 @property (strong, nonatomic) NSString          *vipLevel; */

- (NSString *)description {
    return [NSString stringWithFormat:@"M185SubmitType=%lu,moneyNumber=%@,roleID=%@,roleName=%@,roleLevel=%@,serverID=%@,serverName=%@,vipLevel=%@",(unsigned long)self.type,self.moneyNumber,self.roleID,self.roleName,self.roleLevel,self.serverID,self.serverName,self.vipLevel];
}


- (void)setType:(M185SubmitType)type {
    if (type > 0 && type <= 5) {
        _type = type;
    } else {
        _type = 1;
        NSLog(@"Sub mit data param type error");
    }
}

- (void)setMoneyNumber:(NSString *)moneyNumber {
    if ([moneyNumber isKindOfClass:[NSString class]] && ![moneyNumber isEqualToString:@"error"] && moneyNumber.length > 0) {
        _moneyNumber = moneyNumber;
    } else {
        _moneyNumber = @"";
        NSLog(@"Submit data param moneyNumber is empty");
    }
}

- (void)setRoleID:(NSString *)roleID {
    if (Sub(roleID)) {
        _roleID = roleID;
    } else {
        _roleID = @"";
        NSLog(@"Submit data param roleID is empty");
    }
}

- (void)setRoleName:(NSString *)roleName {
    if (Sub(roleName)) {
        _roleName = roleName;
    } else {
        _roleName = @"";
        NSLog(@"Submit data param roleName is empty");
    }
}

- (void)setRoleLevel:(NSString *)roleLevel {
    if (Sub(roleLevel)) {
        _roleLevel = roleLevel;
    } else {
        _roleLevel = @"0";
        NSLog(@"Submit data param roleLevel is empty");
    }
}

- (void)setServerID:(NSString *)serverID {
    if (Sub(serverID)) {
        _serverID = serverID;
    } else {
        _serverID = @"0";
        NSLog(@"Submit data param serverID is empty");
    }
}

- (void)setServerName:(NSString *)serverName {
    if (Sub(serverName)) {
        _serverName = serverName;
    } else {
        _serverName = @"";
        NSLog(@"Submit data param serverName is empty");
    }
}

- (void)setVipLevel:(NSString *)vipLevel {
    if (Sub(vipLevel)) {
        _vipLevel = vipLevel;
    } else {
        _vipLevel = @"";
        NSLog(@"Submit data param vipLevel is empty");
    }
}







@end
