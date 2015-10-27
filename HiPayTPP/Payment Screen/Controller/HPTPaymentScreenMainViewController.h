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

@interface HPTPaymentScreenMainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, HPTPaymentProductCollectionViewCellDelegate>
{
    __weak IBOutlet UICollectionView *paymentProductsCollectionView;
    
    __weak IBOutlet UILabel *amountLabel;
}

@property (nonatomic) NSArray *paymentProducts;

@end
