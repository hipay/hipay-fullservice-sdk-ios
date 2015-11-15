//
//  HPTPaymentScreenViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 22/10/2015.
//
//

#import "HPTPaymentScreenMainViewController.h"
#import "HPTPaymentProductButton.h"
#import "HPTPaymentProductsTableViewCell.h"

#import "HPTPaymentScreenUtils.h"

#import "HPTForwardPaymentProductViewController.h"
#import "HPTQiwiWalletPaymentProductViewController.h"
#import "HPTIDealPaymentProductViewController.h"
#import "HPTTokenizableCardPaymentProductViewController.h"

@interface HPTPaymentScreenMainViewController ()

@end

@implementation HPTPaymentScreenMainViewController

#pragma mark - Miscellaneous

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HPTLocalizedString(@"PAYMENT_SCREEN_TITLE");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPaymentProducts:(NSArray *)paymentProducts
{
    _paymentProducts = paymentProducts;
    [paymentProductsTableView reloadData];
    [spinner stopAnimating];
    
    if ([paymentProducts count] > 0) {
        [self selectPaymentProduct:paymentProducts.firstObject];
    }    
}

- (void)updatePaymentProductsTableViewHeightConstraint
{
    if (paymentProductsTableView.contentSize.height > 0.) {
        paymentProductsTableViewHeightConstraint.constant = paymentProductsTableView.contentSize.height;
        [self.view layoutIfNeeded];
    }
}

#pragma mark - Keyboard related methods

- (void)keyboardWillShowOrChangeFrame:(NSNotification *)notification
{

    CGRect keyboardFrame = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect endFrame = [self.view convertRect:keyboardFrame fromView:nil];

    if ((keyboardContainerConstraintTop == nil) || (keyboardContainerConstraintTop.constant != endFrame.origin.y)) {
        containerHasFullLayout = YES;
        
        [self.view removeConstraint:containerBottomConstraint];
        
        if (keyboardContainerConstraintTop == nil) {
            
            keyboardContainerConstraintTop = [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:endFrame.origin.y];
            
            keyboardContainerConstraintBottom = [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            
            [self.view addConstraint:keyboardContainerConstraintTop];
            [self.view addConstraint:keyboardContainerConstraintBottom];
            
        }
        
        keyboardContainerConstraintTop.constant = endFrame.origin.y;
        
        if (self.navigationItem.rightBarButtonItems != nil) {
            rightBarButtonItems = self.navigationItem.rightBarButtonItems;
            [self.navigationItem setRightBarButtonItems:nil animated:YES];
        }
        
        [self defineContainerTopSpacing];
        
        [self.view layoutIfNeeded];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.view removeConstraint:keyboardContainerConstraintTop];
    [self.view removeConstraint:keyboardContainerConstraintBottom];
    [self.view addConstraint:containerBottomConstraint];
    
    keyboardContainerConstraintTop = nil;
    keyboardContainerConstraintBottom = nil;
    
    containerHasFullLayout = NO;
    
    NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationItem setRightBarButtonItems:rightBarButtonItems animated:YES];
    });
    
    [self defineContainerTopSpacing];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Payment products collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.paymentProducts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HPTPaymentProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PaymentProductCell" forIndexPath:indexPath];
    
    cell.paymentProduct = self.paymentProducts[indexPath.row];
    cell.delegate = self;
    
    cell.highlighted = (cell.paymentProduct == selectedPaymentProduct);
    
    return cell;
}

