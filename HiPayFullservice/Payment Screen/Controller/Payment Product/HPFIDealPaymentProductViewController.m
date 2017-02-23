//
//  HPFIDealPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import "HPFIDealPaymentProductViewController.h"
#import "HPFOrderRequest.h"
#import "HPFForwardPaymentProductViewController_Protected.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "NSString+HPFValidation.h"
#import "HPFLabelTableViewCell.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFIDealPaymentMethodRequest.h"

@implementation HPFIDealPaymentProductViewController

-(instancetype)initWithPaymentPageRequest:(HPFPaymentPageRequest *)paymentPageRequest signature:(NSString *)signature andSelectedPaymentProduct:(HPFPaymentProduct *)paymentProduct
{
    self = [super initWithPaymentPageRequest:paymentPageRequest signature:signature andSelectedPaymentProduct:paymentProduct];
    if (self) {
        issuerBanks = [HPFIDealPaymentMethodRequest issuerBanks];
        
        issuerBanksActionSheet = [[UIActionSheet alloc] initWithTitle:HPFLocalizedString(@"IDEAL_BANK") delegate:self cancelButtonTitle:HPFLocalizedString(@"CANCEL") destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *key in issuerBanks.allKeys) {
            [issuerBanksActionSheet addButtonWithTitle:[issuerBanks objectForKey:key]];
        }
        
        issuerBanksActionSheet.cancelButtonIndex = 0;

    }
    return self;
}

- (HPFOrderRequest *)createOrderRequest
{
    HPFOrderRequest *orderRequest = [super createOrderRequest];
    
    orderRequest.paymentMethod = [HPFIDealPaymentMethodRequest iDealPaymentMethodRequestWithIssuerBankId:selectedIssuerBank];
    
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

- (NSInteger) formSection
{
    return 0;
}

- (NSInteger) paySection
{
    return 1;
}

- (NSInteger) scanSection {
    //no-op
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return [super dequeuePaymentButtonCell];
    }
    
    HPFLabelTableViewCell *cell = [self dequeueLabelCell];
    
    cell.inputLabel.text = HPFLocalizedString(@"IDEAL_BANK");
    
    NSString *issuerBankName = [issuerBanks objectForKey:selectedIssuerBank];
    
    if (issuerBankName != nil) {
        cell.infoLabel.text = issuerBankName;
    } else {
        cell.infoLabel.text = HPFLocalizedString(@"TAP_TO_DEFINE");
    }
    
    return cell;
}

@end
