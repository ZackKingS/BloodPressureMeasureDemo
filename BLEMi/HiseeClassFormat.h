//
//  HiseeClassFormat.h
//  类型转化工具类
//
//  Created by 海星通 on 16/7/5.
//  Copyright © 2016年 hisee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HiseeClassFormat : NSObject

#pragma mark 根据集合获取字符串
+ (NSString*)obtainStrByArray:(NSArray*)array split:(NSString*)split;

#pragma mark 字符串转整型
+ (int)strToInt:(NSString*)str;

#pragma mark 从url中获取参数
+ (NSDictionary*)obtainDictByUrl:(NSString*)urlStr;
#pragma mark 从url中获取url地址
+ (NSString*)obtainUrlByUrl:(NSString*)urlStr;

#pragma mark 版本名称中获取版本数组
+ (NSArray*)obtainVersionArray:(NSString*)versionName;

#pragma mark 隐藏身份证字符串
+ (NSString*)showPartIdCard:(NSString*)idCard;
#pragma mark 隐藏手机号字符串
+ (NSString*)showPartMobilePhone:(NSString*)mobilePhone;

#pragma mark 对象转json字符串
+ (NSString*)objToJsonStr:(id)obj;





#pragma mark int数组转nsdata
+ (NSData*)intArrayToData:(int[])intArray length:(int)length;
#pragma mark nsdata转int数组
+ (int*)dataToIntArray:(NSData*)data length:(NSUInteger*)length;

@end
