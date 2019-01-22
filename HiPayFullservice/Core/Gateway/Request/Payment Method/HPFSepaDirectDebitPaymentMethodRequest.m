//
//  HPFSepaDirectDebitPaymentMethodRequest.m
//  HiPayFullservice.common
//
//  Created by Morgan BAUMARD on 21/12/2018.
//

#import "HPFSepaDirectDebitPaymentMethodRequest.h"

@implementation HPFSepaDirectDebitPaymentMethodRequest

+ (instancetype)sepaDirectDebitPaymentMethodRequestWithfirstname:(NSString *)firstname
                                                        lastname:(NSString *)lastname
                                                            iban:(NSString *)iban
                                                recurringPayment:(NSInteger)recurringPayment
{
    HPFSepaDirectDebitPaymentMethodRequest *result = [[HPFSepaDirectDebitPaymentMethodRequest alloc] init];
    result.firstname = firstname;
    result.lastname = lastname;
    result.iban = iban;
    result.recurringPayment = recurringPayment;
    
    return result;
}

@end
