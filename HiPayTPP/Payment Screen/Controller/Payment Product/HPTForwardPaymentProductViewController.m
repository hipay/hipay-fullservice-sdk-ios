//
//  HPTForwardPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 27/10/2015.
//
//

#import "HPTForwardPaymentProductViewController.h"
#import "HPTGatewayClient.h"
#import <SafariServices/SafariServices.h>
#import <WebKit/WebKit.h>
#import "HPTForwardViewController.h"
#import "HPTAbstractPaymentProductViewController_Protected.h"
#import "HPTPaymentScreenLocalization.h"

@interface HPTForwardPaymentProductViewController ()

@end

@implementation HPTForwardPaymentProductViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return HPTLocalizedString(@"PAYMENT_REDIRECTION_DETAILS");
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [super dequeuePaymentButtonCell];
}


@end
