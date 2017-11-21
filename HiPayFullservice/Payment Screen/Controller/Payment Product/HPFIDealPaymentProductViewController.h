//
//  HPFIDealPaymentProductViewController.h
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import "HPFForwardPaymentProductViewController.h"

@interface HPFIDealPaymentProductViewController : HPFForwardPaymentProductViewController <UIActionSheetDelegate>
{
    NSDictionary *issuerBanks;
    NSString *selectedIssuerBank;
    
    //UIActionSheet *issuerBanksActionSheet;
    UIAlertController *issuerBanksActionSheet;
}

@end
