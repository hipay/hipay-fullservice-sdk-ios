//
// Created by Nicolas FILLION on 27/10/2016.
//

#import <Foundation/Foundation.h>

@interface HPFPaymentCardTokenDatabase : NSObject {

}

+ (NSMutableArray *)loadPaymentCardTokenDocs;
+ (NSString *)nextPaymentCardTokenDocPath;
+ (NSMutableArray *) paymentCardTokens;

@end
