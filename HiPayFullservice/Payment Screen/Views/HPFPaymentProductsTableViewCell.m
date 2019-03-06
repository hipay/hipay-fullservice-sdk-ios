//
//  HPFPaymentProductsTableViewCell.m
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import "HPFPaymentProductsTableViewCell.h"
#import "HPFGradientView.h"

#define GRADIENT_WIDTH 30

@interface HPFPaymentProductsTableViewCell()

@property (nonatomic, strong) HPFGradientView *leftGradientView;
@property (nonatomic, strong) HPFGradientView *rightGradientView;

@end

@implementation HPFPaymentProductsTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.paymentProductsCollectionView.decelerationRate = 0.993;
    
    UIColor *greyColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    UIColor *clearColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    self.leftGradientView = [[HPFGradientView alloc] initWithStartColor:greyColor endColor:clearColor];
    self.rightGradientView = [[HPFGradientView alloc] initWithStartColor:clearColor endColor:greyColor];
    
    [self addSubview:self.leftGradientView];
    [self addSubview:self.rightGradientView];
}

-(void)layoutSubviews {
    [super layoutSubviews];

    self.leftGradientView.frame = CGRectMake(0, 0, GRADIENT_WIDTH, self.bounds.size.height);
    self.rightGradientView.frame = CGRectMake(self.bounds.size.width - GRADIENT_WIDTH, 0, GRADIENT_WIDTH, self.frame.size.height);
}

@end
