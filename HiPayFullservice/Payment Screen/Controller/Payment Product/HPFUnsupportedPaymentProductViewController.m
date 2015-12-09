//
//  HPFUnsupportedPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 15/11/2015.
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
        return HPFLocalizedString(@"PAYMENT_REDIRECTION_DETAILS");
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [super dequeuePaymentButtonCell];
}

- (void)paymentButtonTableViewCellDidTouchButton:(HPFPaymentButtonTableViewCell *)cell
{
    [self setPaymentButtonLoadingMode:YES];
    
    specificPaymentProductPaymentPageRequest = [[HPFPaymentPageRequest alloc] initWithOrderRelatedRequest:self.paymentPageRequest];
    
    specificPaymentProductPaymentPageRequest.paymentProductCategoryList = nil;
    specificPaymentProductPaymentPageRequest.paymentProductList = @[self.paymentProduct.code];
    specificPaymentProductPaymentPageRequest.displaySelector = NO;
    specificPaymentProductPaymentPageRequest.templateName = HPFPaymentPageRequestTemplateNameFrame;
    
    transactionLoadingRequest = [[HPFGatewayClient sharedClient] initializeHostedPaymentPageRequest:specificPaymentProductPaymentPageRequest withCompletionHandler:^(HPFHostedPaymentPage *hostedPaymentPage, NSError *error) {
        
        if (hostedPaymentPage != nil) {
            
            if (hostedPaymentPage.forwardUrl != nil) {
                
                HPFForwardViewController *viewController = [HPFForwardViewController relevantForwardViewControllerWithHostedPaymentPage:hostedPaymentPage];
                
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
