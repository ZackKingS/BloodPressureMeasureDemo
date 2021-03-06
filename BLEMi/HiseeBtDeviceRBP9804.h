//
//  HiseeBtDeviceRBP9804.h
//  脉搏波RBP9804蓝牙设备信息
//
//  Created by 海星通 on 2016/12/15.
//  Copyright © 2016年 海星通. All rights reserved.
//

#import "HiseeBaseBtDevice.h"

extern NSString* const BT_RBP9804_DEVICE_SIGN;

extern NSString* const BT_RBP9804_DEVICE_SERVICE_UUID;
extern NSString* const BT_RBP9804_DEVICE_NOTIFY_UUID;
extern NSString* const BT_RBP9804_DEVICE_WRITE_UUID;

extern int const BT_RBP9804_SIGN_XY;//脉搏波-获取血压
extern int const BT_RBP9804_SIGN_RESULT;//脉搏波-获取结果
extern int const BT_RBP9804_SIGN_ERROR;//脉搏波-获取错误

extern int BT_RBP9804_ORDER_READY[8];//蓝牙指令-准备
extern int BT_RBP9804_ORDER_QUERYELECTRICITY[8];
extern int BT_RBP9804_ORDER_BEGINMEASURE[8];//蓝牙指令-开始测量

@interface HiseeBtDeviceRBP9804 : HiseeBaseBtDevice

@property (nonatomic, assign) int pressure;

@property (nonatomic, assign) int ssyResult;
@property (nonatomic, assign) int szyResult;
@property (nonatomic, assign) int xlResult;


@end
