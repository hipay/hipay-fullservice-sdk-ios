//
//  HPFPaymentProduct.m
//  Pods
//
//  Created by Jonathan TIRET on 20/10/2015.
//
//

#import "HPFPaymentProduct.h"
#import "HPFPaymentScreenUtils.h"

NSString *const HPFPaymentProductCode3xcb                   = @"3xcb";
NSString *const HPFPaymentProductCode3xcbNoFees             = @"3xcb-no-fees";
NSString *const HPFPaymentProductCode4xcb                   = @"4xcb";
NSString *const HPFPaymentProductCode4xcbNoFees             = @"4xcb-no-fees";
NSString *const HPFPaymentProductCodeAmericanExpress        = @"american-express";
NSString *const HPFPaymentProductCodeArgencard              = @"argencard";
NSString *const HPFPaymentProductCodeBaloto                 = @"baloto";
NSString *const HPFPaymentProductCodeBankTransfer           = @"bank-transfer";
NSString *const HPFPaymentProductCodeBCMC                   = @"bcmc";
NSString *const HPFPaymentProductCodeBCMCMobile             = @"bcmc-mobile";
NSString *const HPFPaymentProductCodeBCP                    = @"bcp";
NSString *const HPFPaymentProductCodeBitcoin                = @"bitcoin";
NSString *const HPFPaymentProductCodeCabal                  = @"cabal";
NSString *const HPFPaymentProductCodeCarteAccord            = @"carte-accord";
NSString *const HPFPaymentProductCodeCB                     = @"cb";
NSString *const HPFPaymentProductCodeCBCOnline              = @"cbc-online";
NSString *const HPFPaymentProductCodeCensosud               = @"censosud";
NSString *const HPFPaymentProductCodeCobroExpress           = @"cobro-express";
NSString *const HPFPaymentProductCodeCofinoga               = @"cofinoga";
NSString *const HPFPaymentProductCodeDexiaDirectNet         = @"dexia-directnet";
NSString *const HPFPaymentProductCodeDiners                 = @"diners";
NSString *const HPFPaymentProductCodeEfecty                 = @"efecty";
NSString *const HPFPaymentProductCodeElo                    = @"elo";
NSString *const HPFPaymentProductCodeGiropay                = @"giropay";
NSString *const HPFPaymentProductCodeIDEAL                  = @"ideal";
NSString *const HPFPaymentProductCodeINGHomepay             = @"ing-homepay";
NSString *const HPFPaymentProductCodeIxe                    = @"ixe";
NSString *const HPFPaymentProductCodeKBCOnline              = @"kbc-online";
NSString *const HPFPaymentProductCodeKlarnacheckout         = @"klarnacheckout";
NSString *const HPFPaymentProductCodeKlarnaInvoice          = @"klarnainvoice";
NSString *const HPFPaymentProductCodeMaestro                = @"maestro";
NSString *const HPFPaymentProductCodeMasterCard             = @"mastercard";
NSString *const HPFPaymentProductCodeNaranja                = @"naranja";
NSString *const HPFPaymentProductCodeOxxo                   = @"oxxo";
NSString *const HPFPaymentProductCodePagoFacil              = @"pago-facil";
NSString *const HPFPaymentProductCodePayPal                 = @"paypal";
NSString *const HPFPaymentProductCodePaysafecard            = @"paysafecard";
NSString *const HPFPaymentProductCodePayULatam              = @"payulatam";
NSString *const HPFPaymentProductCodeProvincia              = @"provincia";
NSString *const HPFPaymentProductCodePrzelewy24             = @"przelewy24";
NSString *const HPFPaymentProductCodeQiwiWallet             = @"qiwi-wallet";
NSString *const HPFPaymentProductCodeRapipago               = @"rapipago";
NSString *const HPFPaymentProductCodeRipsa                  = @"ripsa";
NSString *const HPFPaymentProductCodeSDD                    = @"sdd";
NSString *const HPFPaymentProductCodeSisal                  = @"sisal";
NSString *const HPFPaymentProductCodeSofortUberweisung      = @"sofort-uberweisung";
NSString *const HPFPaymentProductCodeTarjetaShopping        = @"tarjeta-shopping";
NSString *const HPFPaymentProductCodeVisa                   = @"visa";
NSString *const HPFPaymentProductCodeWebmoneyTransfer       = @"webmoney-transfer";
NSString *const HPFPaymentProductCodeYandex                 = @"yandex";
NSString *const HPFPaymentProductCodeDCBAustriaA1           = @"dcb-at-a1";
NSString *const HPFPaymentProductCodeDCBAustriaTMobile      = @"dcb-at-tmobile";
NSString *const HPFPaymentProductCodeDCBAustriaOrange       = @"dcb-at-orange";
NSString *const HPFPaymentProductCodeDCBAustriaDrei         = @"dcb-at-drei";
NSString *const HPFPaymentProductCodeDCBCzetchTMobile       = @"dcb-cz-tmobile";
NSString *const HPFPaymentProductCodeDCBCzetchO2            = @"dcb-cz-o2";
NSString *const HPFPaymentProductCodeDCBCzetchVodafone      = @"dcb-cz-vodafone";
NSString *const HPFPaymentProductCodeDCBBelgiumProximus     = @"dcb-be-proximus";
NSString *const HPFPaymentProductCodeDCBBelgiumMobistar     = @"dcb-be-mobistar";
NSString *const HPFPaymentProductCodeDCBSpainPagosMovistar  = @"dcb-es-pagosmovistar";
NSString *const HPFPaymentProductCodeDCBSingaporeSingtel    = @"dcb-sg-singtel";
NSString *const HPFPaymentProductCodeDCBSwissEasyPay        = @"dcb-ch-easypay";
NSString *const HPFPaymentProductCodeDCBItalyMobilePay      = @"dcb-it-mobilepay";

NSString *const HPFPaymentProductCategoryCodeCreditCard = @"credit-card";
NSString *const HPFPaymentProductCategoryCodeDebitCard = @"debit-card";
NSString *const HPFPaymentProductCategoryCodeRealtimeBanking = @"realtime-banking";
NSString *const HPFPaymentProductCategoryCodeEWallet = @"ewallet";

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
        _paymentProductDescription = HPFLocalizedString(@"PAYMENT_PRODUCT_GROUP_PAYMENT_CARD");
        _paymentProductCategoryCode = HPFPaymentProductCategoryCodeCreditCard;
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
