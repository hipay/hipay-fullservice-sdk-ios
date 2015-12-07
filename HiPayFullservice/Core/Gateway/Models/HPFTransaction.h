//
//  HPFTransaction.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFTransactionRelatedItem.h"
#import "HPFOrder.h"
#import "HPFThreeDSecure.h"
#import "HPFFraudScreening.h"
#import "HPFPaymentMethod.h"

typedef NS_ENUM(char, HPFAVSResult) {
    
    HPFAVSResultNotApplicable = ' ',
    HPFAVSResultExactMatch = 'Y',
    HPFAVSResultAddressMatch = 'A',
    HPFAVSResultPostalCodeMatch = 'P',
    HPFAVSResultNoMatch = 'N',
    HPFAVSResultNotCompatible = 'C',
    HPFAVSResultNotAllowed = 'E',
    HPFAVSResultUnavailable = 'U',
    HPFAVSResultRetry = 'R',
    HPFAVSResultNotSupported = 'S',
    
};

typedef NS_ENUM(NSInteger, HPFECI) {
    
    HPFECIUndefined = NSIntegerMax,
    HPFECIMOTO = 1,
    HPFECIRecurringMOTO = 2,
    HPFECIInstallmentPayment = 3,
    HPFECIManuallyKeyedCardPresent = 4,
    HPFECISecureECommerce = 7,
    HPFECIRecurringECommerce = 9,
    
};

typedef NS_ENUM(char, HPFCVCResult) {

    HPFCVCResultNotApplicable = ' ',
    HPFCVCResultMatch = 'M',
    HPFCVCResultNoMatch = 'N',
    HPFCVCResultNotProcessed = 'P',
    HPFCVCResultMissing = 'S',
    HPFCVCResultNotSupported = 'U',
    
};

typedef NS_ENUM(NSInteger, HPFTransactionState) {
    
    HPFTransactionStateError,
    HPFTransactionStateCompleted,
    HPFTransactionStateForwarding,
    HPFTransactionStatePending,
    HPFTransactionStateDeclined,
    
};

@interface HPFTransaction : HPFTransactionRelatedItem

@property (nonatomic, readonly) HPFTransactionState state;
@property (nonatomic, readonly, nullable) NSString *reason;
@property (nonatomic, readonly, nullable) NSURL *forwardUrl;
@property (nonatomic, readonly, nullable) NSString *attemptId;
@property (nonatomic, readonly, nullable) NSString *referenceToPay;
@property (nonatomic, readonly, nullable) NSString *ipAddress;
@property (nonatomic, readonly, nullable) NSString *ipCountry;
@property (nonatomic, readonly, nullable) NSString *deviceId;
@property (nonatomic, readonly) HPFAVSResult avsResult;
@property (nonatomic, readonly) HPFCVCResult cvcResult;
@property (nonatomic, readonly) HPFECI eci;
@property (nonatomic, readonly, nonnull) NSString *paymentProduct;
@property (nonatomic, readonly, nullable) HPFPaymentMethod *paymentMethod;
@property (nonatomic, readonly, nullable) HPFThreeDSecure *threeDSecure;
@property (nonatomic, readonly, nullable) HPFFraudScreening *fraudScreening;
@property (nonatomic, readonly, nonnull) HPFOrder *order;
@property (nonatomic, readonly, nullable) NSDictionary *debitAgreement;

@property (nonatomic, readonly, nullable) NSString *cdata1;
@property (nonatomic, readonly, nullable) NSString *cdata2;
@property (nonatomic, readonly, nullable) NSString *cdata3;
@property (nonatomic, readonly, nullable) NSString *cdata4;
@property (nonatomic, readonly, nullable) NSString *cdata5;
@property (nonatomic, readonly, nullable) NSString *cdata6;
@property (nonatomic, readonly, nullable) NSString *cdata7;
@property (nonatomic, readonly, nullable) NSString *cdata8;
@property (nonatomic, readonly, nullable) NSString *cdata9;
@property (nonatomic, readonly, nullable) NSString *cdata10;

@property (readonly, getter=isHandled) BOOL handled;

+ (NSArray<HPFTransaction *> * _Nonnull)sortTransactionsByRelevance:(NSArray<HPFTransaction *> * _Nonnull)transactions;

- (BOOL)isMoreRelevantThan:(HPFTransaction * _Nonnull)transaction;

@end
