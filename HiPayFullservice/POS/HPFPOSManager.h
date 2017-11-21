//
//  HPFPosManager.h
//  HiPayFullservice
//
//  Created by Nicolas FILLION on 08/11/2017.
//

#import <Foundation/Foundation.h>
#import "DatecsLibrary.h"

typedef NS_ENUM(NSUInteger, HPFPOSConnectionState) {
    
    HPFPOSConnectionStateDisconnected,
    HPFPOSConnectionStateConnecting,
    HPFPOSConnectionStateConnected
};

@interface HPFPOSManager : NSObject <PPadCustomDelegate>

extern NSString * _Nonnull const HPFPOSStateChangeNotification;
extern NSString * _Nonnull const HPFPOSBarCodeNotification;

extern NSString * _Nonnull const HPFPOSConnectionStateKey;

extern NSString * _Nonnull const HPFPOSBarCodeKey;
extern NSString * _Nonnull const HPFPOSBarCodeTypeKey;

+ (instancetype _Nonnull)sharedManager;

- (void)connect;
- (void)disconnect;
- (void)wakeUp;
- (HPFPOSConnectionState)connectionState;

@end
