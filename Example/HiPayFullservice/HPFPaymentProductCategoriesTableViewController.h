//
//  HPFPaymentProductCategoriesTableViewController.h
//  HiPayFullservice
//
//  Created by HiPay on 29/11/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPFPaymentProductCategoriesTableViewController : UITableViewController
{
    NSMutableSet *selectedPaymentProducts;
}

@property (nonatomic, readonly) NSSet *selectedPaymentProducts;

- (instancetype)initWithSelectedPaymentProducts:(NSSet *)selectedPaymentProducts;

@end
