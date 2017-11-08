//
//  HPFPosManager.m
//  HiPayFullservice
//
//  Created by Nicolas FILLION on 08/11/2017.
//

#import "HPFPosManager.h"

@interface HPFPosManager ()
{
    PPadCustom *ppad;
}

@end

@implementation HPFPosManager

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

- (void)connectionState
{
    [ppad connstate];
}

#pragma mark - mPOS delegate methods

- (void)barcodeData:(NSString *)barcode type:(int)type
{
    NSLog(@"barcode data: %@\nBarcode type %d", barcode, type);

    //NSString *barcodeText = [NSString stringWithFormat:@"Barcode type: %@\nBar code data: %@", [ppad barcodeType2Text:type], barcode];

    NSDictionary *userInfo = @{
                    HPFPOSBarCodeKey: barcode,
                    HPFPOSBarCodeTypeKey: [ppad barcodeType2Text:type]};

    [[NSNotificationCenter defaultCenter] postNotificationName:HPFPOSBarCodeNotification object:nil userInfo:userInfo];

    //[[[UIAlertView alloc] initWithTitle:@"New barcode read" message:barcodeText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (void)ppadConnectionState:(int)state {

    NSDictionary *userInfo = @{HPFPOSConnectionStateKey: @(state)};

    [[NSNotificationCenter defaultCenter] postNotificationName:HPFPOSStateChangeNotification object:nil userInfo:userInfo];

    switch (state) {
        case CONN_DISCONNECTED:
            NSLog(@"Accessory Disconnected");
            break;
        case CONN_CONNECTING:
            NSLog(@"Waiting for Accessory");
            [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
            break;
        case CONN_CONNECTED:
            [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
            NSLog(@"Accessory Connected");
            break;
    }
}

@end
