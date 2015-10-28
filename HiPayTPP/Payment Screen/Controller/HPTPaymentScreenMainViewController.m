//
//  HPTPaymentScreenViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 22/10/2015.
//
//

#import "HPTPaymentScreenMainViewController.h"
#import "HPTPaymentProductButton.h"
#import "HPTForwardPaymentProductViewController.h"
#import "HPTPaymentProductsTableViewCell.h"

@interface HPTPaymentScreenMainViewController ()

@end

@implementation HPTPaymentScreenMainViewController

#pragma mark - Miscellaneous

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Paiement";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPaymentProducts:(NSArray *)paymentProducts
{
    _paymentProducts = paymentProducts;
    [paymentProductsTableView reloadData];
    
    if ([paymentProducts count] > 0) {
        [self selectPaymentProduct:paymentProducts.firstObject];
    }    
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
    
    return cell;
}

- (void)selectPaymentProduct:(HPTPaymentProduct *)paymentProduct
{
    HPTForwardPaymentProductViewController *paymentProductViewController = [[HPTForwardPaymentProductViewController alloc] initWithPaymentPageRequest:_paymentPageRequest andSelectedPaymentProduct:paymentProduct];
    
    UIViewController *currentViewController = self.childViewControllers.firstObject;
    
    [self addChildViewController:paymentProductViewController];
    [self.view addSubview:paymentProductViewController.view];
    paymentProductViewController.view.frame = currentViewController.view.frame;
    
    paymentProductViewController.view.alpha = 0.;
    currentViewController.view.alpha = 1.;
    
    [self transitionFromViewController:currentViewController toViewController:paymentProductViewController duration:0.2 options:0 animations:^{
        
        paymentProductViewController.view.alpha = 1.;
        currentViewController.view.alpha = 0.;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [paymentProductViewController didMoveToParentViewController:self];
    
    [currentViewController removeFromParentViewController];
}

- (void)paymentProductCollectionViewCellDidTouchButton:(HPTPaymentProductCollectionViewCell *)cell
{
    [self selectPaymentProduct:cell.paymentProduct];
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
    if (paymentProductsTableView.contentSize.height > 0.) {
        paymentProductsTableViewHeightConstraint.constant = paymentProductsTableView.contentSize.height;
        [self.view layoutIfNeeded];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Montant total : 99,90 €";
}


@end
