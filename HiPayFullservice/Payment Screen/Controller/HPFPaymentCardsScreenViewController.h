//
//  HPFPaymentCardsScreenViewController.h
//  Pods
//
//  Created by HiPay on 25/10/2016.
//
//

#import <UIKit/UIKit.h>
#import "HPFPaymentButtonTableViewCell.h"
#import "HPFTransactionRequestResponseManager.h"

@class HPFPaymentPageRequest;
@protocol HPFPaymentProductViewControllerDelegate;

@interface HPFPaymentCardsScreenViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HPFPaymentButtonTableViewCellDelegate, HPFTransactionRequestResponseManagerDelegate>

@property (nonatomic, strong) HPFPaymentPageRequest *paymentPageRequest;
@property (nonatomic, strong) NSString *signature;

@property (nonatomic, weak) id<HPFPaymentProductViewControllerDelegate> delegate;

- (void)cancelRequests;

@end
