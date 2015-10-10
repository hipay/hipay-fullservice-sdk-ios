//
//  HPTTransaction.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPTTransactionRelatedItem.h"
#import "HPTOrder.h"
#import "HPTThreeDSecure.h"
#import "HPTFraudScreening.h"
#import "HPTPaymentMethod.h"

typedef NS_ENUM(char, HPTAVSResult) {
    
    HPTAVSResultNotApplicable = ' ',
    HPTAVSResultExactMatch = 'Y',
    HPTAVSResultAddressMatch = 'A',
    HPTAVSResultPostalCodeMatch = 'P',
    HPTAVSResultNoMatch = 'N',
    HPTAVSResultNotCompatible = 'C',
    HPTAVSResultNotAllowed = 'E',
    HPTAVSResultUnavailable = 'U',
    HPTAVSResultRetry = 'R',
    HPTAVSResultNotSupported = 'S',
    
};

typedef NS_ENUM(NSInteger, HPTECI) {
    
    HPTMOTO = 1,
    HPTRecurringMOTO = 2,
    HPTInstallmentPayment = 3,
    HPTManuallyKeyedCardPresent = 4,
    HPTSecureECommerce = 7,
    HPTRecurringECommerce = 9,
    
};

typedef NS_ENUM(char, HPTCVCResult) {

    HPTCVCResultNotApplicable = ' ',
    HPTCVCResultMatch = 'M',
    HPTCVCResultNoMatch = 'N',
    HPTCVCResultNotProcessed = 'P',
    HPTCVCResultMissing = 'S',
    HPTCVCResultNotSupported = 'U',
    
};

typedef NS_ENUM(NSInteger, HPTTransactionState) {
    
    HPTTransactionStateCompleted,
    HPTTransactionStateForwarding,
    HPTTransactionStatePending,
    HPTTransactionStateDeclined,
    HPTTransactionStateError,
    
};


@interface HPTTransaction : HPTTransactionRelatedItem

@property (nonatomic, readonly) HPTTransactionState state;
@property (nonatomic, readonly) NSString *reason;
@property (nonatomic, readonly) NSURL *forwardUrl;
@property (nonatomic, readonly) NSString *attemptId;
@property (nonatomic, readonly) NSString *referenceToPay;
@property (nonatomic, readonly) NSString *ipAddress;
@property (nonatomic, readonly) NSString *ipCountry;
@property (nonatomic, readonly) NSString *deviceId;
@property (nonatomic, readonly) HPTAVSResult avsResult;
@property (nonatomic, readonly) HPTCVCResult cvcResult;
@property (nonatomic, readonly) HPTECI eci;
@property (nonatomic, readonly) NSString *paymentProduct;
@property (nonatomic, readonly) HPTPaymentMethod *paymentMethod;
@property (nonatomic, readonly) HPTThreeDSecure *threeDSecure;
@property (nonatomic, readonly) HPTFraudScreening *fraudScreening;
@property (nonatomic, readonly) HPTOrder *order;
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

@end
