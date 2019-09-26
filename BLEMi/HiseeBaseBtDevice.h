//
//  HiseeBaseBtDevice.h
//  paxz
//
//  Created by 海星通 on 2016/12/15.
//  Copyright © 2016年 海星通. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HiseeBtHead;
@class HiseeBtError;

@interface HiseeBaseBtDevice : NSObject

#pragma mark 初始化
- (instancetype)initWithData:(NSData*)data;

@property (nonatomic, copy) NSString* deviceName;
@property (nonatomic, assign) int* dataArray;
@property (nonatomic, strong) HiseeBtHead* head;
@property (nonatomic, strong) HiseeBtError* error;

@end


@interface HiseeBtHead : NSObject

@property (nonatomic, assign) int type;

@end


extern int const ERROR_CODE_DISTURB;//错误码-杂讯干扰
extern int const ERROR_CODE_EEPROM; //错误码-压计异常 请联系您的销经
extern int const ERROR_CODE_GASING; //错误码-充气时间过长
extern int const ERROR_CODE_HEART;  //错误码-人体心跳信号太小或压力突
extern int const ERROR_CODE_POWER;  //错误码-电池电量不足
extern int const ERROR_CODE_REVISE; //错误码-校正异常
extern int const ERROR_CODE_TEST;   //错误码-测得结果异常

@interface HiseeBtError : NSObject

@property (nonatomic, assign) int code;

@end
