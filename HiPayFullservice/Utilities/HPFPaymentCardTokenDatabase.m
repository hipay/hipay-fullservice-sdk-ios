//
// Created by Nicolas FILLION on 27/10/2016.
//

#import "HPFPaymentCardTokenDatabase.h"
#import "FXKeychain.h"
#import "HPFPaymentCardToken.h"

@implementation HPFPaymentCardTokenDatabase

+ (BOOL) clearPaymentCardTokens {

    FXKeychain *fxKeychain = [FXKeychain defaultKeychain];
    return [fxKeychain removeObjectForKey:@"paymentCardToken"];
}

+ (NSArray *) paymentCardTokens {

    FXKeychain *fxKeychain = [FXKeychain defaultKeychain];

    NSArray *tokens = [fxKeychain objectForKey:@"paymentCardToken"];
    if (tokens != nil && tokens.count > 0) {
        return tokens;
    }

    return nil;
}

+ (void) save:(HPFPaymentCardToken *)paymentCardToken {

    FXKeychain *fxKeychain = [FXKeychain defaultKeychain];

    NSArray *tokens = [self paymentCardTokens];

    BOOL alreadyThere = NO;
    for (HPFPaymentCardToken *cardToken in tokens) {

        if ([cardToken isEqualToPaymentCardToken:paymentCardToken]) {
            alreadyThere = YES;
        }
    }

    if (alreadyThere == NO) {

        if (tokens != nil && tokens.count > 0) {
            [fxKeychain setObject:[tokens arrayByAddingObject:paymentCardToken] forKey:@"paymentCardToken"];

        } else {
            [fxKeychain setObject:[NSArray arrayWithObject:paymentCardToken] forKey:@"paymentCardToken"];
        }
    }
}

+ (void) delete:(HPFPaymentCardToken *)paymentCardToken {

    int index = -1;
    NSArray *tokens = [self paymentCardTokens];
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
            [fxKeychain setObject:[NSArray arrayWithArray:mutableTokens] forKey:@"paymentCardToken"];
        }
    }
}

@end
