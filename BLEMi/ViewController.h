//
//  ViewController.h
//  BLEMi
//
//  Created by jinkeke@techshino.com on 16/3/9.
//  Copyright © 2016年 www.techshino.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreBluetooth/CoreBluetooth.h>

#define kMI_STEP @"FF06"
#define kMI_BUTERY @"FF0C"
#define kMI_SHAKE @"2A06"
#define kMI_DEVICE @"FF01"

@interface ViewController : UIViewController<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager *theManager;
    CBPeripheral *thePerpher;
    CBCharacteristic *theSakeCC;
}



@end

