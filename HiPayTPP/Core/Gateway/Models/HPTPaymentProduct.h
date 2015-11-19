//
//  HPTPaymentProduct.h
//  Pods
//
//  Created by Jonathan TIRET on 20/10/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPTSecurityCodeType) {
    
    // Ex. : Maestro
    HPTSecurityCodeTypeNone,

    // Ex. : BCMC (for domestic networks or specific issuer payment products, we don't know if there's a security code as it depends on the card scheme)
    HPTSecurityCodeTypeNotApplicable,
    
    // Ex. : Visa, MasterCard
    HPTSecurityCodeTypeCVV,
    
    // Ex. : American Express
    HPTSecurityCodeTypeCID,
    
};

extern NSString *const HPTPaymentProductCode3xcb;
extern NSString *const HPTPaymentProductCode3xcbNoFees;
extern NSString *const HPTPaymentProductCode4xcb;
extern NSString *const HPTPaymentProductCode4xcbNoFees;
extern NSString *const HPTPaymentProductCodeAmericanExpress;
extern NSString *const HPTPaymentProductCodeArgencard;
extern NSString *const HPTPaymentProductCodeBaloto;
extern NSString *const HPTPaymentProductCodeBankTransfer;
extern NSString *const HPTPaymentProductCodeBCMC;
extern NSString *const HPTPaymentProductCodeBCMCMobile;
extern NSString *const HPTPaymentProductCodeBCP;
extern NSString *const HPTPaymentProductCodeBitcoin;
extern NSString *const HPTPaymentProductCodeCabal;
extern NSString *const HPTPaymentProductCodeCarteAccord;
extern NSString *const HPTPaymentProductCodeCB;
extern NSString *const HPTPaymentProductCodeCBCOnline;
extern NSString *const HPTPaymentProductCodeCensosud;
extern NSString *const HPTPaymentProductCodeCobroExpress;
extern NSString *const HPTPaymentProductCodeCofinoga;
extern NSString *const HPTPaymentProductCodeDexiaDirectNet;
extern NSString *const HPTPaymentProductCodeDiners;
extern NSString *const HPTPaymentProductCodeEfecty;
extern NSString *const HPTPaymentProductCodeElo;
extern NSString *const HPTPaymentProductCodeGiropay;
extern NSString *const HPTPaymentProductCodeIDEAL;
extern NSString *const HPTPaymentProductCodeINGHomepay;
extern NSString *const HPTPaymentProductCodeIxe;
extern NSString *const HPTPaymentProductCodeKBCOnline;
extern NSString *const HPTPaymentProductCodeKlarnacheckout;
extern NSString *const HPTPaymentProductCodeKlarnaInvoice;
extern NSString *const HPTPaymentProductCodeMaestro;
extern NSString *const HPTPaymentProductCodeMasterCard;
extern NSString *const HPTPaymentProductCodeNaranja;
extern NSString *const HPTPaymentProductCodeOxxo;
extern NSString *const HPTPaymentProductCodePagoFacil;
extern NSString *const HPTPaymentProductCodePayPal;
extern NSString *const HPTPaymentProductCodePaysafecard;
extern NSString *const HPTPaymentProductCodePayULatam;
extern NSString *const HPTPaymentProductCodeProvincia;
extern NSString *const HPTPaymentProductCodePrzelewy24;
extern NSString *const HPTPaymentProductCodeQiwiWallet;
extern NSString *const HPTPaymentProductCodeRapipago;
extern NSString *const HPTPaymentProductCodeRipsa;
extern NSString *const HPTPaymentProductCodeSDD;
extern NSString *const HPTPaymentProductCodeSisal;
extern NSString *const HPTPaymentProductCodeSofortUberweisung;
extern NSString *const HPTPaymentProductCodeTarjetaShopping;
extern NSString *const HPTPaymentProductCodeVisa;
extern NSString *const HPTPaymentProductCodeWebmoneyTransfer;
extern NSString *const HPTPaymentProductCodeYandex;
extern NSString *const HPTPaymentProductCodeDCBAustriaA1;
extern NSString *const HPTPaymentProductCodeDCBAustriaTMobile;
extern NSString *const HPTPaymentProductCodeDCBAustriaOrange;
extern NSString *const HPTPaymentProductCodeDCBAustriaDrei;
extern NSString *const HPTPaymentProductCodeDCBCzetchTMobile;
extern NSString *const HPTPaymentProductCodeDCBCzetchO2;
extern NSString *const HPTPaymentProductCodeDCBCzetchVodafone;
extern NSString *const HPTPaymentProductCodeDCBBelgiumProximus;
extern NSString *const HPTPaymentProductCodeDCBBelgiumMobistar;
extern NSString *const HPTPaymentProductCodeDCBSpainPagosMovistar;
extern NSString *const HPTPaymentProductCodeDCBSingaporeSingtel;
extern NSString *const HPTPaymentProductCodeDCBSwissEasyPay;
extern NSString *const HPTPaymentProductCodeDCBItalyMobilePay;

@interface HPTPaymentProduct : NSObject

@property (nonatomic, readonly) NSString *code;
@property (nonatomic, readonly) NSString *paymentProductId;
@property (nonatomic, readonly) NSString *paymentProductDescription;
@property (nonatomic, readonly) NSString *paymentProductCategoryCode;
@property (nonatomic, readonly) BOOL tokenizable;

+ (HPTSecurityCodeType)securityCodeTypeForPaymentProductCode:(NSString *)paymentProductCode;

+ (BOOL)isPaymentProduct:(HPTPaymentProduct *)domesticPaymentProduct domesticNetworkOfPaymentProduct:(HPTPaymentProduct *)paymentProduct;

@end
