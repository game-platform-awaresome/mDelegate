//
//  M185CustomServersManager.m
//  M185SDK
//
//  Created by Sans on 2018/7/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185CustomServersManager.h"
#import "M185NetWorkManager.h"
#import "BTWanRSDKManager.h"
#import "M185UserManager.h"
#import "M185PayManager.h"

#import "M185SubmitData.h"
#import "M185PayConfig.h"

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/ASIdentifierManager.h>


#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

static NSString * const kAFCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";
static NSString * const kAFCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";

NSString *screenWidth() {
//    NSString *result;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat screenX = [UIScreen mainScreen].bounds.size.width * scale;
    CGFloat screenY = [UIScreen mainScreen].bounds.size.height * scale;
    return [NSString stringWithFormat:@"%.2f X %.2f",screenX,screenY];
}

NSString *CU7X000(NSString * input) {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        //注意：这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}


static BOOL m185_PayStart = NO;

@implementation M185CustomServersManager


/** 收集信息 */
+ (void)upLoadDeviceInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *paramArray = @[@"appID",@"channelID",@"deviceDpi",@"deviceID",@"deviceOS",@"deviceType",@"mac"];
    [dict setObject:M185SDK.RH_appID forKey:@"appID"];
    [dict setObject:M185SDK.RH_channelID forKey:@"channelID"];
    [dict setObject:screenWidth() forKey:@"deviceDpi"];
    [dict setObject:[M185CustomServersManager uniqueIdentifier] forKey:@"deviceID"];
    [dict setObject:@"2" forKey:@"deviceOS"];
    [dict setObject:[UIDevice currentDevice].model forKey:@"deviceType"];
    [dict setObject:[M185CustomServersManager macAddress] forKey:@"mac"];
    [dict setObject:sign(dict, paramArray) forKey:@"sign"];
    
    [dict setObject:@"0" forKey:@"subChannelID"];
    
    postRequest(dict, [NSString stringWithFormat:@"%@/user/addDevice",M185SDK.urlString], ^(id success, NSDictionary *content) {
        if (content) {
            NSString *state = content[@"state"];
            if (state.integerValue == 1) {
                syLog(@"M185SDK -> 初始化成功");
//                if ([M185SDK.delegate respondsToSelector:@selector(BTWanRSDKInitCallBackWithSuccess:Information:)]) {
//                    [M185SDK.delegate BTWanRSDKInitCallBackWithSuccess:YES Information:@{@"msg":@"初始化成功"}];
//                }
            } else {
                syLog(@"M185SDK -> %@",content);
//                if ([M185SDK.delegate respondsToSelector:@selector(M185SDKInitCallBackWithSuccess:Information:)]) {
//                    [M185SDK.delegate M185SDKInitCallBackWithSuccess:NO Information:@{@"msg":@"初始化失败"}];
//                }
            }
        }
    }, ^(id failure, NSDictionary *content) {
//        if ([M185SDK.delegate respondsToSelector:@selector(M185SDKInitCallBackWithSuccess:Information:)]) {
//            [M185SDK.delegate M185SDKInitCallBackWithSuccess:NO Information:@{@"msg":@"服务器维护中"}];
//        }
    }, ^(id warning, NSDictionary *content) {
        if (content) {
            syLog(@"M185SDK == %@",content);
        }
    });
}

