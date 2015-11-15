//
//  HPTPaymentProductButton.h
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTPaymentProduct.h"

@interface HPTPaymentProductButton : UIButton
{
    UIImage *baseImage;
    UIImage *selectedImage;
    UIColor *cellColor;
}

@property (nonatomic, readonly) NSString *paymentProduct;

- (instancetype)initWithPaymentProduct:(HPTPaymentProduct *)paymentProduct;

@end
