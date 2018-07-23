//
//  M185GMDelegate.h
//  M185SDK
//
//  Created by Sans on 2018/7/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol M185GMDelegate <NSObject>


+ (void)initGMWithServerid:(NSString *)serverID
                ServerName:(NSString *)serverName
                    RoleID:(NSString *)roleID
                  RoleName:(NSString *)roleName;

+ (void)initGMWithDictionary:(NSDictionary *)dict;



@end
