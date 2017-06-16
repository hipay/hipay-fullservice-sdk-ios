//
//  AbstractPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import "HPFAbstractPaymentProductViewController.h"
#import "HPFGatewayClient.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFTransactionRequestResponseManager.h"
#import "HPFPaymentCardSwitchTableHeaderView.h"
#import "HPFPaymentCardToken.h"
#import "HPFScanCardTableViewCell.h"
#import "HPFApplePayTableViewCell.h"

@interface HPFAbstractPaymentProductViewController ()

@property (nonatomic, strong) HPFPaymentCardToken *paymentCardToken;

@end

@implementation HPFAbstractPaymentProductViewController

- (instancetype)initWithPaymentPageRequest:(HPFPaymentPageRequest *)paymentPageRequest signature:(NSString *)signature andSelectedPaymentProduct:(HPFPaymentProduct *)paymentProduct
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _paymentPageRequest = paymentPageRequest;
        fieldIdentifiers = [NSMutableDictionary dictionary];
        _paymentProduct = paymentProduct;
        _signature = signature;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    if ([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFPaymentButtonTableViewCell" bundle:HPFPaymentScreenViewsBundle()] forCellReuseIdentifier:@"PaymentButton"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFInputTableViewCell" bundle:HPFPaymentScreenViewsBundle()] forCellReuseIdentifier:@"Input"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFCardNumberInputTableViewCell" bundle:HPFPaymentScreenViewsBundle()] forCellReuseIdentifier:@"CardNumberInput"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFExpiryDateInputTableViewCell" bundle:HPFPaymentScreenViewsBundle()] forCellReuseIdentifier:@"ExpiryDateInput"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFSecurityCodeInputTableViewCell" bundle:HPFPaymentScreenViewsBundle()] forCellReuseIdentifier:@"SecurityCodeInput"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFLabelTableViewCell" bundle:HPFPaymentScreenViewsBundle()] forCellReuseIdentifier:@"Label"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HPFApplePayTableViewCell" bundle:HPFPaymentScreenViewsBundle()] forCellReuseIdentifier:@"ApplePay"];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self determineScrollingMode];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    UINavigationController *navigationController = self.navigationController;
    NSArray *controllers = navigationController.viewControllers;

    if (navigationController == nil || controllers == nil) {
        [self cancelRequests];

        [self.delegate cancelActivity];
        self.delegate = nil;
    }

}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [activeTextField resignFirstResponder];
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self determineScrollingMode];
    }];
}

- (void)determineScrollingMode
{
    if ((self.tableView.contentSize.height <= self.tableView.frame.size.height) && ((activeTextField == nil) || (!activeTextField.editing) || !keyboardShown)) {
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
    keyboardShown = YES;
    
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
    } completion:^(BOOL finished) {
        [self determineScrollingMode];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    keyboardShown = NO;
    [self determineScrollingMode];
}

#pragma mark - Form

- (void)setPaymentButtonLoadingMode:(BOOL)isLoading
{
    loading = isLoading;
    
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[HPFPaymentButtonTableViewCell class]]) {
            ((HPFPaymentButtonTableViewCell *)cell).loading = isLoading;
        }
        
        if ([cell isKindOfClass:[HPFInputTableViewCell class]]) {
            ((HPFInputTableViewCell *)cell).enabled = !isLoading;
            [((HPFInputTableViewCell *)cell).textField resignFirstResponder];
        }

        if ([cell isKindOfClass:[HPFScanCardTableViewCell class]]) {
            ((HPFScanCardTableViewCell *)cell).enabled = !isLoading;
        }
    }

    HPFPaymentCardSwitchTableHeaderView *headerView = (HPFPaymentCardSwitchTableHeaderView *)[self.tableView headerViewForSection:[self paySection]];
    if (headerView != nil) {
        headerView.enabled = !isLoading;
    }

    [self.delegate paymentProductViewController:self isLoading:isLoading];
}

- (NSInteger) formSection
{
    [self doesNotRecognizeSelector:_cmd];
    return -1;
}

- (NSInteger) paySection
{
    [self doesNotRecognizeSelector:_cmd];
    return -1;
}

- (NSInteger) scanSection {
    [self doesNotRecognizeSelector:_cmd];
    return -1;
}

- (void)editingDoneButtonTouched:(id)sender
{
    [activeTextField resignFirstResponder];
}

