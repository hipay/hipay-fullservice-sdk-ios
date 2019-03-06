//
//  HPFGradientView.m
//  HiPayFullservice.common
//
//  Created by Morgan BAUMARD on 06/03/2019.
//

#import "HPFGradientView.h"

@interface HPFGradientView ()

@property (nonatomic, strong) CAGradientLayer* gradientLayer;

@end

@implementation HPFGradientView

-(instancetype)initWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    self = [super init];
    if (self) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(id)startColor.CGColor, (id)endColor.CGColor];
        self.gradientLayer.startPoint = CGPointMake(0, 0.5);
        self.gradientLayer.endPoint = CGPointMake(1, 0.5);
        [self.layer insertSublayer:self.gradientLayer atIndex:0];
    }
    return self;
}

-(void)layoutSubviews {
    self.gradientLayer.frame = self.bounds;
}

@end
