//
//  HPTAbstractPaymentProductViewController_Protected.h
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import "HPTLabelTableViewCell.h"

@interface HPTAbstractPaymentProductViewController ()

- (void)checkTransactionStatus:(HPTTransaction *)transaction;
- (void)checkTransactionError:(NSError *)transactionError;

- (void)editingDoneButtonTouched:(id)sender;
- (HPTPaymentButtonTableViewCell *)dequeuePaymentButtonCell;
- (void)setPaymentButtonLoadingMode:(BOOL)isLoading;
- (NSString *)textForIdentifier:(NSString *)fieldIdentifier;
- (HPTInputTableViewCell *)dequeueInputCellWithIdentifier:(NSString *)identifier fieldIdentifier:(NSString *)fieldIdentifier;
- (HPTLabelTableViewCell *)dequeueLabelCell;
- (HPTOrderRequest *)createOrderRequest;
- (BOOL)submitButtonEnabled;
- (void)performOrderRequest:(HPTOrderRequest *)orderRequest;
- (void)textFieldDidChange:(UITextField *)textField;
- (UITextField *)textFieldForIdentifier:(NSString *)fieldIdentifier;
- (HPTInputTableViewCell *)cellWithTextField:(UITextField *)textField;
- (void)submit;

@end
