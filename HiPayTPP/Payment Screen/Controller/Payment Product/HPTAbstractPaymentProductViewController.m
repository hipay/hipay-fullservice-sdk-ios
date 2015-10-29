//
//  AbstractPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import "HPTAbstractPaymentProductViewController.h"
#import "HPTPaymentButtonTableViewCell.h"
#import "HPTGatewayClient.h"

@interface HPTAbstractPaymentProductViewController ()

@end

@implementation HPTAbstractPaymentProductViewController

- (instancetype)initWithPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _paymentPageRequest = paymentPageRequest;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delaysContentTouches = NO;
    
    for (UIView *currentView in self.tableView.subviews) {
        if ([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PaymentScreenViews" ofType:@"bundle"]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPTPaymentButtonTableViewCell" bundle:bundle] forCellReuseIdentifier:@"PaymentButton"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0;
    }
    
    return UITableViewAutomaticDimension;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., 0., 0.);
}

- (void)setPaymentButtonLoadingMode:(BOOL)isLoading
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[HPTPaymentButtonTableViewCell class]]) {
            ((HPTPaymentButtonTableViewCell *)cell).loading = isLoading;
        }
    }
}

- (void)checkTransactionStatus:(HPTTransaction *)transaction
{
    if (transaction.handled) {
        [self.delegate paymentProductViewController:self didEndWithTransaction:transaction];
    }
    
    else if ((transaction.state == HPTTransactionStateDeclined) || (transaction.state == HPTTransactionStateError)) {
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Declined or Error" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        
    }
}

- (void)checkTransactionError:(NSError *)transactionError
{
    if ((transactionError.domain == HPTHiPayTPPErrorDomain) && (transactionError.code == HPTErrorCodeAPICheckout) && [transactionError.userInfo[HPTErrorCodeAPICodeKey] isEqualToNumber:@(HPTErrorAPIDuplicateOrder)]) {
        
        [self setPaymentButtonLoadingMode:YES];
        
        [[HPTGatewayClient sharedClient] getTransactionsWithOrderId:self.paymentPageRequest.orderId withCompletionHandler:^(NSArray *transactions, NSError *error) {

            [self setPaymentButtonLoadingMode:NO];
            
            for (HPTTransaction *aTransaction in transactions) {
                if (aTransaction.handled) {
                    [self.delegate paymentProductViewController:self didEndWithTransaction:aTransaction];
                    return;
                }
            }
            
            [self.delegate paymentProductViewController:self didFailWithError:transactionError];
        }];
    }
    
    else if ([HPTGatewayClient isTransactionErrorFinal:transactionError]) {
        [self.delegate paymentProductViewController:self didFailWithError:transactionError];
    }
    
    else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:transactionError.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
}

- (void)refreshTransactionStatus:(HPTTransaction *)transaction
{
    [self setPaymentButtonLoadingMode:YES];
    
    [[HPTGatewayClient sharedClient] getTransactionWithReference:transaction.transactionReference withCompletionHandler:^(HPTTransaction *transaction, NSError *error) {
        
        [self checkTransactionStatus:transaction];
        
        [self setPaymentButtonLoadingMode:NO];

    }];
}

@end
