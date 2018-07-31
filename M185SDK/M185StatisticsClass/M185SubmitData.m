//
//  M185SubmitData.m
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185SubmitData.h"

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



@end
