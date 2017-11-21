//
//  HPFPosManager.m
//  HiPayFullservice
//
//  Created by Nicolas FILLION on 08/11/2017.
//

#import "HPFPOSManager.h"

@interface HPFPOSManager ()
{
    PPadCustom *ppad;
}

@end

@implementation HPFPOSManager

NSString * const HPFPOSStateChangeNotification = @"HPFPOSStateChangeNotification";
NSString * const HPFPOSConnectionStateKey = @"HPFPOSConnectionStateKey";

NSString * const HPFPOSBarCodeNotification = @"HPFPOSBarCodeNotification";
NSString * const HPFPOSBarCodeKey = @"HPFPOSStateBarCodeKey";
NSString * const HPFPOSBarCodeTypeKey = @"HPFPOSStateBarCodeTypeKey";

+ (instancetype)sharedManager
{
    static dispatch_once_t once;
    static id sharedManager;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {

        ppad = [PPadCustom sharedDevice];
        [ppad addDelegate:self];
    }
    return self;
}

#pragma mark - mPOS methods

- (void)connect
{
    [ppad connect];
    [ppad allowConnectMessage];
}

- (void)disconnect
{
    [ppad disconnect];
}

- (void)wakeUp
{
    [ppad kick];
}

- (HPFPOSConnectionState)connectionState
{
    CONN_STATES connState = [ppad connstate];
    switch (connState){
            
        case CONN_DISCONNECTED:
            return HPFPOSConnectionStateDisconnected;
            break;
            
        case CONN_CONNECTING:
            return HPFPOSConnectionStateConnecting;
            break;
            
        case CONN_CONNECTED:
            return HPFPOSConnectionStateConnected;
            break;
    }
}

#pragma mark - mPOS delegate methods

- (void)barcodeData:(NSString *)barcode type:(int)type
{
    NSDictionary *userInfo = @{
                    HPFPOSBarCodeKey: barcode,
                    HPFPOSBarCodeTypeKey: [ppad barcodeType2Text:type]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HPFPOSBarCodeNotification object:nil userInfo:userInfo];
}

- (void)ppadConnectionState:(int)state {

    NSDictionary *userInfo = @{HPFPOSConnectionStateKey: @(state)};

    [[NSNotificationCenter defaultCenter] postNotificationName:HPFPOSStateChangeNotification object:nil userInfo:userInfo];

    switch (state) {
        case HPFPOSConnectionStateDisconnected:
            //NSLog(@"Accessory Disconnected");
            break;
        case HPFPOSConnectionStateConnecting:
            //NSLog(@"Waiting for Accessory");
            [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
            break;
        case HPFPOSConnectionStateConnected:
            [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
            //NSLog(@"Accessory Connected");
            break;
    }
}

@end
