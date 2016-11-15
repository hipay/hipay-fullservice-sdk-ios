//
// Created by Nicolas FILLION on 27/10/2016.
//

#import "HPFPaymentCardTokenDatabase.h"
#import "FXKeychain.h"
#import "HPFPaymentCardToken.h"

@implementation HPFPaymentCardTokenDatabase

+ (BOOL) clearPaymentCardTokensForCurrency:(NSString *)currency {

    FXKeychain *fxKeychain = [FXKeychain defaultKeychain];
    NSString *key = [NSString stringWithFormat:@"paymentCardToken_%@", currency];
    return [fxKeychain removeObjectForKey:key];
}

+ (NSArray *) paymentCardTokensForCurrency:(NSString *)currency {

    FXKeychain *fxKeychain = [FXKeychain defaultKeychain];

    NSString *key = [NSString stringWithFormat:@"paymentCardToken_%@", currency];
    NSArray *tokens = [fxKeychain objectForKey:key];
    if (tokens != nil && tokens.count > 0) {
        return tokens;
    }

    return nil;
}

+ (void) save:(HPFPaymentCardToken *)paymentCardToken forCurrency:(NSString *)currency {

    FXKeychain *fxKeychain = [FXKeychain defaultKeychain];

    NSArray *tokens = [self paymentCardTokensForCurrency:currency];

    BOOL alreadyThere = NO;
    for (HPFPaymentCardToken *cardToken in tokens) {

        if ([cardToken isEqualToPaymentCardToken:paymentCardToken]) {
            alreadyThere = YES;
        }
    }

    if (alreadyThere == NO) {

        NSString *key = [NSString stringWithFormat:@"paymentCardToken_%@", currency];
        if (tokens != nil && tokens.count > 0) {
            [fxKeychain setObject:[tokens arrayByAddingObject:paymentCardToken] forKey:key];

        } else {
            [fxKeychain setObject:[NSArray arrayWithObject:paymentCardToken] forKey:key];
        }
    }
}

+ (void) delete:(HPFPaymentCardToken *)paymentCardToken forCurrency:(NSString *)currency {

    int index = -1;
    NSArray *tokens = [self paymentCardTokensForCurrency:currency];
    if (tokens != nil) {

        for (int i = 0; i < tokens.count; ++i) {

            if ([tokens[i] isEqualToPaymentCardToken:paymentCardToken]) {
                index = i;
            }
        }

        if (index != -1) {

            NSMutableArray *mutableTokens = [tokens mutableCopy];
            [mutableTokens removeObjectAtIndex:index];

            FXKeychain *fxKeychain = [FXKeychain defaultKeychain];
            NSString *key = [NSString stringWithFormat:@"paymentCardToken_%@", currency];
            [fxKeychain setObject:[NSArray arrayWithArray:mutableTokens] forKey:key];
        }
    }
}

@end
