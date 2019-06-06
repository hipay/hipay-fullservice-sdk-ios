//
//  HPFIDealPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import "HPFIDealPaymentProductViewController.h"
#import "HPFOrderRequest.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFIDealPaymentMethodRequest.h"

@implementation HPFIDealPaymentProductViewController

-(instancetype)initWithPaymentPageRequest:(HPFPaymentPageRequest *)paymentPageRequest signature:(NSString *)signature andSelectedPaymentProduct:(HPFPaymentProduct *)paymentProduct
{
    self = [super initWithPaymentPageRequest:paymentPageRequest signature:signature andSelectedPaymentProduct:paymentProduct];
    if (self) {
        issuerBanks = [HPFIDealPaymentMethodRequest issuerBanks];
        
        
        
        
        issuerBanksActionSheet = [UIAlertController alertControllerWithTitle:HPFLocalizedString(@"HPF_IDEAL_BANK")
                                                                  message:nil
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelButton = [UIAlertAction
                                        actionWithTitle:HPFLocalizedString(@"HPF_ERROR_BUTTON_DISMISS")
                                        style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction * action) {
                                            
                                        }];
        
        [issuerBanksActionSheet addAction:cancelButton];
        
        UIAlertAction *action;
        
        int index = 0;
        for (NSString *key in issuerBanks.allKeys) {
            
            action = [UIAlertAction
                                           actionWithTitle:[issuerBanks objectForKey:key]
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                                               
                                               BOOL shouldRefresh = self->selectedIssuerBank == nil;
                                               //selectedIssuerBank = [issuerBanks.allKeys objectAtIndex:(buttonIndex - 1)];
                                               
                                               self->selectedIssuerBank = [self->issuerBanks.allKeys objectAtIndex:index];
                                               
                                               [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                                               
                                               if (shouldRefresh) {
                                                   [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                                               }
                                               
                                           }];
            
            [issuerBanksActionSheet addAction:action];

            index++;
        }
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
        
        [self presentViewController:issuerBanksActionSheet animated:YES completion:nil];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    HPFLabelTableViewCell *cell = [self dequeueLabelCell];
    
    cell.inputLabel.text = HPFLocalizedString(@"HPF_IDEAL_BANK");
    
    NSString *issuerBankName = [issuerBanks objectForKey:selectedIssuerBank];
    
    if (issuerBankName != nil) {
        cell.infoLabel.text = issuerBankName;
    } else {
        cell.infoLabel.text = HPFLocalizedString(@"HPF_TAP_TO_DEFINE");
    }
    
    return cell;
}

@end
