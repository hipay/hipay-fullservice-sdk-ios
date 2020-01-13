//
//  HPFTextInputTableViewCell.h
//  HiPayFullservice_Example
//
//  Created by HiPay on 06/12/2018.
//  Copyright © 2018 HiPay. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPFTextInputTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end

NS_ASSUME_NONNULL_END
