//
//  HiseeBtDeviceBP88A.m
//  脉搏波BP88A蓝牙设备信息
//
//  Created by 海星通 on 2016/12/15.
//  Copyright © 2016年 海星通. All rights reserved.
//

#import "HiseeBtDeviceBP88A.h"

#pragma mark 工具类
#import "HiseeClassFormat.h"

NSString* const BT_BP88A_DEVICE_SIGN = @"BP";

NSString* const BT_BP88A_DEVICE_SERVICE_UUID = @"FFF0";
NSString* const BT_BP88A_DEVICE_NOTIFY_UUID = @"FFF1";
NSString* const BT_BP88A_DEVICE_WRITE_UUID = @"FFF2";

int const BT_BP88A_SIGN_XY = 5;//脉搏波-获取血压
int const BT_BP88A_SIGN_RESULT = 6;//脉搏波-获取结果
int const BT_BP88A_SIGN_ERROR = 7;//脉搏波-获取错误

int BT_BP88A_ORDER_READY[8] = { 0xCC, 0x80, 0x02, 0x03, 0x01, 0x01, 0x00, 0x01 };
int BT_BP88A_ORDER_QUERYELECTRICITY[8] = { 0xCC, 0x80, 0x02, 0x03, 0x04, 0x01, 0x00, 0x01 };
int BT_BP88A_ORDER_BEGINMEASURE[8] = { 0xCC, 0x80, 0x02, 0x03, 0x01, 0x02, 0x00, 0x02 };//蓝牙指令-开始测量

@implementation HiseeBtDeviceBP88A

#pragma mark 初始化
- (instancetype)initWithData:(NSData*)data
{
    self = [super initWithData:data];
    if (self) {
        
        NSUInteger dataLen = 0;
        self.dataArray = [HiseeClassFormat dataToIntArray:data length:&dataLen];
        if (self.dataArray != NULL) {
            self.head = [[HiseeBtHead alloc] init];
            
            if (dataLen > 5) {
                self.head.type = self.dataArray[5];
            }
            
            
            self.error = [[HiseeBtError alloc] init];
            if (dataLen > 3) {
                self.error.code = self.dataArray[3];
            }
            
            if (dataLen > 10) {
                self.pressure = self.dataArray[10];
            }
            
            if (dataLen > 14) {
                self.ssyResult = self.dataArray[14];
            }
            if (dataLen > 16) {
                self.szyResult = self.dataArray[16];
            }
            if (dataLen > 18) {
                self.xlResult = self.dataArray[18];
            }
        }
    }
    return self;
}

@end
