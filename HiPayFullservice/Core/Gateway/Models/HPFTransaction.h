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
@property (nonatomic, readonly) NSString *reason;
@property (nonatomic, readonly) NSURL *forwardUrl;
@property (nonatomic, readonly) NSString *attemptId;
@property (nonatomic, readonly) NSString *referenceToPay;
@property (nonatomic, readonly) NSString *ipAddress;
@property (nonatomic, readonly) NSString *ipCountry;
@property (nonatomic, readonly) NSString *deviceId;
@property (nonatomic, readonly) HPFAVSResult avsResult;
@property (nonatomic, readonly) HPFCVCResult cvcResult;
@property (nonatomic, readonly) HPFECI eci;
@property (nonatomic, readonly) NSString *paymentProduct;
@property (nonatomic, readonly) HPFPaymentMethod *paymentMethod;
@property (nonatomic, readonly) HPFThreeDSecure *threeDSecure;
@property (nonatomic, readonly) HPFFraudScreening *fraudScreening;
@property (nonatomic, readonly) HPFOrder *order;
@property (nonatomic, readonly) NSDictionary *debitAgreement;

@property (nonatomic, readonly) NSString *cdata1;
@property (nonatomic, readonly) NSString *cdata2;
@property (nonatomic, readonly) NSString *cdata3;
@property (nonatomic, readonly) NSString *cdata4;
@property (nonatomic, readonly) NSString *cdata5;
@property (nonatomic, readonly) NSString *cdata6;
@property (nonatomic, readonly) NSString *cdata7;
@property (nonatomic, readonly) NSString *cdata8;
@property (nonatomic, readonly) NSString *cdata9;
@property (nonatomic, readonly) NSString *cdata10;

@property (readonly, getter=isHandled) BOOL handled;

+ (NSArray<HPFTransaction *> *)sortTransactionsByRelevance:(NSArray<HPFTransaction *> *)transactions;

- (BOOL)isMoreRelevantThan:(HPFTransaction *)transaction;

@end
