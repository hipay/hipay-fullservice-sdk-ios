//
//  HPTPaymentScreenViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTGatewayClient.h"

@interface HPTPaymentScreenViewController : UINavigationController

@property (nonatomic, readonly) HPTPaymentPageRequest *paymentPageRequest;

- (void)loadPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest;

@end
