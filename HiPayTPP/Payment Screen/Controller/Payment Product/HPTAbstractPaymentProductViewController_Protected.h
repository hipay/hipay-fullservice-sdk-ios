//
//  HPTAbstractPaymentProductViewController_Protected.h
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import <HiPayTPP/HiPayTPP.h>

@interface HPTAbstractPaymentProductViewController ()

- (void)checkTransactionStatus:(HPTTransaction *)transaction;
- (void)refreshTransactionStatus:(HPTTransaction *)transaction;
- (void)checkTransactionError:(NSError *)transactionError;

- (void)editingDoneButtonTouched:(id)sender;
- (HPTInputTableViewCell *)inputCellWithIdentifier:(NSString *)identifier;
- (HPTPaymentButtonTableViewCell *)paymentButtonCell;
- (void)setPaymentButtonLoadingMode:(BOOL)isLoading;

@end