/** 获取用户token */
+ (void)getUserDataWithExtension:(NSString *)extension {

    if (!extension) {
        syLog(@"获取用户 token 数据不能为空");
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *paramArray = @[@"appID",@"channelID",@"extension"];
    
    [dict setObject:M185SDK.RH_appID forKey:@"appID"];
    [dict setObject:M185SDK.RH_channelID forKey:@"channelID"];
    [dict setObject:extension forKey:@"extension"];
    [dict setObject:sign(dict, paramArray) forKey:@"sign"];
    
    [dict setObject:@"0" forKey:@"subChannelID"];
    [dict setObject:[M185CustomServersManager uniqueIdentifier] forKey:@"deviceID"];
    [dict setObject:@"1" forKey:@"sdkVersionCode"];

    [BTWanRSDKManager sharedManager].isLogin = YES;
    
    postRequest(dict, [NSString stringWithFormat:@"%@/user/getToken",M185SDK.urlString], ^(id success, NSDictionary *content) {
        if (content) {
            NSString *state = content[@"state"];
            [BTWanRSDKManager sharedManager].isLogin = NO;
            M185LoginResultCode code = CODE_LOGIN_FAIL;
            if (state.integerValue == 1) {
                [M185UserManager setCurrentUserDataWith:content[@"data"]];
                
                code = CODE_LOGIN_SUCCESS;
                
                if ([M185UserManager currentUser].switchAccount.boolValue) {
                    if ([M185SDK.delegate respondsToSelector:@selector(BTWanRSDKSwitchAccountCallBackWith:Information:)]) {
                        NSString *username1 = [NSString stringWithFormat:@"%@",content[@"data"][@"userID"]];
                        NSString *token1 = [NSString stringWithFormat:@"%@",content[@"data"][@"token"]];
                        NSString *extension1 = @"";
                        [M185SDK.delegate BTWanRSDKSwitchAccountCallBackWith:code
                                                               Information:@{@"userID":username1,
                                                                             @"token":token1,
                                                                             @"extension":extension1}];
                        [M185UserManager currentUser].switchAccount = @"0";
                    }
                } else {
                    if ([M185SDK.delegate respondsToSelector:@selector(BTWanRSDKLoginResultWithCode:Information:)]) {
                        NSString *username1 = [NSString stringWithFormat:@"%@",content[@"data"][@"userID"]];
                        NSString *token1 = [NSString stringWithFormat:@"%@",content[@"data"][@"token"]];
                        NSString *extension1 = @"";
                        [M185SDK.delegate BTWanRSDKLoginResultWithCode:code
                                                           Information:@{@"userID":username1,
                                                                         @"token":token1,
                                                                        @"extension":extension1}];
                    }
                }
                
                
                
            } else {
                if ([M185SDK.delegate respondsToSelector:@selector(BTWanRSDKLoginResultWithCode:Information:)]) {
                    [M185SDK.delegate BTWanRSDKLoginResultWithCode:code Information:@{@"msg":content}];
                    [BTWanRSDKManager logOut];
                }
            }
        }
    }, ^(id failure, NSDictionary *content) {
        if (content) {
            if ([M185SDK.delegate respondsToSelector:@selector(BTWanRSDKLoginResultWithCode:Information:)]) {
                [BTWanRSDKManager logOut];
                [M185SDK.delegate BTWanRSDKLoginResultWithCode:CODE_LOGIN_FAIL Information:@{@"msg":@"连接服务器失败"}];
            }
        }
    }, ^(id warning, NSDictionary *content) {
        if (content) {
            syLog(@"warning == %@",content);
        }
    });
}

/** 上报数据 */
+ (void)submitGameData:(id)data {
    if ([M185UserManager currentUser].userID == nil) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *paramArray = @[@"appID",@"channelID",@"deviceID",@"opType",
                            @"roleID",@"roleLevel",@"roleName",@"serverID",
                            @"serverName",@"userID"];
    
    if ([data isKindOfClass:[M185SubmitData classForCoder]]) {
        M185SubmitData *submitdata = data;
        
        [dict setObject:M185SDK.RH_appID forKey:@"appID"];
        [dict setObject:M185SDK.RH_channelID forKey:@"channelID"];
        [dict setObject:[M185CustomServersManager uniqueIdentifier] forKey:@"deviceID"];
        [dict setObject:[NSString stringWithFormat:@"%lu",submitdata.type] forKey:@"opType"];
        
        [dict setObject:submitdata.roleID forKey:@"roleID"];
        [dict setObject:submitdata.roleLevel forKey:@"roleLevel"];
        [dict setObject:submitdata.roleName forKey:@"roleName"];
        [dict setObject:submitdata.serverID forKey:@"serverID"];
        
        [dict setObject:submitdata.serverName forKey:@"serverName"];
        [dict setObject:[M185UserManager currentUser].userID forKey:@"userID"];
        [dict setObject:sign(dict, paramArray) forKey:@"sign"];
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        
        [dict setObject:data[@"appID"] forKey:@"appID"];
        [dict setObject:data[@"channelID"] forKey:@"channelID"];
        [dict setObject:data[@"deviceID"] forKey:@"deviceID"];
        [dict setObject:data[@"opType"] forKey:@"opType"];
        
        [dict setObject:data[@"roleID"] forKey:@"roleID"];
        [dict setObject:data[@"roleLevel"] forKey:@"roleLevel"];
        [dict setObject:data[@"roleName"] forKey:@"roleName"];
        [dict setObject:data[@"serverID"] forKey:@"serverID"];
        
        [dict setObject:data[@"serverName"] forKey:@"serverName"];
        [dict setObject:[M185UserManager currentUser].userID forKey:@"userID"];
        
    } else {
        syLog(@"submit data type error.");
        return;
    }
    
    postRequest(dict, [NSString stringWithFormat:@"%@/user/addUserLog",M185SDK.urlString], ^(id success, NSDictionary *content)  {
        if (content) {
            NSString *state = content[@"state"];
            if (state.integerValue == 1) {
                syLog(@"上报数据成功  == %@",content);
                NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"M185Config" ofType:@"plist"]];
                NSNumber *debug = dict[@"Debug"];
                if (debug.boolValue) {
                    M185Message(([NSString stringWithFormat:@"上报数据成功%@",[data description]]));
                }
            } else {
                syLog(@"上报数据失败  == %@",content);
            }
        }
    }, ^(id failure, NSDictionary *content) {
        if (content) {
            syLog(@"warning == %@",content);
        }
    }, ^(id warning, NSDictionary *content) {
        if (content) {
            syLog(@"warning == %@",content);
        }
    });
}

