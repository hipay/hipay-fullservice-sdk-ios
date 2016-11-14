//
// Created by Nicolas FILLION on 27/10/2016.
//

#import <Foundation/Foundation.h>

@class HPFPaymentCardToken;

@interface HPFPaymentCardTokenDatabase : NSObject {

}

+ (NSMutableArray *) paymentCardTokens;
+ (BOOL) clearPaymentCardTokens;
+ (void) save:(HPFPaymentCardToken *)paymentCardToken;
+ (void) delete:(HPFPaymentCardToken *)paymentCardToken;

@end
