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

- (instancetype)initWithPaymentProductCode:(NSString *)paymentProductCode
{
    CGFloat height = 60.;
    
    self = [super initWithFrame:CGRectMake(0.0, 0.0, 90., height)];
    if (self) {
        _paymentProductCode = paymentProductCode;

        NSDictionary *matrixInfo = [[self paymentProductMatrix] objectForKey:paymentProductCode];
        
        if (matrixInfo != nil) {
            
            UIImage *spriteImage = [UIImage imageNamed:@"payment_product_sprites" inBundle:HPTPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];
            
            UIImage *graySpriteImage = [UIImage imageNamed:@"payment_product_sprites_gray" inBundle:HPTPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];
            
            baseImage = [self cropImage:graySpriteImage withRect:CGRectMake([matrixInfo[@"x"] floatValue] * 100. + 5., [matrixInfo[@"y"] floatValue] * height, 90., height)];
            
            selectedImage = [self cropImage:spriteImage withRect:CGRectMake([matrixInfo[@"x"] floatValue] * 100. + 5., [matrixInfo[@"y"] floatValue] * height, 90., height)];
            
            [self setImage:baseImage forState:UIControlStateNormal];
            [self setImage:selectedImage forState:UIControlStateHighlighted];
            [self setImage:selectedImage forState:UIControlStateSelected];
            
            self.layer.borderWidth = 1.0;
            self.layer.cornerRadius = 5.0;
            
            [self setDefaultStyle];
            
            [self addTarget:self action:@selector(enableButtonHighlight) forControlEvents:UIControlEventTouchDown];
            [self addTarget:self action:@selector(enableButtonHighlight) forControlEvents:UIControlEventTouchDragInside];
            [self addTarget:self action:@selector(disableButtonHighlight) forControlEvents:UIControlEventTouchUpInside];
            [self addTarget:self action:@selector(disableButtonHighlight) forControlEvents:UIControlEventTouchUpOutside];
            [self addTarget:self action:@selector(disableButtonHighlight) forControlEvents:UIControlEventTouchDragOutside];

        }
        
        else {
            return nil;
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!self.tracking) {
        [self setDefaultStyle];
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
                                                        @"3xcb":                @{@"y": @(5), @"x": @(1)},
                                                        @"3xcb-no-fees":        @{@"y": @(5), @"x": @(7)},
                                                        @"4xcb":                @{@"y": @(5), @"x": @(6)},
                                                        @"4xcb-no-fees":        @{@"y": @(5), @"x": @(8)},
                                                        @"american-express":    @{@"y": @(0), @"x": @(3)},
                                                        @"argencard":           @{@"y": @(3), @"x": @(8)},
                                                        @"baloto":              @{@"y": @(4), @"x": @(5)},
                                                        @"bank-transfer":       @{@"y": @(5), @"x": @(2)},
                                                        @"bcmc":                @{@"y": @(1), @"x": @(5)},
                                                        @"bcmc-mobile":         @{@"y": @(6), @"x": @(2)},
                                                        @"bcp":                 @{@"y": @(5), @"x": @(0)},
                                                        @"bitcoin":             @{@"y": @(5), @"x": @(4)},
                                                        @"cabal":               @{@"y": @(3), @"x": @(4)},
                                                        @"carte-accord":        @{@"y": @(6), @"x": @(0)},
                                                        @"cb":                  @{@"y": @(1), @"x": @(7)},
                                                        @"cbc-online":          @{@"y": @(0), @"x": @(7)},
                                                        @"censosud":            @{@"y": @(4), @"x": @(2)},
                                                        @"cobro-express":       @{@"y": @(3), @"x": @(2)},
                                                        @"cofinoga":            @{@"y": @(2), @"x": @(5)},
                                                        @"dexia-directnet":     @{@"y": @(1), @"x": @(4)},
                                                        @"diners":              @{@"y": @(4), @"x": @(3)},
                                                        @"efecty":              @{@"y": @(4), @"x": @(6)},
                                                        @"elo":                 @{@"y": @(4), @"x": @(4)},
                                                        @"giropay":             @{@"y": @(1), @"x": @(2)},
                                                        @"ideal":               @{@"y": @(1), @"x": @(1)},
                                                        @"ing-homepay":         @{@"y": @(1), @"x": @(0)},
                                                        @"ixe":                 @{@"y": @(4), @"x": @(8)},
                                                        @"kbc-online":          @{@"y": @(0), @"x": @(6)},
                                                        @"klarnacheckout":      @{@"y": @(2), @"x": @(7)},
                                                        @"klarnainvoice":       @{@"y": @(3), @"x": @(1)},
                                                        @"maestro":             @{@"y": @(0), @"x": @(2)},
                                                        @"mastercard":          @{@"y": @(0), @"x": @(0)},
                                                        @"naranja":             @{@"y": @(3), @"x": @(3)},
                                                        @"oxxo":                @{@"y": @(4), @"x": @(7)},
                                                        @"pago-facil":          @{@"y": @(4), @"x": @(0)},
                                                        @"paypal":              @{@"y": @(5), @"x": @(3)},
                                                        @"paysafecard":         @{@"y": @(2), @"x": @(8)},
                                                        @"payulatam":           @{@"y": @(2), @"x": @(6)},
                                                        @"provincia":           @{@"y": @(3), @"x": @(6)},
                                                        @"przelewy24":          @{@"y": @(2), @"x": @(4)},
                                                        @"qiwi-wallet":         @{@"y": @(2), @"x": @(3)},
                                                        @"rapipago":            @{@"y": @(4), @"x": @(1)},
                                                        @"ripsa":               @{@"y": @(3), @"x": @(7)},
                                                        @"sdd":                 @{@"y": @(6), @"x": @(1)},
                                                        @"sisal":               @{@"y": @(2), @"x": @(0)},
                                                        @"sofort-uberweisung":  @{@"y": @(0), @"x": @(8)},
                                                        @"tarjeta-shopping":    @{@"y": @(3), @"x": @(5)},
                                                        @"visa":                @{@"y": @(0), @"x": @(1)},
                                                        @"webmoney-transfer":   @{@"y": @(2), @"x": @(2)},
                                                        @"yandex":              @{@"y": @(2), @"x": @(1)},
                                                        };
    }

    return HPTPaymentProductButtonPaymentProductMatrix;
}

@end
