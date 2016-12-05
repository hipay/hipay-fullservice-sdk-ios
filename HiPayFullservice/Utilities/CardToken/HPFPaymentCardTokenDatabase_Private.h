//
// Created by Nicolas FILLION on 21/11/2016.
// Copyright (c) 2016 Jonathan TIRET. All rights reserved.
//

#import "HPFPaymentCardTokenDatabase.h"
@class HPFPaymentCardToken;

@interface HPFPaymentCardTokenDatabase ()

+ (void) save:(HPFPaymentCardToken *)paymentCardToken forCurrency:(NSString *)currency withTouchID:(BOOL)touchID;

@end
