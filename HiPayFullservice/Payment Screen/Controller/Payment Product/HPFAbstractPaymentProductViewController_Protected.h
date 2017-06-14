//
//  HPFAbstractPaymentProductViewController_Protected.h
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import "HPFLabelTableViewCell.h"
#import "HPFAbstractPaymentProductViewController.h"
#import "HPFOrderRequest.h"

@interface HPFAbstractPaymentProductViewController ()

- (void)checkTransactionStatus:(HPFTransaction *)transaction;
- (void)checkTransactionError:(NSError *)transactionError;

- (void)editingDoneButtonTouched:(id)sender;
- (HPFPaymentButtonTableViewCell *)dequeuePaymentButtonCell;
- (void)setPaymentButtonLoadingMode:(BOOL)isLoading;
- (NSString *)textForIdentifier:(NSString *)fieldIdentifier;
- (HPFInputTableViewCell *)dequeueInputCellWithIdentifier:(NSString *)identifier fieldIdentifier:(NSString *)fieldIdentifier;
- (HPFLabelTableViewCell *)dequeueLabelCell;
- (HPFLabelTableViewCell *)dequeueApplePayCell;
- (HPFOrderRequest *)createOrderRequest;
- (BOOL)submitButtonEnabled;
- (void)performOrderRequest:(HPFOrderRequest *)orderRequest signature:(NSString *)signature;
- (void)textFieldDidChange:(UITextField *)textField;
- (UITextField *)textFieldForIdentifier:(NSString *)fieldIdentifier;
- (HPFInputTableViewCell *)cellWithTextField:(UITextField *)textField;
- (void)submit;

@end
