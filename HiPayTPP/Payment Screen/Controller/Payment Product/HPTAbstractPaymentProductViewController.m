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
#import "HPTLabelTableViewCell.h"
#import "HPTPaymentScreenUtils.h"
#import "HPTForwardViewController.h"

@interface HPTAbstractPaymentProductViewController ()

@end

@implementation HPTAbstractPaymentProductViewController

- (instancetype)initWithPaymentPageRequest:(HPTPaymentPageRequest *)paymentPageRequest andSelectedPaymentProduct:(HPTPaymentProduct *)paymentProduct
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _paymentPageRequest = paymentPageRequest;
        fieldIdentifiers = [NSMutableDictionary dictionary];
        _paymentProduct = paymentProduct;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPTPaymentButtonTableViewCell" bundle:HPTPaymentScreenViewsBundle()] forCellReuseIdentifier:@"PaymentButton"];

    [self.tableView registerNib:[UINib nibWithNibName:@"HPTInputTableViewCell" bundle:HPTPaymentScreenViewsBundle()] forCellReuseIdentifier:@"Input"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPTCardNumberInputTableViewCell" bundle:HPTPaymentScreenViewsBundle()] forCellReuseIdentifier:@"CardNumberInput"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPTExpiryDateInputTableViewCell" bundle:HPTPaymentScreenViewsBundle()] forCellReuseIdentifier:@"ExpiryDateInput"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPTSecurityCodeInputTableViewCell" bundle:HPTPaymentScreenViewsBundle()] forCellReuseIdentifier:@"SecurityCodeInput"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPTLabelTableViewCell" bundle:HPTPaymentScreenViewsBundle()] forCellReuseIdentifier:@"Label"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPTLabelTableViewCell" bundle:HPTPaymentScreenViewsBundle()] forCellReuseIdentifier:@"Label"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self determineScrollingMode];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [activeTextField resignFirstResponder];
    [self determineScrollingMode];
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
    NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{

        if (activeTextField != nil) {
            UITableViewCell *cell = [self cellWithTextField:activeTextField];
            
            if (cell != nil) {
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                
                UITableViewScrollPosition position = UITableViewScrollPositionMiddle;
                
                // Last row of section before payment button; scroll to top
                if ((indexPath.section == (self.tableView.numberOfSections - 2)) && (indexPath.row == ([self.tableView numberOfRowsInSection:indexPath.section] - 1))) {
                    
                    position = UITableViewScrollPositionTop;
                }
                
                if (indexPath != nil) {
                    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:NO];
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
    
    [self.delegate paymentProductViewController:self isLoading:isLoading];
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

- (UITextField *)textFieldForIdentifier:(NSString *)fieldIdentifier
{
    return [fieldIdentifiers objectForKey:fieldIdentifier];
}

- (BOOL)submitButtonEnabled
{
    return YES;
}

#pragma mark - Dequeue helper


- (HPTInputTableViewCell *)dequeueInputCellWithIdentifier:(NSString *)identifier fieldIdentifier:(NSString *)fieldIdentifier
{
    HPTInputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.textField.delegate = self;
    cell.textField.inputAccessoryView = nil;
    cell.textField.enabled = !loading;
    
    cell.textField.text = [[fieldIdentifiers objectForKey:fieldIdentifier] text];
    
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [fieldIdentifiers setObject:cell.textField forKey:fieldIdentifier];
    
    return cell;
}

- (HPTLabelTableViewCell *)dequeueLabelCell
{
    HPTLabelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Label"];
    
    return cell;
}

- (HPTPaymentButtonTableViewCell *)dequeuePaymentButtonCell
{
    HPTPaymentButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PaymentButton"];
    
    cell.loading = loading;
    cell.enabled = [self submitButtonEnabled];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - Transaction results, errors

- (void)checkTransactionStatus:(HPTTransaction *)theTransaction
{
    if (theTransaction.handled) {
        [self.delegate paymentProductViewController:self didEndWithTransaction:theTransaction];
    }
    
    else if (theTransaction.state == HPTTransactionStateDeclined) {
        [[[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED") delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }
    
    else if (theTransaction.state == HPTTransactionStateError) {
        [[[UIAlertView alloc] initWithTitle:HPTLocalizedString(@"TRANSACTION_ERROR_DECLINED_TITLE") message:HPTLocalizedString(@"TRANSACTION_ERROR_OTHER") delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
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

- (void)refreshTransactionStatus:(HPTTransaction *)theTransaction
{
    [self setPaymentButtonLoadingMode:YES];
    
    [[HPTGatewayClient sharedClient] getTransactionWithReference:theTransaction.transactionReference withCompletionHandler:^(HPTTransaction *theTransaction, NSError *error) {
        
        [self checkTransactionStatus:theTransaction];
        
        [self setPaymentButtonLoadingMode:NO];

    }];
}

#pragma mark - Forward controller

- (void)forwardViewControllerDidCancel:(HPTForwardViewController *)viewController
{
    [self refreshTransactionStatus:transaction];
}

- (void)forwardViewController:(HPTForwardViewController *)viewController didEndWithTransaction:(HPTTransaction *)theTransaction
{
    [self checkTransactionStatus:theTransaction];
}

- (void)forwardViewController:(HPTForwardViewController *)viewController didFailWithError:(NSError *)error
{
    [self checkTransactionError:error];
}

#pragma mark - Payment workflow

- (HPTOrderRequest *)createOrderRequest
{
    HPTOrderRequest *orderRequest = [[HPTOrderRequest alloc] initWithOrderRelatedRequest:self.paymentPageRequest];
    
    orderRequest.paymentProductCode = self.paymentProduct.code;
    
    return orderRequest;
}

- (void)paymentButtonTableViewCellDidTouchButton:(HPTPaymentButtonTableViewCell *)cell
{
    [self performOrderRequest:[self createOrderRequest]];
}

- (void)performOrderRequest:(HPTOrderRequest *)orderRequest
{
    [self setPaymentButtonLoadingMode:YES];
    
    [[HPTGatewayClient sharedClient] requestNewOrder:orderRequest withCompletionHandler:^(HPTTransaction *theTransaction, NSError *error) {
        
        if (theTransaction != nil) {
            transaction = theTransaction;
            
            if (transaction.forwardUrl != nil) {
                
                HPTForwardViewController *viewController = [HPTForwardViewController relevantForwardViewControllerWithTransaction:transaction];
                
                viewController.delegate = self;
                
                [self presentViewController:viewController animated:YES completion:nil];
            }
            
            else {
                [self checkTransactionStatus:transaction];
            }
        }
        
        else {
            [self checkTransactionError:error];
        }
        
        [self setPaymentButtonLoadingMode:NO];
        
    }];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return [NSString stringWithFormat:HPTLocalizedString(@"PAY_WITH_THIS_METHOD"), self.paymentProduct.paymentProductDescription];
    }
    
    return nil;
}

@end