- (void)selectPaymentProduct:(HPTPaymentProduct *)paymentProduct
{
    if (selectedPaymentProduct != paymentProduct) {
        
        selectedPaymentProduct = paymentProduct;
        
        HPTAbstractPaymentProductViewController *paymentProductViewController;
        
        // Tokenizable card
        if (paymentProduct.tokenizable) {
            paymentProductViewController = [[HPTTokenizableCardPaymentProductViewController alloc] initWithPaymentPageRequest:_paymentPageRequest andSelectedPaymentProduct:paymentProduct];
        }
        
        // Qiwi Wallet
        else if ([paymentProduct.code isEqualToString:HPTPaymentProductCodeQiwiWallet]) {
            paymentProductViewController = [[HPTQiwiWalletPaymentProductViewController alloc] initWithPaymentPageRequest:_paymentPageRequest andSelectedPaymentProduct:paymentProduct];
        }
        
        // iDEAL
        else if ([paymentProduct.code isEqualToString:HPTPaymentProductCodeIDEAL]) {
            paymentProductViewController = [[HPTIDealPaymentProductViewController alloc] initWithPaymentPageRequest:_paymentPageRequest andSelectedPaymentProduct:paymentProduct];
        }
        
        // Simple payment method
        else {
            paymentProductViewController = [[HPTForwardPaymentProductViewController alloc] initWithPaymentPageRequest:_paymentPageRequest andSelectedPaymentProduct:paymentProduct];
        }

        id<HPTPaymentProductViewControllerDelegate> paymentProductViewDelegate = (id<HPTPaymentProductViewControllerDelegate>) self.parentViewController.parentViewController;
        
        paymentProductViewController.delegate = paymentProductViewDelegate;
        
        UIViewController *currentViewController = self.childViewControllers.firstObject;
        
        [self addChildViewController:paymentProductViewController];

        paymentProductViewController.view.frame = currentViewController.view.frame;
        
        paymentProductViewController.view.alpha = 0.;
        currentViewController.view.alpha = 1.;
        [self defineContainerTopSpacing];
        
        [self transitionFromViewController:currentViewController toViewController:paymentProductViewController duration:0.2 options:0 animations:^{
            
            paymentProductViewController.view.alpha = 1.;
            currentViewController.view.alpha = 0.;
            
        } completion:^(BOOL finished) {
            [self defineContainerTopSpacing];
            
            [UIView animateWithDuration:0.2 animations:^{
                [self.view layoutIfNeeded];
            }];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self defineContainerTopSpacing];
            [self.view layoutIfNeeded];
        });
        
        [paymentProductViewController didMoveToParentViewController:self];
        
        [currentViewController removeFromParentViewController];
        
    }
}

- (void)defineContainerTopSpacing
{
    UITableViewController *paymentProductViewController = self.childViewControllers.lastObject;
    
    if ([paymentProductViewController isKindOfClass:[UITableViewController class]]) {
        
        UITableViewHeaderFooterView *headerView = [paymentProductViewController.tableView headerViewForSection:0];
        
        if ([headerView isKindOfClass:[UITableViewHeaderFooterView class]]) {
            
            if (!containerHasFullLayout) {
                
                CGFloat additionalSpace = fmax(headerView.textLabel.frame.origin.y - 10., 0.);
                
                containerTopConstraint.constant = - additionalSpace;
                paymentProductViewController.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(additionalSpace, 0., 0., 0.);
            } else {
                containerTopConstraint.constant = 0.;
            }
        }
    }
}

- (void)paymentProductCollectionViewCellDidTouchButton:(HPTPaymentProductCollectionViewCell *)cell
{
    if (paymentProductsCollectionView.scrollEnabled || (paymentProductsCollectionView == nil)) {
        [self selectPaymentProduct:cell.paymentProduct];
        
        NSIndexPath *indexPath = [paymentProductsCollectionView indexPathForCell:cell];
        
        for (HPTPaymentButtonTableViewCell *aCell in paymentProductsCollectionView.visibleCells) {
            aCell.highlighted = NO;
        }
        
        cell.highlighted = YES;
        
        [self scrollToPaymentProductsCollectionViewIndexPath:indexPath];
    }
}

- (void)scrollToPaymentProductsCollectionViewIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath != nil) {
        
        CGRect frame = [paymentProductsCollectionView layoutAttributesForItemAtIndexPath:indexPath].frame;
        
        CGPoint proposedOffset = CGPointMake(frame.origin.x - frame.size.width, 0.);
        CGPoint offset = [paymentProductsCollectionView.collectionViewLayout targetContentOffsetForProposedContentOffset:proposedOffset withScrollingVelocity:CGPointMake(0., 0.)];
        
        [paymentProductsCollectionView setContentOffset:offset animated:YES];
        
    }
}

- (void)focusOnSelectedPaymentProduct
{
    NSUInteger index = [self.paymentProducts indexOfObjectPassingTest:^BOOL(HPTPaymentProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        return [obj isEqual:selectedPaymentProduct];
        
    }];
    
    if (index != NSNotFound) {
        [self scrollToPaymentProductsCollectionViewIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    }
}

- (void)setPaymentProductSelectionEnabled:(BOOL)enabled
{
    paymentProductsCollectionView.scrollEnabled = enabled;
}

#pragma mark - Main table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_paymentProducts != nil) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPTPaymentProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentProductsCell"];
    
    paymentProductsCollectionView = cell.paymentProductsCollectionView;

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self updatePaymentProductsTableViewHeightConstraint];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    numberFormatter.currencyCode = self.paymentPageRequest.currency;
     
    return [NSString stringWithFormat:HPTLocalizedString(@"TOTAL_AMOUNT"), [numberFormatter stringFromNumber:self.paymentPageRequest.amount]];
}

@end
