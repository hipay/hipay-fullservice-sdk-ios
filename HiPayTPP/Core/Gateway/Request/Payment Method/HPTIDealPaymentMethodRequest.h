//
//  HPTIDealPaymentMethodRequest.h
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import <HiPayTPP/HiPayTPP.h>

@interface HPTIDealPaymentMethodRequest : HPTAbstractPaymentMethodRequest

@property (nonatomic, copy) NSString *issuerBankId;

+ (instancetype)iDealPaymentMethodRequestWithIssuerBankId:(NSString *)issuerBankId;

@end
