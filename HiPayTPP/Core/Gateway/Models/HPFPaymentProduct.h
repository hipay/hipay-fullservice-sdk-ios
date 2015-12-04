//
//  HPFPaymentProduct.h
//  Pods
//
//  Created by Jonathan TIRET on 20/10/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPFSecurityCodeType) {
    
    // Ex. : Maestro
    HPFSecurityCodeTypeNone,

    // Ex. : BCMC (for domestic networks or specific issuer payment products, we don't know if there's a security code as it depends on the card scheme)
    HPFSecurityCodeTypeNotApplicable,
    
    // Ex. : Visa, MasterCard
    HPFSecurityCodeTypeCVV,
    
    // Ex. : American Express
    HPFSecurityCodeTypeCID,
    
};

extern NSString *const HPFPaymentProductCode3xcb;
extern NSString *const HPFPaymentProductCode3xcbNoFees;
extern NSString *const HPFPaymentProductCode4xcb;
extern NSString *const HPFPaymentProductCode4xcbNoFees;
extern NSString *const HPFPaymentProductCodeAmericanExpress;
extern NSString *const HPFPaymentProductCodeArgencard;
extern NSString *const HPFPaymentProductCodeBaloto;
extern NSString *const HPFPaymentProductCodeBankTransfer;
extern NSString *const HPFPaymentProductCodeBCMC;
extern NSString *const HPFPaymentProductCodeBCMCMobile;
extern NSString *const HPFPaymentProductCodeBCP;
extern NSString *const HPFPaymentProductCodeBitcoin;
extern NSString *const HPFPaymentProductCodeCabal;
extern NSString *const HPFPaymentProductCodeCarteAccord;
extern NSString *const HPFPaymentProductCodeCB;
extern NSString *const HPFPaymentProductCodeCBCOnline;
extern NSString *const HPFPaymentProductCodeCensosud;
extern NSString *const HPFPaymentProductCodeCobroExpress;
extern NSString *const HPFPaymentProductCodeCofinoga;
extern NSString *const HPFPaymentProductCodeDexiaDirectNet;
extern NSString *const HPFPaymentProductCodeDiners;
extern NSString *const HPFPaymentProductCodeEfecty;
extern NSString *const HPFPaymentProductCodeElo;
extern NSString *const HPFPaymentProductCodeGiropay;
extern NSString *const HPFPaymentProductCodeIDEAL;
extern NSString *const HPFPaymentProductCodeINGHomepay;
extern NSString *const HPFPaymentProductCodeIxe;
extern NSString *const HPFPaymentProductCodeKBCOnline;
extern NSString *const HPFPaymentProductCodeKlarnacheckout;
extern NSString *const HPFPaymentProductCodeKlarnaInvoice;
extern NSString *const HPFPaymentProductCodeMaestro;
extern NSString *const HPFPaymentProductCodeMasterCard;
extern NSString *const HPFPaymentProductCodeNaranja;
extern NSString *const HPFPaymentProductCodeOxxo;
extern NSString *const HPFPaymentProductCodePagoFacil;
extern NSString *const HPFPaymentProductCodePayPal;
extern NSString *const HPFPaymentProductCodePaysafecard;
extern NSString *const HPFPaymentProductCodePayULatam;
extern NSString *const HPFPaymentProductCodeProvincia;
extern NSString *const HPFPaymentProductCodePrzelewy24;
extern NSString *const HPFPaymentProductCodeQiwiWallet;
extern NSString *const HPFPaymentProductCodeRapipago;
extern NSString *const HPFPaymentProductCodeRipsa;
extern NSString *const HPFPaymentProductCodeSDD;
extern NSString *const HPFPaymentProductCodeSisal;
extern NSString *const HPFPaymentProductCodeSofortUberweisung;
extern NSString *const HPFPaymentProductCodeTarjetaShopping;
extern NSString *const HPFPaymentProductCodeVisa;
extern NSString *const HPFPaymentProductCodeWebmoneyTransfer;
extern NSString *const HPFPaymentProductCodeYandex;
extern NSString *const HPFPaymentProductCodeDCBAustriaA1;
extern NSString *const HPFPaymentProductCodeDCBAustriaTMobile;
extern NSString *const HPFPaymentProductCodeDCBAustriaOrange;
extern NSString *const HPFPaymentProductCodeDCBAustriaDrei;
extern NSString *const HPFPaymentProductCodeDCBCzetchTMobile;
extern NSString *const HPFPaymentProductCodeDCBCzetchO2;
extern NSString *const HPFPaymentProductCodeDCBCzetchVodafone;
extern NSString *const HPFPaymentProductCodeDCBBelgiumProximus;
extern NSString *const HPFPaymentProductCodeDCBBelgiumMobistar;
extern NSString *const HPFPaymentProductCodeDCBSpainPagosMovistar;
extern NSString *const HPFPaymentProductCodeDCBSingaporeSingtel;
extern NSString *const HPFPaymentProductCodeDCBSwissEasyPay;
extern NSString *const HPFPaymentProductCodeDCBItalyMobilePay;

extern NSString *const HPFPaymentProductCategoryCodeCreditCard;
extern NSString *const HPFPaymentProductCategoryCodeDebitCard;
extern NSString *const HPFPaymentProductCategoryCodeRealtimeBanking;
extern NSString *const HPFPaymentProductCategoryCodeEWallet;

@interface HPFPaymentProduct : NSObject

@property (nonatomic, readonly) NSString *code;
@property (nonatomic, readonly) NSString *paymentProductId;
@property (nonatomic, readonly) NSString *paymentProductDescription;
@property (nonatomic, readonly) NSString *paymentProductCategoryCode;
@property (nonatomic, readonly) BOOL tokenizable;
@property (nonatomic, readonly) NSSet <NSString *> *groupedPaymentProductCodes;

+ (HPFSecurityCodeType)securityCodeTypeForPaymentProductCode:(NSString *)paymentProductCode;

+ (BOOL)isPaymentProductCode:(NSString *)domesticPaymentProductCode domesticNetworkOfPaymentProductCode:(NSString *)paymentProductCode;

- (instancetype)initWithGroupedProducts:(NSSet <NSString *> *)paymentProducts;

@end
