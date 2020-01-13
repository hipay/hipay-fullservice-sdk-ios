//
//  HPFUnsupportedPaymentProductViewController.m
//  Pods
//
//  Created by HiPay on 15/11/2015.
//
//

#import "HPFUnsupportedPaymentProductViewController.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFGatewayClient.h"

@interface HPFUnsupportedPaymentProductViewController ()

@end

@implementation HPFUnsupportedPaymentProductViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == (self.tableView.numberOfSections - 1)) {
        return HPFLocalizedString(@"HPF_PAYMENT_REDIRECTION_DETAILS");
    }
    
    return nil;
}

- (NSInteger) formSection
{
    return 0;
}

- (NSInteger) paySection
{
    return -1;
}

- (NSInteger) scanSection
{
    return -1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [super dequeuePaymentButtonCell];
}

- (void) savePaymentMethod:(HPFPaymentMethod *)paymentMethod {
    //no-op
}

- (void)paymentButtonTableViewCellDidTouchButton:(HPFPaymentButtonTableViewCell *)cell
{
    [self setPaymentButtonLoadingMode:YES];
    
    specificPaymentProductPaymentPageRequest = [[HPFPaymentPageRequest alloc] initWithOrderRelatedRequest:self.paymentPageRequest];
    
    specificPaymentProductPaymentPageRequest.paymentProductList = @[self.paymentProduct.code];
    specificPaymentProductPaymentPageRequest.displaySelector = NO;
    specificPaymentProductPaymentPageRequest.templateName = HPFPaymentPageRequestTemplateNameFrame;
    
    transactionLoadingRequest = [[HPFGatewayClient sharedClient] initializeHostedPaymentPageRequest:specificPaymentProductPaymentPageRequest signature:self.signature withCompletionHandler:^(HPFHostedPaymentPage *hostedPaymentPage, NSError *error) {
        
        if (hostedPaymentPage != nil) {
            
            if (hostedPaymentPage.forwardUrl != nil) {
                
                HPFForwardViewController *viewController = [HPFForwardViewController relevantForwardViewControllerWithHostedPaymentPage:hostedPaymentPage signature:self.signature];
                
                viewController.delegate = self;
                
                [self presentViewController:viewController animated:YES completion:nil];
            }
            
        }
        
        else {
            [self checkTransactionError:error];
        }
        
        [self setPaymentButtonLoadingMode:NO];
        
    }];
}

@end
