//
//  AbstractPaymentProductViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTPaymentPageRequest.h"

@interface HPTAbstractPaymentProductViewController : UITableViewController

@property (nonatomic, readonly) HPTPaymentPageRequest *paymentPageRequest;

- (instancetype)initWithPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest;

@end