//
//  HPFGradientView.m
//  HiPayFullservice.common
//
//  Created by HiPay on 06/03/2019.
//

#import "HPFGradientView.h"

@interface HPFGradientView ()

@property (nonatomic, strong) CAGradientLayer* gradientLayer;
@property (nonatomic, strong) UIColor* startColor;
@property (nonatomic, strong) UIColor* endColor;

@end

@implementation HPFGradientView

-(instancetype)initWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    self = [super init];
    if (self) {
        self.startColor = startColor;
        self.endColor = endColor;
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
        self.gradientLayer.startPoint = CGPointMake(0, 0.5);
        self.gradientLayer.endPoint = CGPointMake(1, 0.5);
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
    return self;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if (@available(iOS 13.0, *)) {
        [self.traitCollection performAsCurrentTraitCollection:^{
            self.gradientLayer.colors = @[(id)self.startColor.CGColor,
                                          (id)self.endColor.CGColor];
        }];
    } else {
        // Fallback on earlier versions
    }
}

-(void)layoutSubviews {
    self.gradientLayer.frame = self.bounds;
}

@end
