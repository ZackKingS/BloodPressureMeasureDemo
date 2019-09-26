//
//  HiseeClassFormat.m
//  类型转化工具类
//
//  Created by 海星通 on 16/7/5.
//  Copyright © 2016年 hisee. All rights reserved.
//

#pragma mark 工具类
#import "HiseeClassFormat.h"

@implementation HiseeClassFormat

#pragma mark 根据集合获取字符串
+ (NSString*)obtainStrByArray:(NSArray*)array split:(NSString*)split
{
    if (!array) {
        return @"";
    }
    NSMutableString* ms = [NSMutableString stringWithString:@""];
    for (NSUInteger i = 0; i < array.count; i++) {
        id ele = [array objectAtIndex:i];
        if ([ele isKindOfClass:[NSString class]]) {
            if (i == array.count - 1) { //最后一个元素
                [ms appendString:ele];
            } else {
                [ms appendString:ele];
                if (split) {
                    [ms appendString:split];
                }
            }
        }
    }
    return [NSString stringWithString:ms];
}

#pragma mark 字符串转整型
+ (int)strToInt:(NSString*)str
{
    return [str intValue];
}

#pragma mark 从url中获取参数
+ (NSDictionary*)obtainDictByUrl:(NSString*)urlStr
{
    NSMutableDictionary* mDict = [[NSMutableDictionary alloc] init];
    if (!urlStr) {
        return mDict;
    } else {
        if ([urlStr rangeOfString:@"?"].length > 0) {
            NSArray* urlArray = [urlStr componentsSeparatedByString:@"?"];
            if (urlArray.count == 2) {
                NSString* paramStr = urlArray[1];
                NSArray* paramStrArray = [paramStr componentsSeparatedByString:@"&"];
                for (NSString* str in paramStrArray) {
                    NSArray* strArray = [str componentsSeparatedByString:@"="];
                    if (strArray.count == 2) {
                        NSString* key = strArray[0];
                        NSString* value = strArray[1];
                        [mDict setObject:value forKey:key];
                    }
                }
            }
        }
        return mDict;
    }
}

#pragma mark 从url中获取url地址
+ (NSString*)obtainUrlByUrl:(NSString*)urlStr
{
    if (!urlStr) {
        return nil;
    } else {
        if ([urlStr rangeOfString:@"?"].length > 0) {
            NSArray* urlArray = [urlStr componentsSeparatedByString:@"?"];
            if (urlArray.count == 2) {
                return urlArray[0];
            }
            return urlStr;
        }
        return urlStr;
    }
}



#pragma mark 版本名称中获取版本数组
+ (NSArray*)obtainVersionArray:(NSString*)versionName
{
    if (!versionName) {
        return nil;
    }
    NSInteger versionX = 0;
    NSInteger versionY = 0;
    NSInteger versionZ = 0;
    
    NSArray* strArray = [versionName componentsSeparatedByString:@"."];
    
    if (strArray && strArray.count >= 3) {
        versionX = [strArray[0] integerValue];
        versionY = [strArray[1] integerValue];
        versionZ = [strArray[2] integerValue];
    }
    
    return @[ [NSNumber numberWithInteger:versionX],
              [NSNumber numberWithInteger:versionY],
              [NSNumber numberWithInteger:versionZ] ];
}

#pragma mark 隐藏身份证字符串
+ (NSString*)showPartIdCard:(NSString*)idCard
{
    if (!idCard) {
        return nil;
    }
    if (idCard.length == 15 || idCard.length == 18) {
        NSString* startStr = [idCard substringToIndex:3];
        NSString* endStr = [idCard substringFromIndex:(idCard.length - 2)];
        return [NSString stringWithFormat:@"%@****%@", startStr, endStr];
    }
    return @"******";
}

#pragma mark 隐藏手机号字符串
+ (NSString*)showPartMobilePhone:(NSString*)mobilePhone
{
    if (!mobilePhone) {
        return nil;
    }
    if (mobilePhone.length == 11) {
        NSString* startStr = [mobilePhone substringToIndex:3];
        NSString* endStr = [mobilePhone substringFromIndex:(mobilePhone.length - 4)];
        return [NSString stringWithFormat:@"%@****%@", startStr, endStr];
    }
    return @"****";
}

#pragma mark 对象转json字符串
+ (NSString*)objToJsonStr:(id)obj
{
    if (!obj) {
        return nil;
    }
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString* noLjStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSMutableString *responseString = [NSMutableString stringWithString:noLjStr];
        NSString *character = nil;
        for (int i = 0; i < responseString.length; i ++) {
            character = [responseString substringWithRange:NSMakeRange(i, 1)];
            if ([character isEqualToString:@"\\"]) {
                [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
            }
        }
        return responseString;
    }
    return nil;
}






#pragma mark int数组转nsdata
+ (NSData*)intArrayToData:(int[])intArray length:(int)length
{
    if (intArray == NULL) {
        return nil;
    }
    SignedByte* bytes = (SignedByte*) malloc(length * sizeof(SignedByte));
    for (int i = 0; i < length; i++) {
        bytes[i] = (SignedByte) intArray[i];
    }
    NSData* data = [[NSData alloc] initWithBytes:bytes length:length];
    free(bytes);
    return data;
}

#pragma mark nsdata转int数组
+ (int*)dataToIntArray:(NSData*)data length:(NSUInteger*)length
{
    if (!data) {
        return NULL;
    }
    NSUInteger dataLen = data.length;
    int* dataArray = (int*) malloc(dataLen * sizeof(int));
    SignedByte* bytes = (SignedByte*) data.bytes;
    for (int i = 0; i < dataLen; i++) {
        dataArray[i] = (0xFF & bytes[i]);
    }
    *length = dataLen;
    return dataArray;
}

@end
