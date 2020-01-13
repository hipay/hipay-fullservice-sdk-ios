//
//  HPFPaymentProduct.h
//  Pods
//
//  Created by HiPay on 20/10/2015.
//
//

#import <Foundation/Foundation.h>

/**
 *  Describes the security code type of a payment card.
 */
typedef NS_ENUM(NSInteger, HPFSecurityCodeType) {
    
    /**
     *  No security code (e.g., for Maestro).
     */
    HPFSecurityCodeTypeNone,
    
    /**
     *  The security code type cannot be determined because it's a domestic network. (e.g, for CB).
     */
    HPFSecurityCodeTypeNotApplicable,
    
    /**
     *  Three-digit CVV security code (e.g., for Visa and MasterCard).
     */
    HPFSecurityCodeTypeCVV,
    
    /**
     *  Four-digit CID security code (e.g., for American Express).
     */
    HPFSecurityCodeTypeCID,
};

extern NSString * _Nonnull const HPFPaymentProductCode3xcb;
extern NSString * _Nonnull const HPFPaymentProductCode3xcbNoFees;
extern NSString * _Nonnull const HPFPaymentProductCode4xcb;
extern NSString * _Nonnull const HPFPaymentProductCode4xcbNoFees;
extern NSString * _Nonnull const HPFPaymentProductCodeAmericanExpress;
extern NSString * _Nonnull const HPFPaymentProductCodeArgencard;
extern NSString * _Nonnull const HPFPaymentProductCodeBaloto;
extern NSString * _Nonnull const HPFPaymentProductCodeBankTransfer;
extern NSString * _Nonnull const HPFPaymentProductCodeBCMC;
extern NSString * _Nonnull const HPFPaymentProductCodeBCMCMobile;
extern NSString * _Nonnull const HPFPaymentProductCodeBCP;
extern NSString * _Nonnull const HPFPaymentProductCodeBitcoin;
extern NSString * _Nonnull const HPFPaymentProductCodeCabal;
extern NSString * _Nonnull const HPFPaymentProductCodeCarteAccord;
extern NSString * _Nonnull const HPFPaymentProductCodeCB;
extern NSString * _Nonnull const HPFPaymentProductCodeCBCOnline;
extern NSString * _Nonnull const HPFPaymentProductCodeCensosud;
extern NSString * _Nonnull const HPFPaymentProductCodeCobroExpress;
extern NSString * _Nonnull const HPFPaymentProductCodeCofinoga;
extern NSString * _Nonnull const HPFPaymentProductCodeDexiaDirectNet;
extern NSString * _Nonnull const HPFPaymentProductCodeDiners;
extern NSString * _Nonnull const HPFPaymentProductCodeEfecty;
extern NSString * _Nonnull const HPFPaymentProductCodeElo;
extern NSString * _Nonnull const HPFPaymentProductCodeGiropay;
extern NSString * _Nonnull const HPFPaymentProductCodeIDEAL;
extern NSString * _Nonnull const HPFPaymentProductCodeINGHomepay;
extern NSString * _Nonnull const HPFPaymentProductCodeIxe;
extern NSString * _Nonnull const HPFPaymentProductCodeKBCOnline;
extern NSString * _Nonnull const HPFPaymentProductCodeKlarnacheckout;
extern NSString * _Nonnull const HPFPaymentProductCodeKlarnaInvoice;
extern NSString * _Nonnull const HPFPaymentProductCodeMaestro;
extern NSString * _Nonnull const HPFPaymentProductCodeMasterCard;
extern NSString * _Nonnull const HPFPaymentProductCodeNaranja;
extern NSString * _Nonnull const HPFPaymentProductCodePagoFacil;
extern NSString * _Nonnull const HPFPaymentProductCodePayPal;
extern NSString * _Nonnull const HPFPaymentProductCodePaysafecard;
extern NSString * _Nonnull const HPFPaymentProductCodePayULatam;
extern NSString * _Nonnull const HPFPaymentProductCodeProvincia;
extern NSString * _Nonnull const HPFPaymentProductCodePrzelewy24;
extern NSString * _Nonnull const HPFPaymentProductCodeQiwiWallet;
extern NSString * _Nonnull const HPFPaymentProductCodeRapipago;
extern NSString * _Nonnull const HPFPaymentProductCodeRipsa;
extern NSString * _Nonnull const HPFPaymentProductCodeSDD;
extern NSString * _Nonnull const HPFPaymentProductCodeSisal;
extern NSString * _Nonnull const HPFPaymentProductCodeSofortUberweisung;
extern NSString * _Nonnull const HPFPaymentProductCodeTarjetaShopping;
extern NSString * _Nonnull const HPFPaymentProductCodeVisa;
extern NSString * _Nonnull const HPFPaymentProductCodeWebmoneyTransfer;
extern NSString * _Nonnull const HPFPaymentProductCodeYandex;
extern NSString * _Nonnull const HPFPaymentProductCodeAura;
extern NSString * _Nonnull const HPFPaymentProductCodeBanamex;
extern NSString * _Nonnull const HPFPaymentProductCodeBancoDoBrasil;
extern NSString * _Nonnull const HPFPaymentProductCodeBBVABancomer;
extern NSString * _Nonnull const HPFPaymentProductCodeBoletoBancario;
extern NSString * _Nonnull const HPFPaymentProductCodeBradesco;
extern NSString * _Nonnull const HPFPaymentProductCodeCaixa;
extern NSString * _Nonnull const HPFPaymentProductCodeDiscover;
extern NSString * _Nonnull const HPFPaymentProductCodeItau;
extern NSString * _Nonnull const HPFPaymentProductCodeOxxo;
extern NSString * _Nonnull const HPFPaymentProductCodeSantanderCash;
extern NSString * _Nonnull const HPFPaymentProductCodeSantanderHomeBanking;
extern NSString * _Nonnull const HPFPaymentProductCodeDexiaDirectNet;

