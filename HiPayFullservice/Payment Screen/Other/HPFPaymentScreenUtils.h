//
//  HPFPaymentScreenUtils.h
//  Pods
//
//  Created by Jonathan TIRET on 02/11/2015.
//
//

#ifndef HPFPaymentScreenUtils_h
#define HPFPaymentScreenUtils_h

#define HPFLocalizedString(key) NSLocalizedStringFromTableInBundle(key, @"Payment-Screen", [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"HPFPaymentScreenLocalization" ofType:@"bundle"]], nil)

#define HPFPaymentScreenViewsBundle() [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"HPFPaymentScreenViews" ofType:@"bundle"]]

#endif /* HPFPaymentScreenUtils_h */
