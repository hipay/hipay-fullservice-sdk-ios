//
//  HPTPaymentScreenUtils.h
//  Pods
//
//  Created by Jonathan TIRET on 02/11/2015.
//
//

#ifndef HPTPaymentScreenUtils_h
#define HPTPaymentScreenUtils_h

#define HPTLocalizedString(key) NSLocalizedStringFromTableInBundle(key, @"Payment-Screen", [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PaymentScreenLocalization" ofType:@"bundle"]], nil)

#define HPTPaymentScreenViewsBundle() [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PaymentScreenViews" ofType:@"bundle"]]

#endif /* HPTPaymentScreenUtils_h */
