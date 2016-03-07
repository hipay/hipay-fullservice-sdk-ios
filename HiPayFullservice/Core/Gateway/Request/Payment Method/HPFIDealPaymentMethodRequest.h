//
//  HPFIDealPaymentMethodRequest.h
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import "HPFAbstractPaymentMethodRequest.h"

/**
 *  Describes iDeal information to be sent alongside an order request.
 */
@interface HPFIDealPaymentMethodRequest : HPFAbstractPaymentMethodRequest

/**
 *  The issuer bank ID. Check out issuerBanks for more information.
 *
 *  @see issuerBanks
 */
@property (nonatomic, copy) NSString *issuerBankId;

+ (instancetype)iDealPaymentMethodRequestWithIssuerBankId:(NSString *)issuerBankId;

+ (NSDictionary *)issuerBanks;

@end
