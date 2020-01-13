//
//  HPFHostedPaymentPageRequest.m
//  Pods
//
//  Created by HiPay on 14/10/2015.
//
//

#import "HPFPaymentPageRequest.h"
#import "HPFPaymentProduct.h"

NSString * _Nonnull const HPFPaymentPageRequestTemplateNameBasic = @"basic-js";
NSString * _Nonnull const HPFPaymentPageRequestTemplateNameFrame = @"iframe-js";

@implementation HPFPaymentPageRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _authenticationIndicator = HPFAuthenticationIndicatorDefault;
        _eci = HPFECISecureECommerce;
        _multiUse = NO;
        _displaySelector = NO;
        _paymentCardGroupingEnabled = YES;
        _groupedPaymentCardProductCodes = [NSMutableSet setWithObjects:HPFPaymentProductCodeCB, HPFPaymentProductCodeMasterCard, HPFPaymentProductCodeVisa, HPFPaymentProductCodeAmericanExpress, HPFPaymentProductCodeMaestro, HPFPaymentProductCodeDiners, nil];
        _timeout = @(604800); //7 days
    }
    return self;
}

@end
