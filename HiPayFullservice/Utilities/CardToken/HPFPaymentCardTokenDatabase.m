//
// Created by HiPay on 27/10/2016.
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

+ (NSArray *) paymentCardTokensTouchIDForCurrency:(NSString *)currency {

    FXKeychain *fxKeychain = [FXKeychain defaultKeychain];

    NSString *key = [NSString stringWithFormat:@"paymentCardTokenTouchID_%@", currency];
    NSArray *tokens = [fxKeychain objectForKey:key];
    if (tokens != nil && tokens.count > 0) {
        return tokens;
    }

    return nil;
}

+ (void) clearPaymentCardTokens {

    NSArray *currencyList = [self paymentCardTokensCurrencyList];
    if (currencyList != nil && currencyList.count > 0) {

        for (NSString *currency in currencyList) {
            [self clearPaymentCardTokensForCurrency:currency];
        }
    }
}

+ (BOOL) isKeychainActive {

    FXKeychain *keychain = [FXKeychain defaultKeychain];
    if ([keychain setObject:@"test" forKey:@"com.hipay.test"]) {
        return [keychain removeObjectForKey:@"com.hipay.test"];
    }

    return NO;
}


+ (void) removeCurrencyInList:(NSString *)currency {

    FXKeychain *fxKeychain = [FXKeychain defaultKeychain];
    NSString *key = @"paymentCardTokenCurrencyList";

    NSArray *currencyList = [self paymentCardTokensCurrencyList];
    if (currencyList != nil && currencyList.count > 0) {

        NSMutableArray *mutableList = [currencyList mutableCopy];
        [mutableList removeObject:currency];
        [fxKeychain setObject:[NSArray arrayWithArray:mutableList] forKey:key];
    }
}

+ (void) addCurrencyInList:(NSString *)currency {

    FXKeychain *fxKeychain = [FXKeychain defaultKeychain];
    NSString *key = @"paymentCardTokenCurrencyList";

    NSArray *currencyList = [self paymentCardTokensCurrencyList];
    if (currencyList != nil && currencyList.count > 0) {

        NSMutableArray *mutableList = [currencyList mutableCopy];

        if (![mutableList containsObject:currency]) {

            [mutableList addObject:currency];
            [fxKeychain setObject:[NSArray arrayWithArray:mutableList] forKey:key];
        }

    } else {

        [fxKeychain setObject:[NSArray arrayWithObject:currency] forKey:key];
    }
}

+ (NSArray *) paymentCardTokensCurrencyList {

    FXKeychain *fxKeychain = [FXKeychain defaultKeychain];
    NSArray *tokens = [fxKeychain objectForKey:@"paymentCardTokenCurrencyList"];
    if (tokens != nil && tokens.count > 0) {
        return tokens;
    }

    return nil;
}

+ (NSUInteger) numberOfCardSavedInLast24HoursForCurrency:(NSString *)currency {
    
    NSArray *tokens = [self paymentCardTokensForCurrency:currency];
    NSUInteger count = 0;
    
    if (tokens.count > 0) {
        for (HPFPaymentCardToken *cardToken in tokens) {
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *oneDayBefore = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:[NSDate date] options:0];
            if (cardToken.dateAdded && [cardToken.dateAdded compare:oneDayBefore] == NSOrderedDescending) {
                count++;
            }
        }
    }

    return count;
}

+ (NSDate *) enrollmentDateForToken:(NSString *)token forCurrency:(NSString *)currency {
    NSArray *tokens = [self paymentCardTokensForCurrency:currency];
    
    for (HPFPaymentCardToken *cardToken in tokens) {
        if ([cardToken.token isEqualToString:token]) {
            return cardToken.dateAdded;
        }
    }
    
    return nil;
}

+ (void) save:(HPFPaymentCardToken *)paymentCardToken forCurrency:(NSString *)currency withTouchID:(BOOL)touchID {
    
    FXKeychain *fxKeychain = [FXKeychain defaultKeychain];

    NSArray *tokens = [self paymentCardTokensForCurrency:currency];

    BOOL alreadyThere = NO;
    if (tokens != nil && tokens.count > 0) {
        for (HPFPaymentCardToken *cardToken in tokens) {

            if ([cardToken isEqualToPaymentCardToken:paymentCardToken]) {
                alreadyThere = YES;
            }
        }
    }

    if (alreadyThere == NO) {

        NSString *key = [NSString stringWithFormat:@"paymentCardToken_%@", currency];
        NSString *keyTouchID = [NSString stringWithFormat:@"paymentCardTokenTouchID_%@", currency];

        //data added token = NOW
        paymentCardToken.dateAdded = [NSDate new];

        if (tokens != nil && tokens.count > 0) {
            [fxKeychain setObject:[tokens arrayByAddingObject:paymentCardToken] forKey:key];

            // add the same for touchID booleans
            [fxKeychain setObject:[[HPFPaymentCardTokenDatabase paymentCardTokensTouchIDForCurrency:currency] arrayByAddingObject:@(touchID)] forKey:keyTouchID];

        } else {

            //add currency to list
            [self addCurrencyInList:currency];

            [fxKeychain setObject:[NSArray arrayWithObject:paymentCardToken] forKey:key];

            // add the same for touchID booleans
            [fxKeychain setObject:[NSArray arrayWithObject:@(touchID)] forKey:keyTouchID];
        }
    }
}

+ (void) delete:(HPFPaymentCardToken *)paymentCardToken forCurrency:(NSString *)currency {

    int index = -1;
    NSArray *tokens = [self paymentCardTokensForCurrency:currency];
    if (tokens != nil && tokens.count > 0) {

        for (int i = 0; i < tokens.count; ++i) {

            if ([tokens[i] isEqualToPaymentCardToken:paymentCardToken]) {
                index = i;
            }
        }

        if (index != -1) {

            NSMutableArray *mutableTokens = [tokens mutableCopy];
            [mutableTokens removeObjectAtIndex:index];

            NSMutableArray *mutableTouchID = [[self paymentCardTokensTouchIDForCurrency:currency] mutableCopy];
            [mutableTouchID removeObjectAtIndex:index];

            //remove currency from list
            if (mutableTokens.count == 0) {
                [self removeCurrencyInList:currency];
            }

            FXKeychain *fxKeychain = [FXKeychain defaultKeychain];
            NSString *key = [NSString stringWithFormat:@"paymentCardToken_%@", currency];
            [fxKeychain setObject:[NSArray arrayWithArray:mutableTokens] forKey:key];

            NSString *keyTouchID = [NSString stringWithFormat:@"paymentCardTokenTouchID_%@", currency];
            [fxKeychain setObject:[NSArray arrayWithArray:mutableTouchID] forKey:keyTouchID];

        }
    }
}

@end
