//
//  HPTQiwiWalletPaymentProductViewController.m
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import "HPTQiwiWalletPaymentProductViewController.h"
#import "HPTOrderRequest.h"
#import "HPTForwardPaymentProductViewController_Protected.h"

@implementation HPTQiwiWalletPaymentProductViewController

- (HPTOrderRequest *)createOrderRequest
{
    HPTOrderRequest *orderRequest = [super createOrderRequest];
    
    

    return orderRequest;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}

@end
