//
//  HPTIDealPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import "HPTIDealPaymentProductViewController.h"
#import "HPTOrderRequest.h"
#import "HPTForwardPaymentProductViewController_Protected.h"
#import "HPTAbstractPaymentProductViewController_Protected.h"
#import "NSString+HPTValidation.h"
#import "HPTLabelTableViewCell.h"

@implementation HPTIDealPaymentProductViewController

-(instancetype)initWithPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest andSelectedPaymentProduct:(HPTPaymentProduct *)paymentProduct
{
    self = [super initWithPaymentPageRequest:paymentPageRequest andSelectedPaymentProduct:paymentProduct];
    if (self) {
        issuerBanks = [HPTIDealPaymentMethodRequest issuerBanks];
    }
    return self;
}

- (HPTOrderRequest *)createOrderRequest
{
    HPTOrderRequest *orderRequest = [super createOrderRequest];
    
    orderRequest.paymentMethod = [HPTIDealPaymentMethodRequest iDealPaymentMethodRequestWithIssuerBankId:selectedIssuerBank];
    
    return orderRequest;
}

- (BOOL)submitButtonEnabled
{
    return selectedIssuerBank != nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section) == 0 && (indexPath.row == 0)) {

        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Banque" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *key in issuerBanks.allKeys) {
            [actionSheet addButtonWithTitle:[issuerBanks objectForKey:key]];
        }
        
        actionSheet.cancelButtonIndex = 0;
        
        [actionSheet showInView:self.view];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        BOOL shouldRefresh = selectedIssuerBank == nil;
        selectedIssuerBank = [issuerBanks.allKeys objectAtIndex:(buttonIndex - 1)];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
        if (shouldRefresh) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    HPTLabelTableViewCell *cell = [self dequeueLabelCell];
    
    cell.inputLabel.text = @"Banque";
    
    NSString *issuerBankName = [issuerBanks objectForKey:selectedIssuerBank];
    
    if (issuerBankName != nil) {
        cell.infoLabel.text = issuerBankName;
    } else {
        cell.infoLabel.text = @"Touchez pour définir";
    }
    
    return cell;
}

@end
