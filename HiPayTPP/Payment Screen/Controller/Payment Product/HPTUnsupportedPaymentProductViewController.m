//
//  HPTUnsupportedPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 15/11/2015.
//
//

#import "HPTUnsupportedPaymentProductViewController.h"
#import "HPTAbstractPaymentProductViewController_Protected.h"
#import "HPTPaymentScreenUtils.h"

@interface HPTUnsupportedPaymentProductViewController ()

@end

@implementation HPTUnsupportedPaymentProductViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == (self.tableView.numberOfSections - 1)) {
        return HPTLocalizedString(@"PAYMENT_REDIRECTION_DETAILS");
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [super dequeuePaymentButtonCell];
}

- (void)paymentButtonTableViewCellDidTouchButton:(HPTPaymentButtonTableViewCell *)cell
{
    [self setPaymentButtonLoadingMode:YES];
    
    specificPaymentProductPaymentPageRequest = [[HPTPaymentPageRequest alloc] initWithOrderRelatedRequest:self.paymentPageRequest];
    
    specificPaymentProductPaymentPageRequest.paymentProductCategoryList = nil;
    specificPaymentProductPaymentPageRequest.paymentProductList = @[self.paymentProduct.code];
    specificPaymentProductPaymentPageRequest.displaySelector = NO;
    specificPaymentProductPaymentPageRequest.templateName = HPTPaymentPageRequestTemplateNameFrame;
    
    [[HPTGatewayClient sharedClient] initializeHostedPaymentPageRequest:specificPaymentProductPaymentPageRequest withCompletionHandler:^(HPTHostedPaymentPage *hostedPaymentPage, NSError *error) {
        
        if (hostedPaymentPage != nil) {
            
            if (hostedPaymentPage.forwardUrl != nil) {
                
                HPTForwardViewController *viewController = [HPTForwardViewController relevantForwardViewControllerWithHostedPaymentPage:hostedPaymentPage];
                
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
