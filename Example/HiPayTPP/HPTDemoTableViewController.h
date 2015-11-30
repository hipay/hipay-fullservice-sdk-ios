//
//  HPTDemoTableViewController.h
//  HiPayTPP
//
//  Created by Jonathan Tiret on 28/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HiPayTPP/HiPayTPP.h>
#import "HPTPaymentProductCategoriesTableViewController.h"

@interface HPTDemoTableViewController : UITableViewController <HPTPaymentScreenViewControllerDelegate>
{
    // Form rows
    NSUInteger groupedPaymentCardRowIndex;
    NSUInteger currencyRowIndex;
    NSUInteger amountRowIndex;
    NSUInteger multiUseRowIndex;
    NSUInteger authRowIndex;
    NSUInteger productCategoryRowIndex;
    NSUInteger submitRowIndex;
    NSUInteger colorRowIndex;
    
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
    HPTTransaction *transaction;
    
    // Form values
    NSArray *currencies;
    BOOL groupedPaymentCard;
    BOOL multiUse;
    NSUInteger currencySegmentIndex;
    NSUInteger colorSegmentIndex;
    NSUInteger authenticationIndicatorSegmentIndex;
    CGFloat amount;
    NSSet *selectedPaymentProducts;
    UIColor *defaultGlobalTintColor;
    
    HPTPaymentProductCategoriesTableViewController *productCategoriesViewController;
}

@end
