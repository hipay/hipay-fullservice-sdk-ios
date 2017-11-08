//
//  HPFPosManager.h
//  HiPayFullservice
//
//  Created by Nicolas FILLION on 08/11/2017.
//

#import <Foundation/Foundation.h>
#import "DatecsLibrary/PPadSDK.h"

@interface HPFPosManager : NSObject <PPadCustomDelegate>

extern NSString * const HPFPOSStateChangeNotification;
extern NSString * const HPFPOSBarCodeNotification;

extern NSString * const HPFPOSConnectionStateKey;

extern NSString * const HPFPOSBarCodeKey;
extern NSString * const HPFPOSBarCodeTypeKey;

+ (instancetype _Nonnull)sharedManager;

- (void)connect;
- (void)disconnect;
- (void)wakeUp;
- (void)connectionState;

@end
