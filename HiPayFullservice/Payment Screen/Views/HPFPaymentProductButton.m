//
//  HPFPaymentProductButton.m
//  Pods
//
//  Created by HiPay on 26/10/2015.
//
//

#import "HPFPaymentProductButton.h"
#import "HPFPaymentScreenUtils.h"

NSDictionary *HPFPaymentProductButtonPaymentProductMatrix;

@implementation HPFPaymentProductButton

- (instancetype)initWithPaymentProduct:(HPFPaymentProduct *)paymentProduct
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _paymentProduct = paymentProduct.code;
        defaultTintColor = [UIView appearance].tintColor;
        
        if (paymentProduct.groupedPaymentProductCodes == nil) {
        
            NSDictionary *matrixInfo = [[self paymentProductMatrix] objectForKey:paymentProduct.code];
            
            if ((matrixInfo == nil) && ([paymentProduct.code hasPrefix:@"dcb-"])) {
                matrixInfo = @{@"y": @(5), @"x": @(5)};
            }
            
            if (matrixInfo != nil) {
                [self setupBasicPaymentProductWithInfo:matrixInfo];
            }
            
            // No image for this payment product
            else {
                [self setTitle:paymentProduct.paymentProductDescription forState:UIControlStateNormal];
                self.titleLabel.numberOfLines = 3;
                self.titleEdgeInsets = UIEdgeInsetsMake(4.0, 5.0, 4.0, 5.0);
                self.titleLabel.font = [UIFont systemFontOfSize:18.0];
                self.titleLabel.minimumScaleFactor = 0.7;
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
                self.titleLabel.adjustsFontSizeToFitWidth = YES;
                
                [self setTitleColor:[UIColor colorWithRed:0.45 green:0.45 blue:0.45 alpha:1.0] forState:UIControlStateNormal];
                [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
                [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            }
        }
        
        else {
            [self setupGroupPaymentProduct];
        }
        
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 5.0;
        
        [self setDefaultStyle];
        
        [self addTarget:self action:@selector(enableButtonHighlight) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(enableButtonHighlight) forControlEvents:UIControlEventTouchDragInside];
        [self addTarget:self action:@selector(disableButtonHighlight) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(disableButtonHighlight) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(disableButtonHighlight) forControlEvents:UIControlEventTouchDragOutside];

       
    }
    return self;
}

- (void)setupGroupPaymentProduct
{
    baseImage = [[UIImage imageNamed:@"payment_card" inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self setupImages];
}

- (void)setupImages
{
    [self setImage:baseImage forState:UIControlStateNormal];
    [self setImage:selectedImage forState:UIControlStateHighlighted];
    [self setImage:selectedImage forState:UIControlStateSelected];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setupBasicPaymentProductWithInfo:(NSDictionary *)matrixInfo
{
    UIImage *spriteImage = [UIImage imageNamed:@"payment_product_sprites" inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];
    
    UIImage *graySpriteImage = [UIImage imageNamed:@"payment_product_sprites_gray" inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];
    
    baseImage = [self cropImage:graySpriteImage withRect:CGRectMake([matrixInfo[@"x"] floatValue] * 100.0, [matrixInfo[@"y"] floatValue] * 60.0, 100.0, 60.0)];
    
    selectedImage = [self cropImage:spriteImage withRect:CGRectMake([matrixInfo[@"x"] floatValue] * 100.0, [matrixInfo[@"y"] floatValue] * 60.0, 100.0, 60.0)];
    
    [self setupImages];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!self.tracking) {
        [self setDefaultStyle];
    }
    
    if (baseImage == nil) {
        if (self.titleLabel.frame.size.height >= (0.85 * self.frame.size.height)) {
            self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        }
        
        // Label takes two lines at least
        else if ((self.titleLabel.frame.size.height >= (0.5 * self.frame.size.height))) {
            
            // But label is alphanumeric only, it means that a word is broken, it's better to reduce text size
            NSRange range = [self.titleLabel.text rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
            
            if (range.location == NSNotFound) {
                self.titleLabel.font = [UIFont systemFontOfSize:14.0];
            }
        }
    }
}

- (void)setDefaultStyle
{
    if (!self.selected) {
        self.layer.borderColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.88 alpha:1.0].CGColor;
        self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
        self.imageView.alpha = 0.6;
        self.imageView.tintColor = [UIColor lightGrayColor];
    } else {
        self.layer.borderColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.0].CGColor;
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
        self.imageView.alpha = 1.0;
        self.imageView.tintColor = defaultTintColor;
    }
}

