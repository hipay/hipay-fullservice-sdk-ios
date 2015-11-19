//
//  HPTPaymentScreenViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 22/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTPaymentPageRequest.h"
#import "HPTPaymentProductCollectionViewCell.h"

@interface HPTPaymentScreenMainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, HPTPaymentProductCollectionViewCellDelegate>
{
    UICollectionView *paymentProductsCollectionView;
    
    HPTPaymentProduct *selectedPaymentProduct;
    NSArray *rightBarButtonItems;
    
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
- (void)changeSelectedPaymentProductTo:(HPTPaymentProduct *)paymentProduct;

@property (nonatomic) NSArray <HPTPaymentProduct *> *paymentProducts;
@property (nonatomic) HPTPaymentPageRequest *paymentPageRequest;
@property (nonatomic) BOOL loading;

@end
