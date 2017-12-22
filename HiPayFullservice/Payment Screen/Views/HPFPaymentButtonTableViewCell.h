//
//  PaymentButtonTableViewCell.h
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import <UIKit/UIKit.h>

@class HPFPaymentButtonTableViewCell;

@protocol HPFPaymentButtonTableViewCellDelegate <NSObject>

@required

- (void)paymentButtonTableViewCellDidTouchButton:(HPFPaymentButtonTableViewCell *)cell;

@end

@interface HPFPaymentButtonTableViewCell : UITableViewCell
{
    __weak IBOutlet UIButton *button;
    __weak IBOutlet UIActivityIndicatorView *spinner;
}

@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic) NSString *title;
@property (nonatomic, weak) id<HPFPaymentButtonTableViewCellDelegate> delegate;

@end
