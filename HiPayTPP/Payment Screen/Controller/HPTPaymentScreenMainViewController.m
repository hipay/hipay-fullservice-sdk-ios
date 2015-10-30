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

#import "HPTForwardPaymentProductViewController.h"
#import "HPTQiwiWalletPaymentProductViewController.h"

@interface HPTPaymentScreenMainViewController ()

@end

@implementation HPTPaymentScreenMainViewController

#pragma mark - Miscellaneous

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Paiement";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

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

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect endFrame = [self.view convertRect:keyboardFrame fromView:nil];
    
    [self.view removeConstraint:containerBottomConstraint];
    
    keyboardContainerConstraintTop = [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:endFrame.origin.y];
    
    keyboardContainerConstraintBottom = [NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    [self.view addConstraint:keyboardContainerConstraintTop];
    [self.view addConstraint:keyboardContainerConstraintBottom];
    
    NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    rightBarButtonItems = self.navigationItem.rightBarButtonItems;
    [self.navigationItem setRightBarButtonItems:nil animated:YES];
    self.navigationItem.title = selectedPaymentProduct.paymentProductDescription;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.view removeConstraint:keyboardContainerConstraintTop];
    [self.view removeConstraint:keyboardContainerConstraintBottom];
    [self.view addConstraint:containerBottomConstraint];
    
    keyboardContainerConstraintTop = nil;
    keyboardContainerConstraintBottom = nil;
    
    NSTimeInterval animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.navigationItem.title = self.title;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationItem setRightBarButtonItems:rightBarButtonItems animated:YES];
    });
    
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
        
        HPTForwardPaymentProductViewController *paymentProductViewController;
        
        // Qiwi Wallet
        if ([paymentProduct.code isEqualToString:@"qiwi-wallet"]) {
            paymentProductViewController = [[HPTQiwiWalletPaymentProductViewController alloc] initWithPaymentPageRequest:_paymentPageRequest andSelectedPaymentProduct:paymentProduct];
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
        
        [self transitionFromViewController:currentViewController toViewController:paymentProductViewController duration:0.2 options:0 animations:^{
            
            paymentProductViewController.view.alpha = 1.;
            currentViewController.view.alpha = 0.;
            
        } completion:nil];
        
        [paymentProductViewController didMoveToParentViewController:self];
        
        [currentViewController removeFromParentViewController];
        
    }
}

- (void)paymentProductCollectionViewCellDidTouchButton:(HPTPaymentProductCollectionViewCell *)cell
{
    [self selectPaymentProduct:cell.paymentProduct];
    
    NSIndexPath *indexPath = [paymentProductsCollectionView indexPathForCell:cell];
    
    for (HPTPaymentButtonTableViewCell *aCell in paymentProductsCollectionView.visibleCells) {
        aCell.highlighted = NO;
    }
    
    cell.highlighted = YES;
    
    if (indexPath != nil) {
        
        CGPoint proposedOffset = CGPointMake(cell.frame.origin.x - cell.frame.size.width, 0.);
        CGPoint offset = [paymentProductsCollectionView.collectionViewLayout targetContentOffsetForProposedContentOffset:proposedOffset withScrollingVelocity:CGPointMake(0., 0.)];
        
        [paymentProductsCollectionView setContentOffset:offset animated:YES];
        
    }
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
    return @"Montant total : 99,90 €";
}

@end
