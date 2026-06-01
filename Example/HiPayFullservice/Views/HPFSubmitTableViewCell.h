//
//  HPFSubmitTableViewCell.h
//  HiPayFullservice
//
//  Created by HiPay on 29/11/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPFSubmitTableViewCell;

@protocol HPFSubmitableViewCellDelegate <NSObject>

@required

- (void)submitTableViewCellDidTouchButton:(HPFSubmitTableViewCell *)cell;

@end

@interface HPFSubmitTableViewCell : UITableViewCell

{
    __weak IBOutlet UIActivityIndicatorView *spinner;
}

@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic, weak) id<HPFSubmitableViewCellDelegate> delegate;

@end
