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
#import "HPTPaymentScreenUtils.h"
#import "HPTIDealPaymentMethodRequest.h"

@implementation HPTIDealPaymentProductViewController

-(instancetype)initWithPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest andSelectedPaymentProduct:(HPTPaymentProduct *)paymentProduct
{
    self = [super initWithPaymentPageRequest:paymentPageRequest andSelectedPaymentProduct:paymentProduct];
    if (self) {
        issuerBanks = [HPTIDealPaymentMethodRequest issuerBanks];
        
        issuerBanksActionSheet = [[UIActionSheet alloc] initWithTitle:HPTLocalizedString(@"IDEAL_BANK") delegate:self cancelButtonTitle:HPTLocalizedString(@"CANCEL") destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *key in issuerBanks.allKeys) {
            [issuerBanksActionSheet addButtonWithTitle:[issuerBanks objectForKey:key]];
        }
        
        issuerBanksActionSheet.cancelButtonIndex = 0;

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
        [issuerBanksActionSheet showInView:self.view];
        
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
        return [super dequeuePaymentButtonCell];
    }
    
    HPTLabelTableViewCell *cell = [self dequeueLabelCell];
    
    cell.inputLabel.text = HPTLocalizedString(@"IDEAL_BANK");
    
    NSString *issuerBankName = [issuerBanks objectForKey:selectedIssuerBank];
    
    if (issuerBankName != nil) {
        cell.infoLabel.text = issuerBankName;
    } else {
        cell.infoLabel.text = HPTLocalizedString(@"TAP_TO_DEFINE");
    }
    
    return cell;
}

@end
