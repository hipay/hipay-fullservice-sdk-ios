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
    
    __weak IBOutlet UIView *containerView;
    
    __weak IBOutlet NSLayoutConstraint *containerBottomConstraint;
    
    __weak IBOutlet UIActivityIndicatorView *spinner;
    __weak IBOutlet UITableView *paymentProductsTableView;
    __weak IBOutlet NSLayoutConstraint *paymentProductsTableViewHeightConstraint;
    
    NSLayoutConstraint *keyboardContainerConstraintTop;
    NSLayoutConstraint *keyboardContainerConstraintBottom;
}

@property (nonatomic) NSArray *paymentProducts;
@property (nonatomic) HPTPaymentPageRequest *paymentPageRequest;

@end
