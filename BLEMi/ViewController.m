//
//  ViewController.m
//  BLEMi
//
//  Created by jinkeke@techshino.com on 16/3/9.
//  Copyright © 2016年 www.techshino.com. All rights reserved.
//

#import "ViewController.h"
#import "HiseeClassFormat.h"
#import "HiseeBtDeviceBP88A.h"
#import "HiseeBtDeviceRBP9804.h"
//4个字节Bytes 转 int
unsigned int  TCcbytesValueToInt(Byte *bytesValue) {
    unsigned int  intV;
    intV = (unsigned int ) ( ((bytesValue[3] & 0xff)<<24)
                            |((bytesValue[2] & 0xff)<<16)
                            |((bytesValue[1] & 0xff)<<8)
                            |(bytesValue[0] & 0xff));
    return intV;
}

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activeID;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UITextView *resultTextV;
@property (nonatomic, strong) CBCharacteristic* writeDataC;//写数据特征
@property (nonatomic, strong) CBCharacteristic* nofityDataC;//通知数据特征
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    theManager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    self.connectBtn.enabled = NO;
}

//0.当前蓝牙主设备状态
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state==CBCentralManagerStatePoweredOn) {
        self.title = @"0.蓝牙已就绪";
        self.connectBtn.enabled = YES;
    }else
    {
        self.title = @"蓝牙未准备好";
        [self.activeID stopAnimating];
        switch (central.state) {
            case CBCentralManagerStateUnknown:
                NSLog(@">>>CBCentralManagerStateUnknown");
                break;
            case CBCentralManagerStateResetting:
                NSLog(@">>>CBCentralManagerStateResetting");
                break;
            case CBCentralManagerStateUnsupported:
                NSLog(@">>>CBCentralManagerStateUnsupported");
                break;
            case CBCentralManagerStateUnauthorized:
                NSLog(@">>>CBCentralManagerStateUnauthorized");
                break;
            case CBCentralManagerStatePoweredOff:
                NSLog(@">>>CBCentralManagerStatePoweredOff");
                break;
            default:
                break;
        }
    }
}

//1.开始连接action
- (IBAction)startConnectAction:(id)sender {
    
    if (theManager.state==CBCentralManagerStatePoweredOn) {
        NSLog(@"1.主设备蓝牙状态正常，开始扫描外设...");
        self.title = @"扫描小米手环...";
        
        //扫描 Peripherals
        [theManager scanForPeripheralsWithServices:nil options:nil];
        
        //UI
        [self.activeID startAnimating];
        self.connectBtn.enabled = NO;
        self.resultTextV.text = @"";
    }
}

#pragma mark 设备扫描与连接的代理

//2.扫描设备  Peripheral
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"2.扫描连接外设：%@ %@",peripheral.name,RSSI);
    
    
    if ([peripheral.name hasPrefix:@"RBP"]) {
        
        
        //保存 peripheral
        thePerpher = peripheral;
        
        //central 停止扫描
        [central stopScan];
        
        //central 连接 peripheral
        [central connectPeripheral:peripheral options:nil];
        
        
        self.title = @"发现小米手环，开始连接...";
        self.resultTextV.text = [NSString stringWithFormat:@"2.发现手环：%@\n名称：%@\n",peripheral.identifier.UUIDString,peripheral.name];
    }
}

//3.连接到Peripherals-成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    self.title = @"3.连接成功，扫描信息...";
    NSLog(@"3.连接外设成功！%@",peripheral.name);
    
    //peripheral 设置代理
    [peripheral setDelegate:self];
    
    //peripheral 扫描服务
    [peripheral discoverServices:nil];
    NSLog(@"3.开始扫描外设服务 %@...",peripheral.name);
}


//4.扫描到服务 （Service） ,之后扫描特征 （Characteristics）
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error)
    {
        NSLog(@"4.扫描外设服务出错：%@-> %@", peripheral.name, [error localizedDescription]);
        self.title = @"find services error.";
        [self.activeID stopAnimating];
        self.connectBtn.enabled = YES;
        
        return;
    }
    NSLog(@"4.扫描到外设服务：%@ -> %@",peripheral.name,peripheral.services);
    for (CBService *service in peripheral.services) {
        
        //peripheral 扫描外设 service 的 Characteristics
        [peripheral discoverCharacteristics:nil forService:service];
    }
    NSLog(@"4.开始扫描外设服务的特征 %@...",peripheral.name);
}


