//
//  HPTIDealPaymentProductViewController.h
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import "HPTForwardPaymentProductViewController.h"

@interface HPTIDealPaymentProductViewController : HPTForwardPaymentProductViewController <UIActionSheetDelegate>
{
    NSDictionary *issuerBanks;
    NSString *selectedIssuerBank;
    
    UIActionSheet *issuerBanksActionSheet;
}

@end
