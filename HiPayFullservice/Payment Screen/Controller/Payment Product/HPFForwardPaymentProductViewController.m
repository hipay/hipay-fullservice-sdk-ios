//
//  HPFForwardPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 27/10/2015.
//
//

#import "HPFForwardPaymentProductViewController.h"
#import "HPFGatewayClient.h"
#import <SafariServices/SafariServices.h>
#import <WebKit/WebKit.h>
#import "HPFForwardViewController.h"
#import "HPFAbstractPaymentProductViewController_Protected.h"
#import "HPFPaymentScreenUtils.h"

@interface HPFForwardPaymentProductViewController ()

@end

@implementation HPFForwardPaymentProductViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) savePaymentMethod:(HPFPaymentMethod *)paymentMethod {
    //no-op
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == (self.tableView.numberOfSections - 1)) {
        return HPFLocalizedString(@"PAYMENT_REDIRECTION_DETAILS");
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [super dequeuePaymentButtonCell];
}


@end