- (void)enableButtonHighlight
{
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)disableButtonHighlight
{
    [self setDefaultStyle];
}

- (UIImage *)cropImage:(UIImage *)image withRect:(CGRect)rect {
    
    rect = CGRectMake(rect.origin.x * image.scale, rect.origin.y * image.scale, rect.size.width * image.scale, rect.size.height * image.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setDefaultStyle];
}

- (NSDictionary *)paymentProductMatrix
{
    if (HPFPaymentProductButtonPaymentProductMatrix == nil) {
        HPFPaymentProductButtonPaymentProductMatrix = @{
                                                        HPFPaymentProductCode3xcb:                  @{@"y": @(5), @"x": @(1)},
                                                        HPFPaymentProductCode3xcbNoFees:            @{@"y": @(5), @"x": @(7)},
                                                        HPFPaymentProductCode4xcb:                  @{@"y": @(5), @"x": @(6)},
                                                        HPFPaymentProductCode4xcbNoFees:            @{@"y": @(5), @"x": @(8)},
                                                        HPFPaymentProductCodeAmericanExpress:       @{@"y": @(0), @"x": @(3)},
                                                        HPFPaymentProductCodeArgencard:             @{@"y": @(3), @"x": @(8)},
                                                        HPFPaymentProductCodeBaloto:                @{@"y": @(4), @"x": @(5)},
                                                        HPFPaymentProductCodeBankTransfer:          @{@"y": @(5), @"x": @(2)},
                                                        HPFPaymentProductCodeBCMC:                  @{@"y": @(1), @"x": @(5)},
                                                        HPFPaymentProductCodeBCMCMobile:            @{@"y": @(6), @"x": @(2)},
                                                        HPFPaymentProductCodeBCP:                   @{@"y": @(5), @"x": @(0)},
                                                        HPFPaymentProductCodeBitcoin:               @{@"y": @(5), @"x": @(4)},
                                                        HPFPaymentProductCodeCabal:                 @{@"y": @(3), @"x": @(4)},
                                                        HPFPaymentProductCodeCarteAccord:           @{@"y": @(6), @"x": @(0)},
                                                        HPFPaymentProductCodeCB:                    @{@"y": @(1), @"x": @(7)},
                                                        HPFPaymentProductCodeCBCOnline:             @{@"y": @(0), @"x": @(7)},
                                                        HPFPaymentProductCodeCensosud:              @{@"y": @(4), @"x": @(2)},
                                                        HPFPaymentProductCodeCobroExpress:          @{@"y": @(3), @"x": @(2)},
                                                        HPFPaymentProductCodeCofinoga:              @{@"y": @(2), @"x": @(5)},
                                                        HPFPaymentProductCodeDexiaDirectNet:        @{@"y": @(1), @"x": @(4)},
                                                        HPFPaymentProductCodeDiners:                @{@"y": @(4), @"x": @(3)},
                                                        HPFPaymentProductCodeEfecty:                @{@"y": @(4), @"x": @(6)},
                                                        HPFPaymentProductCodeElo:                   @{@"y": @(4), @"x": @(4)},
                                                        HPFPaymentProductCodeGiropay:               @{@"y": @(1), @"x": @(2)},
                                                        HPFPaymentProductCodeIDEAL:                 @{@"y": @(1), @"x": @(1)},
                                                        HPFPaymentProductCodeINGHomepay:            @{@"y": @(1), @"x": @(0)},
                                                        HPFPaymentProductCodeIxe:                   @{@"y": @(4), @"x": @(8)},
                                                        HPFPaymentProductCodeKBCOnline:             @{@"y": @(0), @"x": @(6)},
                                                        HPFPaymentProductCodeKlarnacheckout:        @{@"y": @(2), @"x": @(7)},
                                                        HPFPaymentProductCodeKlarnaInvoice:         @{@"y": @(3), @"x": @(1)},
                                                        HPFPaymentProductCodeMaestro:               @{@"y": @(0), @"x": @(2)},
                                                        HPFPaymentProductCodeMasterCard:            @{@"y": @(0), @"x": @(0)},
                                                        HPFPaymentProductCodeNaranja:               @{@"y": @(3), @"x": @(3)},
                                                        HPFPaymentProductCodeOxxo:                  @{@"y": @(4), @"x": @(7)},
                                                        HPFPaymentProductCodePagoFacil:             @{@"y": @(4), @"x": @(0)},
                                                        HPFPaymentProductCodePayPal:                @{@"y": @(5), @"x": @(3)},
                                                        HPFPaymentProductCodePaysafecard:           @{@"y": @(2), @"x": @(8)},
                                                        HPFPaymentProductCodePayULatam:             @{@"y": @(2), @"x": @(6)},
                                                        HPFPaymentProductCodeProvincia:             @{@"y": @(3), @"x": @(6)},
                                                        HPFPaymentProductCodePrzelewy24:            @{@"y": @(2), @"x": @(4)},
                                                        HPFPaymentProductCodeQiwiWallet:            @{@"y": @(2), @"x": @(3)},
                                                        HPFPaymentProductCodeRapipago:              @{@"y": @(4), @"x": @(1)},
                                                        HPFPaymentProductCodeRipsa:                 @{@"y": @(3), @"x": @(7)},
                                                        HPFPaymentProductCodeSDD:                   @{@"y": @(6), @"x": @(1)},
                                                        HPFPaymentProductCodeSisal:                 @{@"y": @(2), @"x": @(0)},
                                                        HPFPaymentProductCodeSofortUberweisung:     @{@"y": @(0), @"x": @(8)},
                                                        HPFPaymentProductCodeTarjetaShopping:       @{@"y": @(3), @"x": @(5)},
                                                        HPFPaymentProductCodeVisa:                  @{@"y": @(0), @"x": @(1)},
                                                        HPFPaymentProductCodeWebmoneyTransfer:      @{@"y": @(2), @"x": @(2)},
                                                        HPFPaymentProductCodeYandex:                @{@"y": @(2), @"x": @(1)},
                                                        HPFPaymentProductCodeAura:                  @{@"y": @(6), @"x": @(4)},
                                                        HPFPaymentProductCodeBanamex:               @{@"y": @(6), @"x": @(5)},
                                                        HPFPaymentProductCodeBancoDoBrasil:         @{@"y": @(6), @"x": @(7)},
                                                        HPFPaymentProductCodeBBVABancomer:          @{@"y": @(6), @"x": @(6)},
                                                        HPFPaymentProductCodeBoletoBancario:        @{@"y": @(6), @"x": @(8)},
                                                        HPFPaymentProductCodeBradesco:              @{@"y": @(7), @"x": @(0)},
                                                        HPFPaymentProductCodeCaixa:                 @{@"y": @(7), @"x": @(8)},
                                                        HPFPaymentProductCodeDiscover:              @{@"y": @(7), @"x": @(1)},
                                                        HPFPaymentProductCodeItau:                  @{@"y": @(7), @"x": @(3)},
                                                        HPFPaymentProductCodeSantanderCash:         @{@"y": @(7), @"x": @(5)},
                                                        HPFPaymentProductCodeSantanderHomeBanking:  @{@"y": @(7), @"x": @(5)},
                                                        };
    }

    return HPFPaymentProductButtonPaymentProductMatrix;
}

@end