+ (void)pay:(id)data {
    if ([M185UserManager currentUser].userID == nil || [M185UserManager currentUser].userID.length < 1) {
        
        return;
    }
    
    if (m185_PayStart) {
        
        return;
    }
    
    M185PayConfig *config;
    if ([data isKindOfClass:[M185PayConfig class]]) {
        config = data;
    } else if ([config isKindOfClass:[NSDictionary class]]) {
        config = [[M185PayConfig alloc] init];
        config.productID = [NSString stringWithFormat:@"%@",data[@"productID"]];
        config.productName = [NSString stringWithFormat:@"%@",data[@"productName"]];
        config.productDesc = [NSString stringWithFormat:@"%@",data[@"productDesc"]];
        config.amount = [NSString stringWithFormat:@"%@",data[@"amount"]];
        config.roleName = [NSString stringWithFormat:@"%@",data[@"roleName"]];
        config.roleID = [NSString stringWithFormat:@"%@",data[@"roleID"]];
        config.roleLevel = [NSString stringWithFormat:@"%@",data[@"roleLevel"]];
        config.serverID = [NSString stringWithFormat:@"%@",data[@"serverID"]];
        config.serverName = [NSString stringWithFormat:@"%@",data[@"serverName"]];
        config.extension = [NSString stringWithFormat:@"%@",data[@"extension"]];
    } else {
        M185Message(@"支付信息错误");
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:[M185UserManager currentUser].userID forKey:@"userID"];
    [dict setObject:config.productID ?: @"" forKey:@"productID"];
    [dict setObject:config.productName ?: @"" forKey:@"productName"];
    [dict setObject:config.productDesc ?: @"" forKey:@"productDesc"];
    [dict setObject:[NSString stringWithFormat:@"%ld",config.amount.integerValue * 100] forKey:@"money"];
    [dict setObject:config.roleID ?: @"" forKey:@"roleID"];
    [dict setObject:config.roleName ?: @"" forKey:@"roleName"];
    [dict setObject:config.roleLevel ?: @"" forKey:@"roleLevel"];
    [dict setObject:config.serverID ?: @"" forKey:@"serverID"];
    [dict setObject:config.serverName ?: @"" forKey:@"serverName"];
    [dict setObject:config.extension ?: @"" forKey:@"extension"];
    
    [dict setObject:M185SDK.RH_appID forKey:@"appID"];
    [dict setObject:M185SDK.RH_channelID forKey:@"channelID"];
    [dict setObject:@"md5" forKey:@"signType"];
    
    [dict setObject:@"2" forKey:@"deviceType"];
    
    if (config.notifyUrl && config.notifyUrl.length > 0) {
        [dict setObject:config.notifyUrl forKey:@"notifyUrl"];
    }
    
    NSString* sign = [NSString stringWithFormat:@"userID=%@&productID=%@&productName=%@&productDesc=%@&money=%@&roleID=%@&roleName=%@&roleLevel=%@&serverID=%@&serverName=%@&extension=%@",
                      [M185UserManager currentUser].userID,
                      (config.productID ?: @""),
                      (config.productName ?: @""),
                      (config.productDesc ?: @""),
                      (config.amount ? [NSString stringWithFormat:@"%ld",config.amount.integerValue * 100] : @""),
                      (config.roleID ?: @""),
                      (config.roleName ?: @""),
                      (config.roleLevel ?: @""),
                      (config.serverID ?: @""),
                      (config.serverName ?: @""),
                      (config.extension ?: @"")];
    
    if (config.notifyUrl && config.notifyUrl.length > 0) {
        sign = [sign stringByAppendingString:[NSString stringWithFormat:@"&notifyUrl=%@", config.notifyUrl]];
    }
    

    
    sign = [sign stringByAppendingString:M185SDK.RH_appKey];
    
    NSString *outString = [sign stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)outString, NULL, (CFStringRef)@"!'();:@&=$,/?%#[]",kCFStringEncodingUTF8);
    outString = [NSString stringWithString:(__bridge NSString *)escaped];
    CFRelease(escaped);
    

    [dict setObject:CU7X000(outString) forKey:@"sign"];
    
    Start_network;
    m185_PayStart = YES;
    postRequest(dict, [NSString stringWithFormat:@"%@/pay/getOrderID",M185SDK.urlString], ^(id success, NSDictionary *content) {
        Stop_network;
        m185_PayStart = NO;
        if (content) {
            NSString *state = content[@"state"];
            if (state.integerValue == 1) {
                NSString *orderID = content[@"data"][@"orderID"] ? [NSString stringWithFormat:@"%@",content[@"data"][@"orderID"]] : @"";
                NSString *m185_extension = content[@"data"][@"extension"] ? [NSString stringWithFormat:@"%@",content[@"data"][@"extension"]] : @"";
                config.orderID = orderID;
                config.M185SDK_extension = m185_extension;
                [M185PayManager payStartWithConfig:config];
            } else {
                if ([M185SDK.delegate respondsToSelector:@selector(BTWanRSDKPayResultWithStatus:Information:)]) {
                    [M185SDK.delegate BTWanRSDKPayResultWithStatus:(CODE_PAY_FAIL) Information:@{@"msg":@"支付失败",@"code":content[@"state"]}];
                }
            }
        }
    }, ^(id failure, NSDictionary *content) {
        Stop_network;
        m185_PayStart = NO;
        M185Message(@"系统维护中");
        if ([M185SDK.delegate respondsToSelector:@selector(BTWanRSDKPayResultWithStatus:Information:)]) {
            [M185SDK.delegate BTWanRSDKPayResultWithStatus:(CODE_PAY_UNKNOWN) Information:@{@"msg":@"系统维护中"}];
        }
        if (content) {
            syLog(@"支付失败 == %@",content);
        }
    }, ^(id warning, NSDictionary *content) {
        if (content) {
            syLog(@"warning == %@",content);
        }
    });
}


+ (NSString *)macAddress {
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char *)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return outstring;
}

+ (NSString *) uniqueIdentifier {
    UIDevice* device = [UIDevice currentDevice];
    NSString* json = nil;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        json = [NSString stringWithFormat:@"{\"idfv\":\"%@\",\"idfa\":\"%@\",\"model\":\"%@\"}",
                [[device identifierForVendor] UUIDString],
                [M185CustomServersManager uniqueAdvertisingIdentifier],
                [device model]];
    } else {
        json = [NSString stringWithFormat:@"{\"mac\":\"%@\",\"model\":\"%@\"}",
                [M185CustomServersManager macAddress],
                [device model]];
    }
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSString* base64 = [data base64EncodedStringWithOptions:kNilOptions];
    return [NSString stringWithFormat:@"ios-%@", base64];
}

+ (NSString *)uniqueAdvertisingIdentifier {
    NSUUID *adverSUUID = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    NSString *uuidString = @"0";
    if (adverSUUID) {
        uuidString = [adverSUUID UUIDString];
    }
    return uuidString;
}

+ (NSString *)notifyUrl {
    return @"";
}


@end





