//
//  HPFPaymentScreenViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 22/10/2015.
//
//

#import "HPFPaymentScreenMainViewController.h"
#import "HPFPaymentProductsTableViewCell.h"

#import "HPFPaymentScreenUtils.h"

#import "HPFForwardPaymentProductViewController.h"
#import "HPFQiwiWalletPaymentProductViewController.h"
#import "HPFIDealPaymentProductViewController.h"
#import "HPFTokenizableCardPaymentProductViewController.h"
#import "HPFUnsupportedPaymentProductViewController.h"
#import "HPFPaymentProductsFlowLayout.h"

@interface HPFPaymentScreenMainViewController ()

@end

@implementation HPFPaymentScreenMainViewController

#pragma mark - Miscellaneous

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    paymentProductViewControllers = @{
                                      HPFPaymentProductCodeVisa: HPFTokenizableCardPaymentProductViewController.class,
                                      HPFPaymentProductCodeMasterCard: HPFTokenizableCardPaymentProductViewController.class,
                                      HPFPaymentProductCodeCB: HPFTokenizableCardPaymentProductViewController.class,
                                      HPFPaymentProductCodeAmericanExpress: HPFTokenizableCardPaymentProductViewController.class,
                                      HPFPaymentProductCodeDiners: HPFTokenizableCardPaymentProductViewController.class,
                                      HPFPaymentProductCodeMaestro: HPFTokenizableCardPaymentProductViewController.class,
                                      HPFPaymentProductCodeBCMC: HPFTokenizableCardPaymentProductViewController.class,
                                      HPFPaymentProductCodeQiwiWallet: HPFQiwiWalletPaymentProductViewController.class,
                                      HPFPaymentProductCodeIDEAL: HPFIDealPaymentProductViewController.class,
                                      HPFPaymentProductCodePayPal: HPFForwardPaymentProductViewController.class,
                                      HPFPaymentProductCodeYandex: HPFForwardPaymentProductViewController.class,
                                      HPFPaymentProductCodeSofortUberweisung: HPFForwardPaymentProductViewController.class,
                                      HPFPaymentProductCodeSisal: HPFForwardPaymentProductViewController.class,
                                      HPFPaymentProductCodeSDD: HPFForwardPaymentProductViewController.class,
                                      HPFPaymentProductCodePayULatam: HPFForwardPaymentProductViewController.class,
                                      HPFPaymentProductCodeINGHomepay: HPFForwardPaymentProductViewController.class,
                                      HPFPaymentProductCodeBCMCMobile: HPFForwardPaymentProductViewController.class,
                                      HPFPaymentProductCodePrzelewy24: HPFForwardPaymentProductViewController.class,
                                      HPFPaymentProductCodeBankTransfer: HPFForwardPaymentProductViewController.class,
                                      HPFPaymentProductCodePaysafecard: HPFForwardPaymentProductViewController.class,
                                      HPFPaymentProductCodeDexiaDirectNet: HPFForwardPaymentProductViewController.class,
                                      };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HPFLocalizedString(@"PAYMENT_SCREEN_TITLE");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if ([paymentProductsTableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        paymentProductsTableView.cellLayoutMarginsFollowReadableWidth = YES;
    }
    
    paymentProductsTableView.hidden = YES;
}

- (void)setPaymentProducts:(NSArray *)paymentProducts
{
    _paymentProducts = paymentProducts;
    [paymentProductsTableView reloadData];
    [paymentProductsCollectionView reloadData];
    paymentProductsTableView.hidden = NO;
    
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        [self defineCollectionViewParams];
        [self focusOnSelectedPaymentProductWithAnimation:NO];
        
    } completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.loading = _loading;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    ((HPFPaymentProductsFlowLayout *)paymentProductsCollectionView.collectionViewLayout).collectionViewSize = paymentProductsCollectionView.bounds.size;
}

- (void)setLoading:(BOOL)loading
{
    _loading = loading;
    
    if (loading) {
        [spinner startAnimating];
    } else {
        [spinner stopAnimating];
    }
}

- (void)cancelRequests
{
    [paymentProductViewController cancelRequests];
}

