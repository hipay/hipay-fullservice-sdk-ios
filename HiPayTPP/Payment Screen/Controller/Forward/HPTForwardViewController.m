//
//  HPTForwardViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import "HPTForwardViewController.h"
#import "HPTForwardSafariViewController.h"

@interface HPTForwardViewController ()

@end

@implementation HPTForwardViewController

- (instancetype)initWithTransaction:(HPTTransaction *)transaction
{
    self = [super init];
    if (self) {
        _transaction = transaction;
    }
    return self;
}

- (instancetype)initWithHostedPaymentPage:(HPTHostedPaymentPage *)hostedPaymentPage
{
    self = [super init];
    if (self) {
        _hostedPaymentPage = hostedPaymentPage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (HPTForwardViewController *)relevantForwardViewControllerWithTransaction:(HPTTransaction *)transaction
{
    return [[HPTForwardSafariViewController alloc] initWithTransaction:transaction];
}

+ (HPTForwardViewController *)relevantForwardViewControllerWithHostedPaymentPage:(HPTHostedPaymentPage *)hostedPaymentPage
{
    return [[HPTForwardSafariViewController alloc] initWithHostedPaymentPage:hostedPaymentPage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
