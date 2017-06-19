//
//  HPFApplePayTableViewCell.h
//  Pods
//
//  Created by Nicolas FILLION on 14/06/2017.
//
//

#import <UIKit/UIKit.h>
#import <PassKit/PassKit.h>

@class HPFApplePayTableViewCell;

@protocol HPFApplePayTableViewCellDelegate <NSObject>

@required

- (void)applePayButtonTableViewCellDidTouchButton:(HPFApplePayTableViewCell *)cell;

@end


@interface HPFApplePayTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HPFApplePayTableViewCellDelegate> delegate;

@end
