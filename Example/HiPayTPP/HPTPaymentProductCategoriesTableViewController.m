//
//  HPTPaymentProductCategoriesTableViewController.m
//  HiPayTPP
//
//  Created by Jonathan Tiret on 29/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import "HPTPaymentProductCategoriesTableViewController.h"
#import <HiPayTPP/HiPayTPP.h>

@interface HPTPaymentProductCategoriesTableViewController ()

@end

@implementation HPTPaymentProductCategoriesTableViewController

- (instancetype)initWithSelectedPaymentProducts:(NSSet *)theSelectedPaymentProducts
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        selectedPaymentProducts = [NSMutableSet setWithSet:theSelectedPaymentProducts];
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        self.title = NSLocalizedString(@"FORM_PAYMENT_PRODUCT_CATEGORIES", nil);
    }
    return self;
}

- (NSSet *)selectedPaymentProducts
{
    return selectedPaymentProducts;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"FORM_PAYMENT_PRODUCTS_CREDIT_CARD", nil);
            
            if ([selectedPaymentProducts containsObject:HPTPaymentProductCategoryCodeCreditCard]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            break;
            
        case 1:
            cell.textLabel.text = NSLocalizedString(@"FORM_PAYMENT_PRODUCTS_DEBIT_CARD", nil);

            if ([selectedPaymentProducts containsObject:HPTPaymentProductCategoryCodeDebitCard]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            break;
            
        case 2:
            cell.textLabel.text = NSLocalizedString(@"FORM_PAYMENT_PRODUCTS_EWALLET", nil);

            if ([selectedPaymentProducts containsObject:HPTPaymentProductCategoryCodeEWallet]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }

            break;
            
        case 3:
            cell.textLabel.text = NSLocalizedString(@"FORM_PAYMENT_PRODUCTS_REALTIME_BANKING", nil);
            
            if ([selectedPaymentProducts containsObject:HPTPaymentProductCategoryCodeRealtimeBanking]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }

            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *currentCode = nil;
    
    switch (indexPath.row) {
        case 0:
            currentCode = HPTPaymentProductCategoryCodeCreditCard;
            break;
        case 1:
            currentCode = HPTPaymentProductCategoryCodeDebitCard;
            break;
        case 2:
            currentCode = HPTPaymentProductCategoryCodeEWallet;
            break;
        case 3:
            currentCode = HPTPaymentProductCategoryCodeRealtimeBanking;
            break;
    }
    
    if ([selectedPaymentProducts containsObject:currentCode]) {
        [selectedPaymentProducts removeObject:currentCode];
    }
    
    else {
        [selectedPaymentProducts addObject:currentCode];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
