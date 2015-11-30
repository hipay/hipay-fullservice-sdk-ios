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

    NSUInteger formSectionIndex;
    NSUInteger resultSectionIndex;
    
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
