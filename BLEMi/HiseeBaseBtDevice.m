//
//  HiseeBaseBtDevice.m
//  paxz
//
//  Created by 海星通 on 2016/12/15.
//  Copyright © 2016年 海星通. All rights reserved.
//

#import "HiseeBaseBtDevice.h"

@implementation HiseeBaseBtDevice

#pragma mark 初始化
- (instancetype)initWithData:(NSData*)data
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark 释放内存
- (void)dealloc
{
    if (self.dataArray != NULL) {
        free(self.dataArray);
    }
}

@end








@implementation HiseeBtHead


@end

int const ERROR_CODE_DISTURB = 2;  //错误码-杂讯干扰
int const ERROR_CODE_EEPROM  = 14; //错误码-压计异常 请联系您的销经
int const ERROR_CODE_GASING  = 3;  //错误码-充气时间过长
int const ERROR_CODE_HEART   = 1;  //错误码-人体心跳信号太小或压力突
int const ERROR_CODE_POWER   = 11; //错误码-电池电量不足
int const ERROR_CODE_REVISE  = 12; //错误码-校正异常
int const ERROR_CODE_TEST    = 5;  //错误码-测得结果异常






@implementation HiseeBtError


@end
