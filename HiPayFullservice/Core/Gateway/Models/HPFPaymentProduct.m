//
//  HPFPaymentProduct.m
//  Pods
//
//  Created by HiPay on 20/10/2015.
//
//

#import "HPFPaymentProduct.h"

NSString * _Nonnull const HPFPaymentProductCode3xcb                   = @"3xcb";
NSString * _Nonnull const HPFPaymentProductCode3xcbNoFees             = @"3xcb-no-fees";
NSString * _Nonnull const HPFPaymentProductCode4xcb                   = @"4xcb";
NSString * _Nonnull const HPFPaymentProductCode4xcbNoFees             = @"4xcb-no-fees";
NSString * _Nonnull const HPFPaymentProductCodeAmericanExpress        = @"american-express";
NSString * _Nonnull const HPFPaymentProductCodeArgencard              = @"argencard";
NSString * _Nonnull const HPFPaymentProductCodeBaloto                 = @"baloto";
NSString * _Nonnull const HPFPaymentProductCodeBankTransfer           = @"bank-transfer";
NSString * _Nonnull const HPFPaymentProductCodeBCMC                   = @"bcmc";
NSString * _Nonnull const HPFPaymentProductCodeBCMCMobile             = @"bcmc-mobile";
NSString * _Nonnull const HPFPaymentProductCodeBCP                    = @"bcp";
NSString * _Nonnull const HPFPaymentProductCodeBitcoin                = @"bitcoin";
NSString * _Nonnull const HPFPaymentProductCodeCabal                  = @"cabal";
NSString * _Nonnull const HPFPaymentProductCodeCarteAccord            = @"carte-accord";
NSString * _Nonnull const HPFPaymentProductCodeCB                     = @"cb";
NSString * _Nonnull const HPFPaymentProductCodeCBCOnline              = @"cbc-online";
NSString * _Nonnull const HPFPaymentProductCodeCensosud               = @"censosud";
NSString * _Nonnull const HPFPaymentProductCodeCobroExpress           = @"cobro-express";
NSString * _Nonnull const HPFPaymentProductCodeCofinoga               = @"cofinoga";
NSString * _Nonnull const HPFPaymentProductCodeDexiaDirectNet         = @"dexia-directnet";
NSString * _Nonnull const HPFPaymentProductCodeDiners                 = @"diners";
NSString * _Nonnull const HPFPaymentProductCodeEfecty                 = @"efecty";
NSString * _Nonnull const HPFPaymentProductCodeElo                    = @"elo";
NSString * _Nonnull const HPFPaymentProductCodeGiropay                = @"giropay";
NSString * _Nonnull const HPFPaymentProductCodeIDEAL                  = @"ideal";
NSString * _Nonnull const HPFPaymentProductCodeINGHomepay             = @"ing-homepay";
NSString * _Nonnull const HPFPaymentProductCodeIxe                    = @"ixe";
NSString * _Nonnull const HPFPaymentProductCodeKBCOnline              = @"kbc-online";
NSString * _Nonnull const HPFPaymentProductCodeKlarnacheckout         = @"klarnacheckout";
NSString * _Nonnull const HPFPaymentProductCodeKlarnaInvoice          = @"klarnainvoice";
NSString * _Nonnull const HPFPaymentProductCodeMaestro                = @"maestro";
NSString * _Nonnull const HPFPaymentProductCodeMasterCard             = @"mastercard";
NSString * _Nonnull const HPFPaymentProductCodeNaranja                = @"naranja";
NSString * _Nonnull const HPFPaymentProductCodePagoFacil              = @"pago-facil";
NSString * _Nonnull const HPFPaymentProductCodePayPal                 = @"paypal";
NSString * _Nonnull const HPFPaymentProductCodePaysafecard            = @"paysafecard";
NSString * _Nonnull const HPFPaymentProductCodePayULatam              = @"payulatam";
NSString * _Nonnull const HPFPaymentProductCodeProvincia              = @"provincia";
NSString * _Nonnull const HPFPaymentProductCodePrzelewy24             = @"przelewy24";
NSString * _Nonnull const HPFPaymentProductCodeQiwiWallet             = @"qiwi-wallet";
NSString * _Nonnull const HPFPaymentProductCodeRapipago               = @"rapipago";
NSString * _Nonnull const HPFPaymentProductCodeRipsa                  = @"ripsa";
NSString * _Nonnull const HPFPaymentProductCodeSDD                    = @"sdd";
NSString * _Nonnull const HPFPaymentProductCodeSisal                  = @"sisal";
NSString * _Nonnull const HPFPaymentProductCodeSofortUberweisung      = @"sofort-uberweisung";
NSString * _Nonnull const HPFPaymentProductCodeTarjetaShopping        = @"tarjeta-shopping";
NSString * _Nonnull const HPFPaymentProductCodeVisa                   = @"visa";
NSString * _Nonnull const HPFPaymentProductCodeWebmoneyTransfer       = @"webmoney-transfer";
NSString * _Nonnull const HPFPaymentProductCodeYandex                 = @"yandex";
NSString * _Nonnull const HPFPaymentProductCodeAura                   = @"aura";
NSString * _Nonnull const HPFPaymentProductCodeBanamex                = @"banamex";
NSString * _Nonnull const HPFPaymentProductCodeBancoDoBrasil          = @"banco-do-brasil";
NSString * _Nonnull const HPFPaymentProductCodeBBVABancomer           = @"bbva-bancomer";
NSString * _Nonnull const HPFPaymentProductCodeBoletoBancario         = @"boleto-bancario";
NSString * _Nonnull const HPFPaymentProductCodeBradesco               = @"bradesco";
NSString * _Nonnull const HPFPaymentProductCodeCaixa                  = @"caixa";
NSString * _Nonnull const HPFPaymentProductCodeDiscover               = @"discover";
NSString * _Nonnull const HPFPaymentProductCodeItau                   = @"itau";
NSString * _Nonnull const HPFPaymentProductCodeOxxo                   = @"oxxo";
NSString * _Nonnull const HPFPaymentProductCodeSantanderCash          = @"santander-cash";
NSString * _Nonnull const HPFPaymentProductCodeSantanderHomeBanking   = @"santander-home-banking";