- (void)defineCollectionViewParams
{
    ((HPFPaymentProductsFlowLayout *)paymentProductsCollectionView.collectionViewLayout).collectionViewSize = paymentProductsCollectionView.bounds.size;
    
    if (self.paymentProducts.count > 2) {
        ((UICollectionViewFlowLayout *)paymentProductsCollectionView.collectionViewLayout).sectionInset = UIEdgeInsetsMake(0., 10., 0., 10.);
    } else {
        ((UICollectionViewFlowLayout *)paymentProductsCollectionView.collectionViewLayout).sectionInset = paymentProductsTableView.separatorInset;
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
    HPFPaymentProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PaymentProductCell" forIndexPath:indexPath];
    
    cell.paymentProduct = self.paymentProducts[indexPath.row];
    cell.delegate = self;
    
    cell.highlighted = (cell.paymentProduct == selectedPaymentProduct);
    
    if (!cell.highlighted && !paymentProductsCollectionView.scrollEnabled) {
        cell.paymentProductButton.enabled = NO;
        cell.userInteractionEnabled = NO;
    }
    
    else {
        cell.paymentProductButton.enabled = YES;
        cell.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (void)changeSelectedPaymentProductTo:(HPFPaymentProduct *)paymentProduct
{
    selectedPaymentProduct = paymentProduct;
    [paymentProductsCollectionView reloadData];
    [self focusOnSelectedPaymentProductWithAnimation:YES];
}

- (void)selectPaymentProduct:(HPFPaymentProduct *)paymentProduct
{
    if (selectedPaymentProduct != paymentProduct) {
        
        selectedPaymentProduct = paymentProduct;

        // Cancel requests for currently displayed payment product view controller
        if (paymentProductViewController != nil) {
            [paymentProductViewController cancelRequests];
        }
        
        Class paymentProductViewControllerClass = paymentProductViewControllers[paymentProduct.code];

        // Grouped payment cards
        if (paymentProduct.groupedPaymentProductCodes != nil) {
            paymentProductViewControllerClass = [HPFTokenizableCardPaymentProductViewController class];
        }
        
        // Supported payment product with specific view controller
        if (paymentProductViewControllerClass != nil) {
            paymentProductViewController = [[paymentProductViewControllerClass alloc] initWithPaymentPageRequest:_paymentPageRequest signature:_signature andSelectedPaymentProduct:paymentProduct];
        }
        
        // Payment product which is natively unsupported, fallback controller
        else {
            paymentProductViewController = [[HPFUnsupportedPaymentProductViewController alloc] initWithPaymentPageRequest:_paymentPageRequest signature:_signature andSelectedPaymentProduct:paymentProduct];
        }

        id<HPFPaymentProductViewControllerDelegate> paymentProductViewDelegate = (id<HPFPaymentProductViewControllerDelegate>) self.parentViewController.parentViewController;
        
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

- (void)paymentProductCollectionViewCellDidTouchButton:(HPFPaymentProductCollectionViewCell *)cell
{
    if (paymentProductsCollectionView.scrollEnabled || (paymentProductsCollectionView == nil)) {
        [self selectPaymentProduct:cell.paymentProduct];
        
        NSIndexPath *indexPath = [paymentProductsCollectionView indexPathForCell:cell];
        
        for (HPFPaymentButtonTableViewCell *aCell in paymentProductsCollectionView.visibleCells) {
            aCell.highlighted = NO;
        }
        
        cell.highlighted = YES;
        
        [self scrollToPaymentProductsCollectionViewIndexPath:indexPath withAnimation:YES];
    }
}

- (void)scrollToPaymentProductsCollectionViewIndexPath:(NSIndexPath *)indexPath withAnimation:(BOOL)animated
{
    if (indexPath != nil) {
        
        if (paymentProductsCollectionView.contentSize.width > paymentProductsCollectionView.bounds.size.width) {
            CGPoint currentContentOffset = paymentProductsCollectionView.contentOffset;
            [paymentProductsCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            CGPoint proposedOffset = paymentProductsCollectionView.contentOffset;
            paymentProductsCollectionView.contentOffset = currentContentOffset;
            
            CGPoint offset = [paymentProductsCollectionView.collectionViewLayout targetContentOffsetForProposedContentOffset:proposedOffset withScrollingVelocity:CGPointMake(0., 0.)];
            
            [paymentProductsCollectionView setContentOffset:offset animated:animated];
        }
    }
}

- (void)focusOnSelectedPaymentProductWithAnimation:(BOOL)animated
{
    NSUInteger index = [self.paymentProducts indexOfObjectPassingTest:^BOOL(HPFPaymentProduct * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        return [obj isEqual:selectedPaymentProduct];
        
    }];
    
    if (index != NSNotFound) {
        [self scrollToPaymentProductsCollectionViewIndexPath:[NSIndexPath indexPathForRow:index inSection:0] withAnimation:animated];
    }
}

- (void)setPaymentProductSelectionEnabled:(BOOL)enabled
{
    paymentProductsCollectionView.scrollEnabled = enabled;
    [paymentProductsCollectionView reloadData];
}

#pragma mark - Main table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HPFPaymentProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentProductsCell"];
    cell.backgroundColor = [UIColor clearColor];

    paymentProductsCollectionView = cell.paymentProductsCollectionView;
 
    [self defineCollectionViewParams];
    
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
     
    return [NSString stringWithFormat:HPFLocalizedString(@"TOTAL_AMOUNT"), [numberFormatter stringFromNumber:self.paymentPageRequest.amount]];
}

@end
