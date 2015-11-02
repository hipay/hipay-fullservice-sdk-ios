//
//  HPTTokenizableCardPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 02/11/2015.
//
//

#import "HPTTokenizableCardPaymentProductViewController.h"
#import "HPTOrderRequest.h"
#import "HPTForwardPaymentProductViewController_Protected.h"
#import "HPTAbstractPaymentProductViewController_Protected.h"
#import "NSString+HPTValidation.h"
#import "HPTPaymentScreenLocalization.h"
#import "HPTQiwiWalletPaymentMethodRequest.h"

@interface HPTTokenizableCardPaymentProductViewController ()

@end

@implementation HPTTokenizableCardPaymentProductViewController

- (HPTOrderRequest *)createOrderRequest
{
    HPTOrderRequest *orderRequest = [super createOrderRequest];
    
    orderRequest.paymentMethod = [HPTQiwiWalletPaymentMethodRequest qiwiWalletPaymentMethodRequestWithUsername:[self textForIdentifier:@"username"]];
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return [super dequeuePaymentButtonCell];
    }
    
    HPTInputTableViewCell *cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"username"];
    
    cell.inputLabel.text = HPTLocalizedString(@"QIWI_WALLET_USERNAME_LABEL");
    cell.textField.placeholder = HPTLocalizedString(@"QIWI_WALLET_USERNAME_PLACEHOLDER");
    cell.textField.keyboardType = UIKeyboardTypePhonePad;
    
    return cell;
}
@end
