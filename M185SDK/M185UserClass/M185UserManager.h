//
//  M185UserManager.h
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "M185UserDelegate.h"

@interface M185UserManager : NSObject <M185UserDelegate>

@property (strong, nonatomic) NSString      *userID;
@property (strong, nonatomic) NSString      *token;
@property (strong, nonatomic) NSString      *username;
@property (strong, nonatomic) NSString      *extension;
@property (strong, nonatomic) NSString      *sdkUserID;
@property (strong, nonatomic) NSString      *sdkUserName;
@property (strong, nonatomic) NSDictionary  *timestamp;

@property (strong, nonatomic) NSString      *switchAccount;


+ (M185UserManager *)currentUser;

+ (void)setCurrentUserDataWith:(NSDictionary *)data;



@end
