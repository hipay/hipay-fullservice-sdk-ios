//
//  HPFSepaDirectDebitPaymentProductViewController.m
//  Pods
//
//  Created by Morgan BAUMARD on 21/12/2018.
//

#import "HPFSepaDirectDebitPaymentProductViewController.h"
#import "HPFOrderRequest.h"
#import "HPFSepaDirectDebitPaymentMethodRequest.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "NSString+HPFValidation.h"

@implementation HPFSepaDirectDebitPaymentProductViewController

- (HPFOrderRequest *)createOrderRequest
{
    HPFOrderRequest *orderRequest = [super createOrderRequest];
    
    orderRequest.paymentMethod = [HPFSepaDirectDebitPaymentMethodRequest sepaDirectDebitPaymentMethodRequestWithfirstname:[self textForIdentifier:@"firstname"]
                                                                                                                 lastname:[self textForIdentifier:@"lastname"]
                                                                                                                     iban:[self textForIdentifier:@"iban"]
                                                                                                         recurringPayment:0];
    
    return orderRequest;
}

- (BOOL)submitButtonEnabled
{
    return [[self textForIdentifier:@"firstname"] isDefined] && [[self textForIdentifier:@"lastname"] isDefined] && [[self textForIdentifier:@"iban"] isDefined];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else {
        return 1;
    }
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

    if (indexPath.row == 0) {
        HPFInputTableViewCell *cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"firstname"];
        
        cell.inputLabel.text = @"Firstname";
        cell.textField.placeholder = @"John";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        
        return cell;
    }
    else if (indexPath.row == 1) {
        HPFInputTableViewCell *cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"lastname"];
        
        cell.inputLabel.text = @"Lastname";
        cell.textField.placeholder = @"Doe";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        
        return cell;
    }
    else if (indexPath.row == 2) {
        HPFInputTableViewCell *cell = [self dequeueInputCellWithIdentifier:@"Input" fieldIdentifier:@"iban"];
        
        cell.inputLabel.text = @"IBAN";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        
        return cell;
    }
    
    return nil;
}

@end
