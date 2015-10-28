//
//  PaymentButtonTableViewCell.h
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import <UIKit/UIKit.h>

@class HPTPaymentButtonTableViewCell;

@protocol HPTPaymentButtonTableViewCellDelegate <NSObject>

@required

- (void)paymentButtonTableViewCellDidTouchButton:(HPTPaymentButtonTableViewCell *)cell;

@end

@interface HPTPaymentButtonTableViewCell : UITableViewCell
{
    __weak IBOutlet UIButton *button;
    __weak IBOutlet UIActivityIndicatorView *spinner;
}

@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic, weak) id<HPTPaymentButtonTableViewCellDelegate> delegate;

@end
