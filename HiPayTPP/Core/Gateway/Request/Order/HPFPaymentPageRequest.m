//
//  HPFHostedPaymentPageRequest.m
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import "HPFPaymentPageRequest.h"
#import "HPFPaymentProduct.h"

NSString *const HPFPaymentPageRequestTemplateNameBasic = @"basic-js";
NSString *const HPFPaymentPageRequestTemplateNameFrame = @"iframe-js";

@implementation HPFPaymentPageRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _authenticationIndicator = HPFAuthenticationIndicatorUndefined;
        _eci = HPFECIUndefined;
        _multiUse = NO;
        _displaySelector = NO;
        _paymentCardGroupingEnabled = YES;
        _groupedPaymentCardProductCodes = [NSMutableSet setWithObjects:HPFPaymentProductCodeCB, HPFPaymentProductCodeMasterCard, HPFPaymentProductCodeVisa, HPFPaymentProductCodeAmericanExpress, HPFPaymentProductCodeMaestro, HPFPaymentProductCodeDiners, nil];
    }
    return self;
}

@end