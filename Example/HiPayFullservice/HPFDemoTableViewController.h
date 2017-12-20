//
//  HPFDemoTableViewController.h
//  HiPayFullservice
//
//  Created by Jonathan Tiret on 28/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HiPayFullservice/HiPayFullservice.h>
#import "HPFPaymentProductCategoriesTableViewController.h"
#import "HPFSubmitTableViewCell.h"
#import "HPFStoreCardViewController.h"

@interface HPFDemoTableViewController : UITableViewController <HPFPaymentScreenViewControllerDelegate, HPFSubmitableViewCellDelegate, HPFStoreCardDelegate>
{
    // Form rows
    NSUInteger groupedPaymentCardRowIndex;
    NSUInteger currencyRowIndex;
    NSUInteger amountRowIndex;
    NSUInteger applePayRowIndex;
    NSUInteger multiUseRowIndex;
    NSUInteger cardScanRowIndex;
    NSUInteger authRowIndex;
    NSUInteger productCategoryRowIndex;
    NSUInteger submitRowIndex;
    NSUInteger colorRowIndex;
    NSUInteger storeCardIndex;
    
    // Error rows
    NSUInteger errorDescriptionRowIndex;
    NSUInteger transactionStateRowIndex;
    NSUInteger fraudReviewRowIndex;
    NSUInteger cancelRowIndex;
    
    // Sections
    NSUInteger formSectionIndex;
    NSUInteger resultSectionIndex;
    BOOL insertResultSection;
    
    // Result
    NSError *transactionError;
    HPFTransaction *transaction;
    
    // Form values
    NSArray *currencies;
    BOOL groupedPaymentCard;
    BOOL applePay;
    BOOL multiUse;
    BOOL cardScan;

    NSUInteger currencySegmentIndex;
    NSUInteger colorSegmentIndex;
    NSUInteger authenticationIndicatorSegmentIndex;
    CGFloat amount;
    NSSet *selectedPaymentProducts;
    UIColor *defaultGlobalTintColor;
    BOOL loading;

    HPFPaymentProductCategoriesTableViewController *productCategoriesViewController;
}

@end