//5.扫描到了特征 （Characteristics） ,根据 UUID 处理特征（Characteristics）
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"5.扫描外设的特征失败！%@->%@-> %@",peripheral.name,service.UUID, [error localizedDescription]);
        self.title = @"find characteristics error.";
        [self.activeID stopAnimating];
        self.connectBtn.enabled = YES;
        return;
    }
    
    NSLog(@"5.扫描到外设服务特征有：%@->%@->%@",peripheral.name,service.UUID,service.characteristics);
    //获取Characteristic的值
    for (CBCharacteristic *c in service.characteristics){
        NSString* charUUID = [NSString stringWithFormat:@"%@", c.UUID];
        if ([thePerpher.name hasPrefix:@"RBP"]) {
            if ([charUUID isEqualToString:@"FFF1"]) { //通知通道 0x30
                self.nofityDataC = c;
                [peripheral setNotifyValue:YES forCharacteristic:self.nofityDataC];
            }
            if ([charUUID isEqualToString:@"FFF2"]) { //写通道 0xC
                self.writeDataC = c;//ok
            }
            if (self.writeDataC && self.nofityDataC) {
                
                //发送命令 ORDER_READY
                NSData* data = [HiseeClassFormat intArrayToData:BT_RBP9804_ORDER_READY length:8];
                [self writeDataToBt:data];
            }
        }
    }
}


#pragma mark 设备信息处理
//6.设备信息处理
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if (error) {
        NSLog(@"扫描外设的特征失败！%@-> %@",peripheral.name, [error localizedDescription]);
        self.title = @"find value error.";
        return;
    }
    NSUInteger dataLen = 0;
    
    //原始数据
    NSData *data = characteristic.value;
    int* dataArray = [HiseeClassFormat dataToIntArray:data length:&dataLen];
    if (dataArray == NULL) {
        return;
    }
    NSString* dataStr = @"";
    for (int i = 0; i < data.length; i++) {
        NSString* num = [NSString stringWithFormat:@"%d,", dataArray[i]];
        dataStr = [dataStr stringByAppendingString:num];
    }
    NSLog(@"6.接收到蓝牙的数据 = %@", dataStr);
    if ([thePerpher.name hasPrefix:@"RBP"]) { //RBP9804
        
        
        //数据解析
        HiseeBtDeviceBP88A* rbp9804 = [[HiseeBtDeviceBP88A alloc] initWithData:data];
        rbp9804.deviceName = thePerpher.name;
        
        
        if (dataLen > 7 && dataArray[3] == 3 && dataArray[7] == 1) { //首次链接成功
            
            //发送命令 ORDER_BEGINMEASURE
            NSData* sendData = [HiseeClassFormat intArrayToData:BT_RBP9804_ORDER_BEGINMEASURE length:8];
            [self writeDataToBt:sendData];
        }
        
        if (rbp9804.head.type == BT_RBP9804_SIGN_XY) { //收到血压数据

            NSLog(@"pressure---%d",rbp9804.pressure);
            NSLog(@"ssyResult---%d",rbp9804.ssyResult);
            NSLog(@"szyResult---%d",rbp9804.szyResult);
            NSLog(@"xlResult---%d",rbp9804.xlResult);
            
         
            
        } else if (rbp9804.head.type == BT_RBP9804_SIGN_RESULT) { //接收到结果数据

            
            NSLog(@"pressure---%d",rbp9804.pressure);
            NSLog(@"ssyResult---%d",rbp9804.ssyResult);
            NSLog(@"szyResult---%d",rbp9804.szyResult);
            NSLog(@"xlResult---%d",rbp9804.xlResult);
            [self disConnectBt];
        }
        
    }
    
    [self.activeID stopAnimating];
    self.connectBtn.enabled = YES;
    self.title = @"6.信息扫描完成";
}


- (void)writeDataToBt:(NSData*)data
{
    if (thePerpher && self.writeDataC) {
        [thePerpher writeValue:data forCharacteristic:self.writeDataC type:CBCharacteristicWriteWithResponse];
        NSLog(@"向蓝牙写数据 = %@", data);
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"写入错误 = %@, 写入特征uuid = %@", error, characteristic.UUID);
    } else {
        NSLog(@"特征值 = %@, 写入成功", characteristic.UUID);
    }
}


//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接到外设 失败！%@ %@",[peripheral name],[error localizedDescription]);
    [self.activeID stopAnimating];
    self.title = @"连接失败";
    self.connectBtn.enabled = YES;
}

//与外设断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"与外设备断开连接 %@: %@", [peripheral name], [error localizedDescription]);
    self.title = @"连接已断开";
    self.connectBtn.enabled = YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)stopShakeAction:(id)sender {
    
}

//震动
- (IBAction)shakeBankAction:(id)sender {
    
}

//断开连接Action
- (IBAction)disConnectAction:(id)sender {
    if(thePerpher)
    {
        [theManager cancelPeripheralConnection:thePerpher];
        thePerpher = nil;
        theSakeCC = nil;
        self.title = @"设备连接已断开";
    }
}

- (void)disConnectBt
{
    thePerpher = nil;
    self.nofityDataC = nil;
    self.writeDataC = nil;
}


@end
