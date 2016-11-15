//
// Created by Nicolas FILLION on 27/10/2016.
//

#import <Foundation/Foundation.h>

@class HPFPaymentCardToken;

@interface HPFPaymentCardTokenDatabase : NSObject {

}

+ (NSArray *) paymentCardTokensForCurrency:(NSString *)currency;
+ (BOOL) clearPaymentCardTokensForCurrency:(NSString *)currency;
+ (void) save:(HPFPaymentCardToken *)paymentCardToken forCurrency:(NSString *)currency;
+ (void) delete:(HPFPaymentCardToken *)paymentCardToken forCurrency:(NSString *)currency;

@end
