//
//  HPFPaymentScreenViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 22/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPFPaymentPageRequest.h"
#import "HPFPaymentProductCollectionViewCell.h"
#import "HPFAbstractPaymentProductViewController.h"

@interface HPFPaymentScreenMainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, HPFPaymentProductCollectionViewCellDelegate>
{
    UICollectionView *paymentProductsCollectionView;
    
    HPFPaymentProduct *selectedPaymentProduct;
    NSArray *rightBarButtonItems;
    NSDictionary *paymentProductViewControllers;
    HPFAbstractPaymentProductViewController *paymentProductViewController;

    __weak IBOutlet UIActivityIndicatorView *spinner;
    __weak IBOutlet UIView *containerView;
    
    __weak IBOutlet NSLayoutConstraint *containerBottomConstraint;
    __weak IBOutlet NSLayoutConstraint *containerTopConstraint;
    
    __weak IBOutlet UITableView *paymentProductsTableView;
    __weak IBOutlet NSLayoutConstraint *paymentProductsTableViewHeightConstraint;
    
    NSLayoutConstraint *keyboardContainerConstraintTop;
    NSLayoutConstraint *keyboardContainerConstraintBottom;
    
    BOOL containerHasFullLayout;
}

- (void)focusOnSelectedPaymentProductWithAnimation:(BOOL)animated;
- (void)setPaymentProductSelectionEnabled:(BOOL)enabled;
- (void)changeSelectedPaymentProductTo:(HPFPaymentProduct *)paymentProduct;
- (void)cancelRequests;

@property (nonatomic) NSArray <HPFPaymentProduct *> *paymentProducts;
@property (nonatomic) HPFPaymentPageRequest *paymentPageRequest;
@property (nonatomic) NSString *signature;
@property (nonatomic) BOOL loading;

@end
