//
//  M185PayConfig.h
//  M185SDK
//
//  Created by Sans on 2018/7/22.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface M185PayConfig : NSObject

@property (strong, nonatomic) NSString *productID;              //商品ID
@property (strong, nonatomic) NSString *productName;            //商品名称
@property (strong, nonatomic) NSString *productDesc;             //商品描述
@property (strong, nonatomic) NSString *amount;                 //金额

@property (strong, nonatomic) NSString *roleID;                 //角色ID
@property (strong, nonatomic) NSString *roleName;               //角色名称
@property (strong, nonatomic) NSString *roleLevel;              //角色等级

@property (strong, nonatomic) NSString *serverID;               //服务器ID
@property (strong, nonatomic) NSString *serverName;             //服务器名称
@property (strong, nonatomic) NSString *extension;              //透传参数

@property (strong, nonatomic) NSString *reservedParam1;         //预留参数1
@property (strong, nonatomic) NSString *reservedParam2;         //预留参数2
@property (strong, nonatomic) NSString *reservedParam3;         //预留参数3


@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) NSString *M185SDK_extension;





@end
