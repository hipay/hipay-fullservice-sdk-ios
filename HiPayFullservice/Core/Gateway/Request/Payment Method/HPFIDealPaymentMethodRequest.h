//
//  HPFIDealPaymentMethodRequest.h
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import <HiPayFullservice/HiPayFullservice.h>

@interface HPFIDealPaymentMethodRequest : HPFAbstractPaymentMethodRequest

@property (nonatomic, copy) NSString *issuerBankId;

+ (instancetype)iDealPaymentMethodRequestWithIssuerBankId:(NSString *)issuerBankId;

+ (NSDictionary *)issuerBanks;

@end