extern NSString * _Nonnull const HPFPaymentProductCodeApplePay;

extern NSString * _Nonnull const HPFPaymentProductCategoryCodeCreditCard;
extern NSString * _Nonnull const HPFPaymentProductCategoryCodeDebitCard;
extern NSString * _Nonnull const HPFPaymentProductCategoryCodeRealtimeBanking;
extern NSString * _Nonnull const HPFPaymentProductCategoryCodeEWallet;


/**
 *  Describes a payment product (a payment method).
 */
@interface HPFPaymentProduct : NSObject

/**
 *  Payment product code, refer to the HPFPaymentProductCode* constants for more information.
 */
@property (nonatomic, readonly, nonnull) NSString *code;

/**
 *  Payment product ID.
 */
@property (nonatomic, readonly, nullable) NSString *paymentProductId;

/**
 *  Payment product description.
 */
@property (nonatomic, readonly, nonnull) NSString *paymentProductDescription;

/**
 *  Payment product category code, refer to the HPFPaymentProductCategoryCode* constants for more information.
 */
@property (nonatomic, readonly, nonnull) NSString *paymentProductCategoryCode;

/**
 *  Whether this payment product is tokenizable (true for most the credit and debit cards).
 */
@property (nonatomic, readonly) BOOL tokenizable;

@property (nonatomic, readonly, nullable) NSSet <NSString *> *groupedPaymentProductCodes;

+ (HPFSecurityCodeType)securityCodeTypeForPaymentProductCode:(NSString * _Nonnull)paymentProductCode;

+ (BOOL)isPaymentProductCode:(NSString * _Nonnull)domesticPaymentProductCode domesticNetworkOfPaymentProductCode:(NSString * _Nonnull)paymentProductCode;
+ (BOOL)isPaymentCardStorageEnabledForPaymentProductCode:(NSString * _Nonnull)paymentProductCode;
+ (BOOL)isDSP2CompatiblePaymentProductCode:(NSString * _Nonnull)paymentProductCode;

- (instancetype _Nonnull)initWithGroupedProducts:(NSSet <NSString *> * _Nonnull)paymentProducts;

- (instancetype _Nonnull)initWithApplePayProduct;

@end