NSString * _Nonnull const HPFPaymentProductCodeApplePay   = @"apple-pay";

NSString * _Nonnull const HPFPaymentProductCategoryCodeCreditCard = @"credit-card";
NSString * _Nonnull const HPFPaymentProductCategoryCodeDebitCard = @"debit-card";
NSString * _Nonnull const HPFPaymentProductCategoryCodeRealtimeBanking = @"realtime-banking";
NSString * _Nonnull const HPFPaymentProductCategoryCodeEWallet = @"ewallet";

@implementation HPFPaymentProduct

+ (HPFSecurityCodeType)securityCodeTypeForPaymentProductCode:(NSString *)paymentProductCode
{
    if ([paymentProductCode isEqualToString:HPFPaymentProductCodeVisa] || [paymentProductCode isEqualToString:HPFPaymentProductCodeMasterCard] || [paymentProductCode isEqualToString:HPFPaymentProductCodeDiners]) {
        return HPFSecurityCodeTypeCVV;
    }
    
    else if ([paymentProductCode isEqualToString:HPFPaymentProductCodeAmericanExpress]) {
        return HPFSecurityCodeTypeCID;
    }
    
    else if ([paymentProductCode isEqualToString:HPFPaymentProductCodeBCMC] || [paymentProductCode isEqualToString:HPFPaymentProductCodeMaestro]) {
        return HPFSecurityCodeTypeNone;
    }
    
    return HPFSecurityCodeTypeNotApplicable;
}

+ (BOOL)isDSP2CompatiblePaymentProductCode:(NSString *)paymentProductCode {
    if (paymentProductCode) {
        return ([paymentProductCode caseInsensitiveCompare:HPFPaymentProductCodeMasterCard] == NSOrderedSame
                || [paymentProductCode caseInsensitiveCompare:HPFPaymentProductCodeVisa] == NSOrderedSame
                || [paymentProductCode caseInsensitiveCompare:HPFPaymentProductCodeMaestro] == NSOrderedSame
                || [paymentProductCode caseInsensitiveCompare:HPFPaymentProductCodeCB] == NSOrderedSame
                || [paymentProductCode caseInsensitiveCompare:HPFPaymentProductCodeAmericanExpress] == NSOrderedSame
                || [paymentProductCode caseInsensitiveCompare:HPFPaymentProductCodeBCMC] == NSOrderedSame);
    }
    else {
        return false;
    }
}

+ (BOOL)isPaymentCardStorageEnabledForPaymentProductCode:(NSString *)paymentProductCode
{
    if ([paymentProductCode isEqualToString:HPFPaymentProductCodeBCMC] || [paymentProductCode isEqualToString:HPFPaymentProductCodeMaestro]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isPaymentProductCode:(NSString *)domesticPaymentProductCode domesticNetworkOfPaymentProductCode:(NSString *)paymentProductCode
{
    if ([domesticPaymentProductCode isEqualToString:HPFPaymentProductCodeBCMC]) {
        return [paymentProductCode isEqualToString:HPFPaymentProductCodeMaestro];
    }
    
    if ([domesticPaymentProductCode isEqualToString:HPFPaymentProductCodeCB]) {
        return [paymentProductCode isEqualToString:HPFPaymentProductCodeMasterCard] || [paymentProductCode isEqualToString:HPFPaymentProductCodeVisa];
    }
    
    return NO;
}

- (instancetype)initWithGroupedProducts:(NSSet <NSString *> *)paymentProducts
{
    self = [super init];
    if (self) {
        _groupedPaymentProductCodes = paymentProducts;
        _paymentProductDescription = NSLocalizedStringFromTableInBundle(@"PAYMENT_PRODUCT_GROUP_PAYMENT_CARD", @"Core", [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"HPFCoreLocalization" ofType:@"bundle"]], nil);
        _paymentProductCategoryCode = HPFPaymentProductCategoryCodeCreditCard;
    }
    return self;
}

- (instancetype)initWithApplePayProduct {
    self = [super init];
    if (self) {
        _paymentProductDescription = @"Apple Pay";
        _paymentProductCategoryCode = HPFPaymentProductCodeApplePay;
        _code = HPFPaymentProductCodeApplePay;
    }
    return self;
}

- (BOOL)isEqualToPaymentProduct:(HPFPaymentProduct *)object
{
    if (![object isKindOfClass:[HPFPaymentProduct class]]) {
        return NO;
    }
    
    return [self.code isEqual:object.code];
}

- (BOOL)isEqual:(id)object
{
    return [self isEqualToPaymentProduct:object];
}

@end
