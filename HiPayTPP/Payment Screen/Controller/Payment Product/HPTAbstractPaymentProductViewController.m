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
        fieldIdentifiers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self determineScrollingMode];

    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PaymentScreenViews" ofType:@"bundle"]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPTPaymentButtonTableViewCell" bundle:bundle] forCellReuseIdentifier:@"PaymentButton"];

    [self.tableView registerNib:[UINib nibWithNibName:@"HPTInputTableViewCell" bundle:bundle] forCellReuseIdentifier:@"Input"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [activeTextField resignFirstResponder];
}

- (void)determineScrollingMode
{
    if ((self.tableView.contentSize.height <= self.tableView.frame.size.height) && ((activeTextField == nil) || (!activeTextField.editing))) {
        self.tableView.scrollEnabled = NO;
    }
    
    else {
        self.tableView.scrollEnabled = YES;
    }
}

- (void)didRotate:(NSNotification *)notification
{
    [self determineScrollingMode];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard related methods

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationDuration animations:^{

        if (activeTextField != nil) {
            UITableViewCell *cell = [self cellWithTextField:activeTextField];
            
            if (cell != nil) {
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                
                if (indexPath != nil) {
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }
            }
        }
    
    }];
}

#pragma mark - Form

- (void)setPaymentButtonLoadingMode:(BOOL)isLoading
{
    loading = isLoading;
    
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[HPTPaymentButtonTableViewCell class]]) {
            ((HPTPaymentButtonTableViewCell *)cell).loading = isLoading;
        }
        
        if ([cell isKindOfClass:[HPTInputTableViewCell class]]) {
            ((HPTInputTableViewCell *)cell).textField.enabled = !isLoading;
        }
    }
}

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

- (HPTInputTableViewCell *)inputCellWithIdentifier:(NSString *)identifier fieldIdentifier:(NSString *)fieldIdentifier
{
    HPTInputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Input"];
    
    cell.textField.delegate = self;
    cell.textField.inputAccessoryView = nil;
    cell.textField.enabled = !loading;
    
    cell.textField.text = [[fieldIdentifiers objectForKey:fieldIdentifier] text];

    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [fieldIdentifiers setObject:cell.textField forKey:fieldIdentifier];
    
    return cell;
}

- (HPTPaymentButtonTableViewCell *)paymentButtonCell
{
    HPTPaymentButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PaymentButton"];

    cell.loading = loading;
    cell.enabled = [self submitButtonEnabled];
    
    return cell;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
    [self determineScrollingMode];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (activeTextField == textField) {
        activeTextField = nil;
    }

    [self determineScrollingMode];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[HPTPaymentButtonTableViewCell class]]) {
            ((HPTPaymentButtonTableViewCell *)cell).enabled = [self submitButtonEnabled];
        }
    }
}

- (NSString *)textForIdentifier:(NSString *)fieldIdentifier
{
    return [[fieldIdentifiers objectForKey:fieldIdentifier] text];
}

- (BOOL)submitButtonEnabled
{
    return YES;
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
