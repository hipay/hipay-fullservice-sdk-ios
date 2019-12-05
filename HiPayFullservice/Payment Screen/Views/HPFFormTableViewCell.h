//
//  HPFFormTableViewCell.h
//  Pods
//
//  Created by HiPay on 06/11/2015.
//
//

#import <UIKit/UIKit.h>

@interface HPFFormTableViewCell : UITableViewCell
{
    UIColor *defaultTextLabelColor;
}

@property (nonatomic) BOOL incorrectInput;
@property (nonatomic) BOOL enabled;

@end
