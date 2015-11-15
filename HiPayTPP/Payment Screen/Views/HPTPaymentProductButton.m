//
//  HPTPaymentProductButton.m
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import "HPTPaymentProductButton.h"
#import "HPTPaymentScreenUtils.h"

NSDictionary *HPTPaymentProductButtonPaymentProductMatrix;

@implementation HPTPaymentProductButton

- (instancetype)initWithPaymentProduct:(HPTPaymentProduct *)paymentProduct
{
    CGFloat height = 60.;
    
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 90., height)];
    if (self) {
        _paymentProduct = paymentProduct.code;

        NSDictionary *matrixInfo = [[self paymentProductMatrix] objectForKey:paymentProduct.code];
        
        if (matrixInfo != nil) {
            
            UIImage *spriteImage = [UIImage imageNamed:@"payment_product_sprites" inBundle:HPTPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];
            
            UIImage *graySpriteImage = [UIImage imageNamed:@"payment_product_sprites_gray" inBundle:HPTPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];
            
            baseImage = [self cropImage:graySpriteImage withRect:CGRectMake([matrixInfo[@"x"] floatValue] * 100. + 5., [matrixInfo[@"y"] floatValue] * height, 90., height)];
            
            selectedImage = [self cropImage:spriteImage withRect:CGRectMake([matrixInfo[@"x"] floatValue] * 100. + 5., [matrixInfo[@"y"] floatValue] * height, 90., height)];
            
            [self setImage:baseImage forState:UIControlStateNormal];
            [self setImage:selectedImage forState:UIControlStateHighlighted];
            [self setImage:selectedImage forState:UIControlStateSelected];
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

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!self.tracking) {
        [self setDefaultStyle];
    }
    
    if (self.titleLabel.frame.size.height >= (0.85 * self.frame.size.height)) {
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
}

- (void)setDefaultStyle
{
    if (!self.selected) {
        self.layer.borderColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.88 alpha:1.0].CGColor;
        self.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
        self.imageView.alpha = 0.6;
    } else {
        self.layer.borderColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.0].CGColor;
        self.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
        self.imageView.alpha = 1.0;
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
    if (HPTPaymentProductButtonPaymentProductMatrix == nil) {
        HPTPaymentProductButtonPaymentProductMatrix = @{
                                                        HPTPaymentProductCode3xcb:                  @{@"y": @(5), @"x": @(1)},
                                                        HPTPaymentProductCode3xcbNoFees:            @{@"y": @(5), @"x": @(7)},
                                                        HPTPaymentProductCode4xcb:                  @{@"y": @(5), @"x": @(6)},
                                                        HPTPaymentProductCode4xcbNoFees:            @{@"y": @(5), @"x": @(8)},
                                                        HPTPaymentProductCodeAmericanExpress:       @{@"y": @(0), @"x": @(3)},
                                                        HPTPaymentProductCodeArgencard:             @{@"y": @(3), @"x": @(8)},
                                                        HPTPaymentProductCodeBaloto:                @{@"y": @(4), @"x": @(5)},
                                                        HPTPaymentProductCodeBankTransfer:          @{@"y": @(5), @"x": @(2)},
                                                        HPTPaymentProductCodeBCMC:                  @{@"y": @(1), @"x": @(5)},
                                                        HPTPaymentProductCodeBCMCMobile:            @{@"y": @(6), @"x": @(2)},
                                                        HPTPaymentProductCodeBCP:                   @{@"y": @(5), @"x": @(0)},
                                                        HPTPaymentProductCodeBitcoin:               @{@"y": @(5), @"x": @(4)},
                                                        HPTPaymentProductCodeCabal:                 @{@"y": @(3), @"x": @(4)},
                                                        HPTPaymentProductCodeCarteAccord:           @{@"y": @(6), @"x": @(0)},
                                                        HPTPaymentProductCodeCB:                    @{@"y": @(1), @"x": @(7)},
                                                        HPTPaymentProductCodeCBCOnline:             @{@"y": @(0), @"x": @(7)},
                                                        HPTPaymentProductCodeCensosud:              @{@"y": @(4), @"x": @(2)},
                                                        HPTPaymentProductCodeCobroExpress:          @{@"y": @(3), @"x": @(2)},
                                                        HPTPaymentProductCodeCofinoga:              @{@"y": @(2), @"x": @(5)},
                                                        HPTPaymentProductCodeDexiaDirectNet:        @{@"y": @(1), @"x": @(4)},
                                                        HPTPaymentProductCodeDiners:                @{@"y": @(4), @"x": @(3)},
                                                        HPTPaymentProductCodeEfecty:                @{@"y": @(4), @"x": @(6)},
                                                        HPTPaymentProductCodeElo:                   @{@"y": @(4), @"x": @(4)},
                                                        HPTPaymentProductCodeGiropay:               @{@"y": @(1), @"x": @(2)},
                                                        HPTPaymentProductCodeIDEAL:                 @{@"y": @(1), @"x": @(1)},
                                                        HPTPaymentProductCodeINGHomepay:            @{@"y": @(1), @"x": @(0)},
                                                        HPTPaymentProductCodeIxe:                   @{@"y": @(4), @"x": @(8)},
                                                        HPTPaymentProductCodeKBCOnline:             @{@"y": @(0), @"x": @(6)},
                                                        HPTPaymentProductCodeKlarnacheckout:        @{@"y": @(2), @"x": @(7)},
                                                        HPTPaymentProductCodeKlarnaInvoice:         @{@"y": @(3), @"x": @(1)},
                                                        HPTPaymentProductCodeMaestro:               @{@"y": @(0), @"x": @(2)},
                                                        HPTPaymentProductCodeMasterCard:            @{@"y": @(0), @"x": @(0)},
                                                        HPTPaymentProductCodeNaranja:               @{@"y": @(3), @"x": @(3)},
                                                        HPTPaymentProductCodeOxxo:                  @{@"y": @(4), @"x": @(7)},
                                                        HPTPaymentProductCodePagoFacil:             @{@"y": @(4), @"x": @(0)},
                                                        HPTPaymentProductCodePayPal:                @{@"y": @(5), @"x": @(3)},
                                                        HPTPaymentProductCodePaysafecard:           @{@"y": @(2), @"x": @(8)},
                                                        HPTPaymentProductCodePayulatam:             @{@"y": @(2), @"x": @(6)},
                                                        HPTPaymentProductCodeProvincia:             @{@"y": @(3), @"x": @(6)},
                                                        HPTPaymentProductCodePrzelewy24:            @{@"y": @(2), @"x": @(4)},
                                                        HPTPaymentProductCodeQiwiWallet:            @{@"y": @(2), @"x": @(3)},
                                                        HPTPaymentProductCodeRapipago:              @{@"y": @(4), @"x": @(1)},
                                                        HPTPaymentProductCodeRipsa:                 @{@"y": @(3), @"x": @(7)},
                                                        HPTPaymentProductCodeSDD:                   @{@"y": @(6), @"x": @(1)},
                                                        HPTPaymentProductCodeSisal:                 @{@"y": @(2), @"x": @(0)},
                                                        HPTPaymentProductCodeSofortUberweisung:     @{@"y": @(0), @"x": @(8)},
                                                        HPTPaymentProductCodeTarjetaShopping:       @{@"y": @(3), @"x": @(5)},
                                                        HPTPaymentProductCodeVisa:                  @{@"y": @(0), @"x": @(1)},
                                                        HPTPaymentProductCodeWebmoneyTransfer:      @{@"y": @(2), @"x": @(2)},
                                                        HPTPaymentProductCodeYandex:                @{@"y": @(2), @"x": @(1)},
                                                        };
    }

    return HPTPaymentProductButtonPaymentProductMatrix;
}

@end
