//
//  HPFPaymentCardSwitchTableHeaderView.h
//  Pods
//
//  Created by HiPay on 26/10/2016.
//
//

#import <UIKit/UIKit.h>

@interface HPFPaymentCardSwitchTableHeaderView : UITableViewHeaderFooterView
{
    __weak IBOutlet UILabel *saveTextLabel;
}

@property (nonatomic) __weak IBOutlet UISwitch *saveSwitch;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end