- (HPFInputTableViewCell *)cellWithTextField:(UITextField *)textField
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[HPFInputTableViewCell class]]) {
            if (((HPFInputTableViewCell *)cell).textField == textField) {
                return (HPFInputTableViewCell *) cell;
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
        if ([cell isKindOfClass:[HPFPaymentButtonTableViewCell class]]) {
            ((HPFPaymentButtonTableViewCell *)cell).enabled = [self submitButtonEnabled];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Dequeue helper


- (HPFInputTableViewCell *)dequeueInputCellWithIdentifier:(NSString *)identifier fieldIdentifier:(NSString *)fieldIdentifier
{
    HPFInputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.textField.delegate = self;
    cell.textField.inputAccessoryView = nil;
    cell.textField.enabled = !loading;
    
    cell.textField.text = [[fieldIdentifiers objectForKey:fieldIdentifier] text];
    
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [fieldIdentifiers setObject:cell.textField forKey:fieldIdentifier];
    
    return cell;
}

- (HPFLabelTableViewCell *)dequeueLabelCell
{
    HPFLabelTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Label"];
    
    return cell;
}

- (HPFApplePayTableViewCell *)dequeueApplePayCell
{
    HPFApplePayTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ApplePay"];

    PKPaymentButton *paymentButton = [[PKPaymentButton alloc] initWithPaymentButtonType:PKPaymentButtonTypeBuy paymentButtonStyle:PKPaymentButtonStyleWhiteOutline];

    [cell.contentView addSubview:paymentButton];

    paymentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    CGRect payButtonFrame = paymentButton.frame;
    payButtonFrame.size.width = MAX(CGRectGetWidth(payButtonFrame), 160.f);
    payButtonFrame.size.height = MAX(CGRectGetHeight(payButtonFrame), 44.f);

    paymentButton.frame = payButtonFrame;
    paymentButton.center = [cell.contentView convertPoint:cell.contentView.center
                                                 fromView:cell.contentView.superview];

    return cell;
}

- (HPFPaymentButtonTableViewCell *)dequeuePaymentButtonCell
{
    HPFPaymentButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PaymentButton"];
    
    cell.loading = loading;
    cell.enabled = [self submitButtonEnabled];
    cell.delegate = self;
    
    return cell;
}

- (void)resetForm
{
    defaultFormValuesDefined = NO;
    [fieldIdentifiers removeAllObjects];
    [self.tableView reloadData];
}

- (void) savePaymentMethod:(HPFPaymentMethod *)paymentMethod {
    //abstract method
    [self doesNotRecognizeSelector:_cmd];
}

#pragma mark - Transaction results, errors

- (void)checkTransactionStatus:(HPFTransaction *)theTransaction
{
    [[HPFTransactionRequestResponseManager sharedManager] manageTransaction:theTransaction withCompletionHandler:^(HPFTransactionErrorResult *result) {
        
        if(result.formAction == HPFFormActionQuit) {

            HPFPaymentMethod *paymentMethod = theTransaction.paymentMethod;
            if (paymentMethod != nil) {
                [self savePaymentMethod:paymentMethod];
            }
            [self.delegate paymentProductViewController:self didEndWithTransaction:theTransaction];
        }
        
        [self checkRequestResultStatus:result];
        
    }];
}

- (void)checkTransactionError:(NSError *)transactionError
{
    [[HPFTransactionRequestResponseManager sharedManager] manageError:transactionError withCompletionHandler:^(HPFTransactionErrorResult *result) {
       
        if(result.formAction == HPFFormActionQuit) {
            [self.delegate paymentProductViewController:self didFailWithError:transactionError];
        }
        
        [self checkRequestResultStatus:result];
        
    }];
}

- (void)checkRequestResultStatus:(HPFTransactionErrorResult *)result
{
    switch (result.formAction) {
        case HPFFormActionReset:
            [self resetForm];
            break;
            
        case HPFFormActionFormReload:
            [self submit];
            break;
            
        case HPFFormActionBackgroundReload:
            [self needsBackgroundTransactionOrOrderReload];
            break;
            
        default:
            break;
    }
}

- (void)needsBackgroundTransactionOrOrderReload
{
    if (transaction != nil) {
        [self.delegate paymentProductViewController:self needsBackgroundReloadingOfTransaction:transaction];
    }
    
    else {
        [self.delegate paymentProductViewControllerNeedsBackgroundOrderReload:self];
    }
}

#pragma mark - Forward controller

- (void)forwardViewControllerDidCancel:(HPFForwardViewController *)viewController
{
    [self needsBackgroundTransactionOrOrderReload];
}

- (void)forwardViewController:(HPFForwardViewController *)viewController didEndWithTransaction:(HPFTransaction *)theTransaction
{
    [self checkTransactionStatus:theTransaction];
}

- (void)forwardViewController:(HPFForwardViewController *)viewController didFailWithError:(NSError *)error
{
    [self checkTransactionError:error];
}

#pragma mark - Payment workflow

- (HPFOrderRequest *)createOrderRequest
{
    HPFOrderRequest *orderRequest = [[HPFOrderRequest alloc] initWithOrderRelatedRequest:self.paymentPageRequest];
    
    orderRequest.paymentProductCode = self.paymentProduct.code;
    
    return orderRequest;
}

- (void)paymentButtonTableViewCellDidTouchButton:(HPFPaymentButtonTableViewCell *)cell
{
    [self submit];
}

- (void)submit
{

    [self performOrderRequest:[self createOrderRequest] signature:self.signature];
}

- (void)performOrderRequest:(HPFOrderRequest *)orderRequest signature:(NSString *)signature
{
    [self setPaymentButtonLoadingMode:YES];
    
    [self cancelRequests];
    
    transactionLoadingRequest = [[HPFGatewayClient sharedClient] requestNewOrder:orderRequest signature:signature withCompletionHandler:^(HPFTransaction *theTransaction, NSError *error) {
        
        transactionLoadingRequest = nil;
        
        if (theTransaction != nil) {
            transaction = theTransaction;
            
            if (transaction.forwardUrl != nil) {

                UINavigationController *navigationController = self.navigationController;
                NSArray *controllers = navigationController.viewControllers;
                if (navigationController != nil && controllers != nil) {
                    HPFForwardViewController *viewController = [HPFForwardViewController relevantForwardViewControllerWithTransaction:transaction signature:signature];
                    viewController.delegate = self;

                    [self presentViewController:viewController animated:YES completion:nil];
                }
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

- (void)cancelRequests
{
    [transactionLoadingRequest cancel];
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {


    if (section == 0) {

        if (section == [self scanSection]) {

            return @"";

        } else {

            return [NSString stringWithFormat:HPFLocalizedString(@"PAY_WITH_THIS_METHOD"), self.paymentProduct.paymentProductDescription];
        }
    }
    
    return nil;
}

@end
