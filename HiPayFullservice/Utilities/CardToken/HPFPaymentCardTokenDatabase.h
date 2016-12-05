//
// Created by Nicolas FILLION on 27/10/2016.
//

#import <Foundation/Foundation.h>

@class HPFPaymentCardToken;

@interface HPFPaymentCardTokenDatabase : NSObject {
}

+ (NSArray *) paymentCardTokensForCurrency:(NSString *)currency;
+ (NSArray *) paymentCardTokensTouchIDForCurrency:(NSString *)currency;
+ (void) clearPaymentCardTokens;
+ (void) delete:(HPFPaymentCardToken *)paymentCardToken forCurrency:(NSString *)currency;
+ (BOOL) isKeychainActive;

@end
