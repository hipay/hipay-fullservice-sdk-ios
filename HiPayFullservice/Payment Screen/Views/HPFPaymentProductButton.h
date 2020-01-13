//
//  HPFPaymentProductButton.h
//  Pods
//
//  Created by HiPay on 26/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPFPaymentProduct.h"

@interface HPFPaymentProductButton : UIButton
{
    UIImage *baseImage;
    UIImage *selectedImage;
    UIColor *cellColor;
    UIColor *defaultTintColor;
}

@property (nonatomic, readonly) NSString *paymentProduct;

- (instancetype)initWithPaymentProduct:(HPFPaymentProduct *)paymentProduct;

@end
