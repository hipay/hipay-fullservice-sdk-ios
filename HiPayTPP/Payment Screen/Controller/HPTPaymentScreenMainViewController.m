//
//  HPTPaymentScreenViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 22/10/2015.
//
//

#import "HPTPaymentScreenMainViewController.h"
#import "HPTPaymentProductButton.h"
#import "HPTPaymentProductCollectionViewCell.h"

@interface HPTPaymentScreenMainViewController ()

@end

@implementation HPTPaymentScreenMainViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"PaymentScreenViews" ofType:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
        
        self = [super initWithNibName:@"HPTPaymentScreenMainViewController" bundle:bundle];
        
        self.title = @"Paiement";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [paymentProductsCollectionView registerClass:[HPTPaymentProductCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    paymentProductsCollectionView.decelerationRate = 0.993;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:amountLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:20.0]];
    
//    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)paymentProductsCollectionView.collectionViewLayout;
}

- (void)setPaymentProducts:(NSArray *)paymentProducts
{
    _paymentProducts = paymentProducts;
    [paymentProductsCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.paymentProducts count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HPTPaymentProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.paymentProduct = self.paymentProducts[indexPath.row];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
