//
//  HPFPaymentProductCollectionViewCell.h
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPFPaymentProduct.h"
#import "HPFPaymentProductButton.h"

@class HPFPaymentProductCollectionViewCell;

@protocol HPFPaymentProductCollectionViewCellDelegate <NSObject>

@required

- (void)paymentProductCollectionViewCellDidTouchButton:(HPFPaymentProductCollectionViewCell *)cell;

@end

@interface HPFPaymentProductCollectionViewCell : UICollectionViewCell

@property (nonatomic) HPFPaymentProduct *paymentProduct;
@property (nonatomic, readonly) HPFPaymentProductButton *paymentProductButton;
@property (nonatomic, weak) id<HPFPaymentProductCollectionViewCellDelegate> delegate;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

@end
