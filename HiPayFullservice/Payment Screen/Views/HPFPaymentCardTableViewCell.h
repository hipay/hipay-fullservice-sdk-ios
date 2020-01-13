//
//  HPFPaymentCardTableViewCell.h
//  Pods
//
//  Created by HiPay on 27/10/2016.
//
//

#import <UIKit/UIKit.h>

@interface HPFPaymentCardTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UIImageView *cardImageView;
@property (nonatomic) IBOutlet UILabel *panLabel;
@property (nonatomic) IBOutlet UILabel *bankLabel;
@property (nonatomic) IBOutlet NSLayoutConstraint *dependencyConstraint;

- (void) removeDependency;
- (void) addDependency;

@end
