//
//  HPFSepaDirectDebitPaymentMethodRequest.h
//  HiPayFullservice.common
//
//  Created by Morgan BAUMARD on 21/12/2018.
//

#import "HPFAbstractPaymentMethodRequest.h"

@interface HPFSepaDirectDebitPaymentMethodRequest : HPFAbstractPaymentMethodRequest

/**
 *  First name.
 */
@property (nonatomic, copy) NSString *firstname;

/**
 *  Last name.
 */
@property (nonatomic, copy) NSString *lastname;

/**
 * Gender of the customer:
 * M:male
 * F:female
 * U:unknown
 */
@property (nonatomic, copy) NSString *gender;

/**
 *  International Bank Account Number
 */
@property (nonatomic, copy) NSString *iban;

/**
 *  Issuer Bank Name
 */
@property (nonatomic, copy) NSString *bankName;

/**
 *  This is the Business Identifier Code (BIC) of the customer's issuer bank.
 */
@property (nonatomic, copy) NSString *issuerBankId;

/**
 * Indicates if the debit agreement will be created for a single-use or a multi-use.
 * Possible values:
 * 0: Generate a single-use agreement id.
 * 1: Generate a multi-use agreement id.
 */
@property (nonatomic) NSInteger recurringPayment;

/**
 * If this is a recurring payment, this parameter provides the agreement ID (mandate) returned on first transaction.
 */
@property (nonatomic) NSInteger debitAgreementId;

/**
 *  Instantiate a SEPA Direct Debit request, to be sent alongside an order request.
 *
 *  @param firstname        Firstname
 *  @param lastname         Lastname
 *  @param iban             International Bank Account Number
 *  @param recurringPayment Indicates if the debit agreement will be created for a single-use or a multi-use.
 *
 *  @return A new SEPA Direct Debit request.
 */
+ (instancetype _Nonnull)sepaDirectDebitPaymentMethodRequestWithfirstname:(NSString *)firstname
                                                                 lastname:(NSString *)lastname
                                                                     iban:(NSString *)iban
                                                         recurringPayment:(NSInteger)recurringPayment;

@end
