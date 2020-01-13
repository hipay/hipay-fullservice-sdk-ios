//
//  HPFPaymentScreenViewController.m
//  Pods
//
//  Created by HiPay on 22/10/2015.
//
//

#import "HPFPaymentScreenMainViewController.h"

#import "HPFPaymentScreenUtils.h"
#import "HPFForwardPaymentProductViewController.h"
#import "HPFQiwiWalletPaymentProductViewController.h"
#import "HPFIDealPaymentProductViewController.h"
#import "HPFTokenizableCardPaymentProductViewController.h"
#import "HPFUnsupportedPaymentProductViewController.h"
#import "HPFPaymentProductsFlowLayout.h"
#import "HPFApplePayPaymentProductViewController.h"
#import "HPFSepaDirectDebitPaymentProductViewController.h"
#import "HPFStats.h"
#import "HPFMonitoring.h"
#import "HPFGradientView.h"

#define GRADIENT_WIDTH 30

@interface HPFPaymentScreenMainViewController ()

@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (nonatomic, strong) HPFGradientView *rightGradientView;

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
        HPFPaymentProductCodeSDD: HPFSepaDirectDebitPaymentProductViewController.class,
        HPFPaymentProductCodePayULatam: HPFForwardPaymentProductViewController.class,
        HPFPaymentProductCodeINGHomepay: HPFForwardPaymentProductViewController.class,
        HPFPaymentProductCodeBCMCMobile: HPFForwardPaymentProductViewController.class,
        HPFPaymentProductCodePrzelewy24: HPFForwardPaymentProductViewController.class,
        HPFPaymentProductCodeBankTransfer: HPFForwardPaymentProductViewController.class,
        HPFPaymentProductCodePaysafecard: HPFForwardPaymentProductViewController.class,
        HPFPaymentProductCodeDexiaDirectNet: HPFForwardPaymentProductViewController.class,
        
        HPFPaymentProductCodeApplePay: HPFApplePayPaymentProductViewController.class,
    };
    
}

-(void)setPaymentPageRequest:(HPFPaymentPageRequest *)paymentPageRequest {
    _paymentPageRequest = paymentPageRequest;
    
    HPFStats.current = [HPFStats new];
    HPFStats.current.amount = self.paymentPageRequest.amount;
    HPFStats.current.cardCountry = self.paymentPageRequest.shippingAddress.country;
    HPFStats.current.currency = self.paymentPageRequest.currency;
    HPFStats.current.orderID = self.paymentPageRequest.orderId;
    HPFStats.current.event = HPFEventInit;
    
    HPFMonitoring *monitoring = [HPFMonitoring new];
    monitoring.initializeDate = [NSDate new];
    [HPFStats.current setMonitoring:monitoring];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    numberFormatter.currencyCode = self.paymentPageRequest.currency;
    
    self.totalAmountLabel.text = [NSString stringWithFormat:HPFLocalizedString(@"HPF_TOTAL_AMOUNT"),
                                  [numberFormatter stringFromNumber:self.paymentPageRequest.amount]].uppercaseString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HPFLocalizedString(@"HPF_PAYMENT_SCREEN_TITLE");
    
    paymentProductsCollectionView.decelerationRate = 0.993;
    
    UIColor *fillColor;
    UIColor *clearColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    if (@available(iOS 13.0, *)) {
        fillColor = [UIColor systemGroupedBackgroundColor];
    } else {
        fillColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:247/255.0 alpha:1];
    }
    self.rightGradientView = [[HPFGradientView alloc] initWithStartColor:clearColor endColor:fillColor];
    self.rightGradientView.alpha = 0.0;
    [self.view addSubview:self.rightGradientView];
    
    self.totalAmountLabel.alpha = 0.0;
}

- (void)setPaymentProducts:(NSArray *)paymentProducts
{
    _paymentProducts = paymentProducts;
    [paymentProductsCollectionView reloadData];
    
    if ([paymentProducts count] > 0) {
        [self selectPaymentProduct:paymentProducts.firstObject];
    }
    
    HPFStats.current.monitoring.displayDate = [NSDate new];
    [HPFStats.current send];
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
    
    self.rightGradientView.frame = CGRectMake(self->paymentProductsCollectionView.frame.origin.x + self->paymentProductsCollectionView.frame.size.width - GRADIENT_WIDTH,
                                              self->paymentProductsCollectionView.frame.origin.y,
                                              GRADIENT_WIDTH,
                                              self->paymentProductsCollectionView.frame.size.height);
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

#pragma mark - Payment products collection view

- (void)defineCollectionViewParams
{
    ((HPFPaymentProductsFlowLayout *)paymentProductsCollectionView.collectionViewLayout).collectionViewSize = paymentProductsCollectionView.bounds.size;
    
    if (self.paymentProducts.count > 2) {
        ((UICollectionViewFlowLayout *)paymentProductsCollectionView.collectionViewLayout).sectionInset = UIEdgeInsetsMake(0., 10., 0., 10.);
    }
}

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
        
        [self transitionFromViewController:currentViewController toViewController:paymentProductViewController duration:0.2 options:0 animations:^{
            
            self->paymentProductViewController.view.alpha = 1.;
            currentViewController.view.alpha = 0.;
            self.totalAmountLabel.alpha = 1.;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.view layoutIfNeeded];
                if (self->paymentProductsCollectionView.contentSize.width > self->paymentProductsCollectionView.bounds.size.width) {
                    self.rightGradientView.alpha = 1.;
                }
            }];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view layoutIfNeeded];
        });
        
        [paymentProductViewController didMoveToParentViewController:self];
        
        [currentViewController removeFromParentViewController];
        
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
        
        return [obj isEqual:self->selectedPaymentProduct];
        
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

@end
