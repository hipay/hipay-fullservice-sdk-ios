//
//  HPTPaymentScreenLocalization.h
//  Pods
//
//  Created by Jonathan TIRET on 02/11/2015.
//
//

#ifndef HPTPaymentScreenLocalization_h
#define HPTPaymentScreenLocalization_h

#define HPTLocalizedString(key) NSLocalizedStringFromTableInBundle(key, @"Payment-Screen", [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PaymentScreenLocalization" ofType:@"bundle"]], nil)

#endif /* HPTPaymentScreenLocalization_h */
