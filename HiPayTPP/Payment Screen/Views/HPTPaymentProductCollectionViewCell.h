//
//  HPTPaymentProductCollectionViewCell.h
//  Pods
//
//  Created by Jonathan TIRET on 26/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTPaymentProduct.h"
#import "HPTPaymentProductButton.h"

@class HPTPaymentProductCollectionViewCell;

@protocol HPTPaymentProductCollectionViewCellDelegate <NSObject>

@required

- (void)paymentProductCollectionViewCellDidTouchButton:(HPTPaymentProductCollectionViewCell *)cell;

@end

@interface HPTPaymentProductCollectionViewCell : UICollectionViewCell

@property (nonatomic) HPTPaymentProduct *paymentProduct;
@property (nonatomic, readonly) HPTPaymentProductButton *paymentProductButton;
@property (nonatomic, weak) id<HPTPaymentProductCollectionViewCellDelegate> delegate;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

@end
