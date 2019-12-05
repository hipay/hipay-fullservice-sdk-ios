//
// Created by HiPay on 27/10/2016.
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
+ (void) save:(HPFPaymentCardToken *)paymentCardToken forCurrency:(NSString *)currency withTouchID:(BOOL)touchID;
+ (NSUInteger) numberOfCardSavedInLast24HoursForCurrency:(NSString *)currency;
+ (NSDate *) enrollmentDateForToken:(NSString *)token forCurrency:(NSString *)currency;

@end
