//
//  AbstractPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 28/10/2015.
//
//

#import "HPTAbstractPaymentProductViewController.h"

@interface HPTAbstractPaymentProductViewController ()

@end

@implementation HPTAbstractPaymentProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delaysContentTouches = NO;
    
    for (UIView *currentView in self.tableView.subviews) {
        if ([currentView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"PaymentScreenViews" ofType:@"bundle"]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HPTPaymentButtonTableViewCell" bundle:bundle] forCellReuseIdentifier:@"PaymentButton"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

@end
