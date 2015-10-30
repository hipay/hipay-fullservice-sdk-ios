//
//  HPTQiwiWalletPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import "HPTQiwiWalletPaymentProductViewController.h"
#import "HPTOrderRequest.h"
#import "HPTForwardPaymentProductViewController_Protected.h"
#import "HPTAbstractPaymentProductViewController_Protected.h"

@implementation HPTQiwiWalletPaymentProductViewController

- (HPTOrderRequest *)createOrderRequest
{
    HPTOrderRequest *orderRequest = [super createOrderRequest];
    
    orderRequest.paymentMethod = [HPTQiwiWalletPaymentMethodRequest qiwiWalletPaymentMethodRequestUsername:@"+33678787484"];

    return orderRequest;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }

    HPTInputTableViewCell *cell = [self inputCellWithIdentifier:@"Input"];
    
    cell.inputLabel.text = @"N° de téléphone";
    cell.textField.placeholder = @"+79263745223";
    cell.textField.keyboardType = UIKeyboardTypePhonePad;
    
    return cell;
}

@end
