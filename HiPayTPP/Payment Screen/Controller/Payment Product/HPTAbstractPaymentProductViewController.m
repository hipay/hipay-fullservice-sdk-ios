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
#import "HPTAbstractPaymentProductViewController_Protected.h"

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
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    for (UIView *currentView in self.tableView.subviews) {
        if ([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PaymentScreenViews" ofType:@"bundle"]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPTPaymentButtonTableViewCell" bundle:bundle] forCellReuseIdentifier:@"PaymentButton"];

    [self.tableView registerNib:[UINib nibWithNibName:@"HPTInputTableViewCell" bundle:bundle] forCellReuseIdentifier:@"Input"];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 30.0;
//    }
    
    return UITableViewAutomaticDimension;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., 0., 0.);
    
}

- (void)setPaymentButtonLoadingMode:(BOOL)isLoading
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[HPTPaymentButtonTableViewCell class]]) {
            ((HPTPaymentButtonTableViewCell *)cell).loading = isLoading;
        }
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [activeTextField resignFirstResponder];
    [self setAppropriateScrollingMode];
    
}

#pragma mark - Form

- (void)editingDoneButtonTouched:(id)sender
{
    [activeTextField resignFirstResponder];
}

- (HPTInputTableViewCell *)cellWithTextField:(UITextField *)textField
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[HPTInputTableViewCell class]]) {
            if (((HPTInputTableViewCell *)cell).textField == textField) {
                return (HPTInputTableViewCell *) cell;
            }
        }
    }
    
    return nil;
}

- (HPTInputTableViewCell *)inputCellWithIdentifier:(NSString *)identifier
{
    HPTInputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Input"];
    
    cell.textField.delegate = self;
    cell.textField.inputAccessoryView = nil;
    
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:[self cellWithTextField:textField]];

    [self setAppropriateScrollingMode];

    if (indexPath != nil) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (activeTextField == textField) {
        activeTextField = nil;
    }
    
    [self setAppropriateScrollingMode];
}

- (void)setAppropriateScrollingMode
{
    if ((activeTextField != nil) || (self.tableView.contentSize.height <= self.tableView.frame.size.height)) {
        self.tableView.scrollEnabled = NO;
    }
    
    else {
        self.tableView.scrollEnabled = YES;
    }
    self.tableView.scrollEnabled = YES;
}

#pragma mark - Transaction results, errors

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
