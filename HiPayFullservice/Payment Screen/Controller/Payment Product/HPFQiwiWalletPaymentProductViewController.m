//
//  HPFQiwiWalletPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import "HPFQiwiWalletPaymentProductViewController.h"
#import "HPFOrderRequest.h"
#import "HPFForwardPaymentProductViewController_Protected.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "NSString+HPFValidation.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFQiwiWalletPaymentMethodRequest.h"

@implementation HPFQiwiWalletPaymentProductViewController

- (HPFOrderRequest *)createOrderRequest
{
    HPFOrderRequest *orderRequest = [super createOrderRequest];

    orderRequest.paymentMethod = [HPFQiwiWalletPaymentMethodRequest qiwiWalletPaymentMethodRequestWithUsername:[self textForIdentifier:@"username"]];

    return orderRequest;
}

- (BOOL)submitButtonEnabled
{
    return [[self textForIdentifier:@"username"] isDefined];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger) formSection
{
    return 0;
}

- (NSInteger) paySection
{
    return 1;
}

- (NSInteger) scanSection {
    return -1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return [super dequeuePaymentButtonCell];
    }

    HPFInputTableViewCell *cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"username"];
    
    cell.inputLabel.text = HPFLocalizedString(@"QIWI_WALLET_USERNAME_LABEL");
    cell.textField.placeholder = HPFLocalizedString(@"QIWI_WALLET_USERNAME_PLACEHOLDER");
    cell.textField.keyboardType = UIKeyboardTypePhonePad;
    
    return cell;
}

@end
