//
//  FFNetWorkManager.m
//  M185SDK
//
//  Created by 燚 on 2018/7/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "M185NetWorkManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "M185SDKManager.h"

NSURL * cheackUrl(id url);
NSData * encodeParam(id param , NSStringEncoding encodeing);
NSString *md5String(NSString * input);

int postRequest(id param, id url, NetWorkSuccessBlock success, NetWorkFailureBlock failure, NetWorkWarningBlock warning) {
    NSURL *safeUrl = cheackUrl(url);
    if (!safeUrl) {
        if (failure) {
            failure(nil,@{@"msg":@"error : url error"});
        }
        return 0;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:safeUrl];
    NSData *cheackParam = encodeParam(param,NSUTF8StringEncoding);
    if (cheackParam) {
        [request setHTTPBody:cheackParam];
    } else {
        if (warning) {
            warning(nil,@{@"msg":@"warning : parameter is null or parameter type error"});
        }
    }
    request.timeoutInterval = 15.f;
    [request setHTTPMethod:@"POST"];

    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSError * fail = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&fail];
            if (fail) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure(nil,@{@"msg":fail.localizedDescription});
                    }
                });
            } else {
                if (obj && [obj isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(nil,obj);
                        }
                    });
                } else if (obj) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            success(nil,@{@"data":obj});
                        }
                    });
                } else {
                    if (failure) {
                        failure(nil,@{@"msg":@"error : call back data not exist."});
                    }
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(nil,@{@"msg":error.localizedDescription});
                }
            });
        }
    }];
    [task resume];

    return 1;
}


/** 检测 URL */
NSURL * cheackUrl(id url) {
    if (!url) {
        return nil;
    }
    NSURL *result;
    if ([url isKindOfClass:[NSString class]]) {
        result = [NSURL URLWithString:url];
    }
    if ([url isKindOfClass:[NSURL class]]) {
        result = url;
    }
    if ([url isKindOfClass:[NSDictionary class]]) {
        id urlString = [url objectForKey:@"url"];
        result = cheackUrl(urlString);
    }

    NSString *urlString = result.absoluteString;
    if ([urlString hasPrefix:@"http"]) {
        return result;
    } else {
        return nil;
    }

    return result;
}

NSData * encodeParam(id param , NSStringEncoding encoding) {
    if ([param isKindOfClass:[NSData class]]) {
        return param;
    }
    NSData *result;
    if ([param isKindOfClass:[NSString class]]) {

        result = [param dataUsingEncoding:encoding];

    } else if ([param isKindOfClass:[NSDictionary class]]) {

        NSDictionary *dict = (NSDictionary *)param;
        if (dict && dict.count) {
            NSArray *arrKey = [dict allKeys];
            NSMutableArray *pValues = [NSMutableArray array];

            for (id key in arrKey) {
                id obj = dict[key];

                if ([obj isKindOfClass:[NSString class]]) {

                } else if ([obj isKindOfClass:[NSDictionary class]] ||
                           [obj isKindOfClass:[NSArray class]] ||
                           [obj isKindOfClass:[NSData class]] ||
                           [obj isKindOfClass:[NSSet class]]) {
                    NSError* err = nil;
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:obj options:kNilOptions error:&err];
                    obj = err ? @"" : [[NSString alloc] initWithData:jsonData encoding:encoding];
                } else {
                    obj = [obj description];
                }
                [pValues addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
            }

            NSString *strP = [pValues componentsJoinedByString:@"&"];
            result = [strP dataUsingEncoding:encoding];
        } else {
            result = nil;
        }

    }


    return result;
}




NSString *md5String(NSString * input) {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        //注意：这边如果是x则输出32位小写加密字符串，如果是X则输出32位大写字符串
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

NSString *sign(NSDictionary *params, NSArray *keys) {
    NSMutableString *signString = [NSMutableString string];
    [keys enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [signString appendString:obj];
        [signString appendString:@"="];
        if (params[obj] == nil) {
            return ;
        }
        [signString appendString:params[obj]];
//        if (idx < keys.count - 1) {
//            [signString appendString:@"&"];
//        }
    }];
    NSString *key = [M185SDKManager sharedManager].RH_appKey;
    [signString appendString:key];
    return md5String(signString);
}



@implementation FFNetWorkManager 


+ (void)postRequestWithUrl:(id)url
                     Param:(id)param
              SuccessBlock:(NetWorkSuccessBlock)success
              FailureBlock:(NetWorkFailureBlock)failure
              WarningBlock:(NetWorkWarningBlock)warning {

    NSString *interesting = [NSString stringWithFormat:@"url"];

    [interesting stringByAppendingString:@"2"];

}

/** 签名 */
- (NSString *)signWithParms:(NSDictionary *)params WithKeys:(NSArray *)keys {

    return nil;
}


- (NSString *)md5:(NSString *)input {

    return  nil;
}






@end













