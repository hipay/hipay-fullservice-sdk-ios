//
//  HPTDemoTableViewController.m
//  HiPayTPP
//
//  Created by Jonathan Tiret on 28/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import "HPTDemoTableViewController.h"
#import "HPTSwitchTableViewCell.h"
#import "HPTSegmentedControlTableViewCell.h"
#import "HPTStepperTableViewCell.h"
#import "HPTSubmitTableViewCell.h"
#import "HPTMoreOptionsTableViewCell.h"

@interface HPTDemoTableViewController ()

@end

@implementation HPTDemoTableViewController

- (void)awakeFromNib
{
    formSectionIndex = 0;
    resultSectionIndex = NSNotFound;
    
    groupedPaymentCardRowIndex = 0;
    currencyRowIndex = 1;
    amountRowIndex = 2;
    multiUseRowIndex = 3;
    authRowIndex = 4;
    colorRowIndex = 5;
    productCategoryRowIndex = 6;
    submitRowIndex = 7;
    
    // Default form values
    currencies = @[@"EUR", @"USD", @"GBP", @"RUB"];
    currencySegmentIndex = 0;
    authenticationIndicatorSegmentIndex = 0;
    colorSegmentIndex = 0;
    [self setupGlobalTintColor];
    multiUse = NO;
    groupedPaymentCard = YES;
    amount = 25.0;
    selectedPaymentProducts = [NSSet setWithObjects:HPTPaymentProductCategoryCodeRealtimeBanking, HPTPaymentProductCategoryCodeCreditCard, HPTPaymentProductCategoryCodeDebitCard, HPTPaymentProductCategoryCodeEWallet, nil];
    
    [self.tableView registerClass:[HPTSwitchTableViewCell class] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerClass:[HPTStepperTableViewCell class] forCellReuseIdentifier:@"StepperCell"];
    [self.tableView registerClass:[HPTSegmentedControlTableViewCell class] forCellReuseIdentifier:@"SegmentedControlCell"];
    [self.tableView registerClass:[HPTSubmitTableViewCell class] forCellReuseIdentifier:@"SubmitCell"];
    [self.tableView registerClass:[HPTMoreOptionsTableViewCell class] forCellReuseIdentifier:@"OptionsCell"];

    self.title = NSLocalizedString(@"APP_TITLE", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaultGlobalTintColor = self.view.tintColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupGlobalTintColor
{
    UIColor *tintColor;
    UIColor *onTintColor;
    
    switch (colorSegmentIndex) {
        case 0:
            tintColor = defaultGlobalTintColor;
            onTintColor = nil;
            break;
            
        case 1:
            onTintColor = tintColor = [UIColor redColor];
            break;
            
        case 2:
            onTintColor = tintColor = [UIColor purpleColor];
            break;
            
        default:
            break;
    }
    
    [[UIView appearance] setTintColor:tintColor];
    [[UISwitch appearance] setOnTintColor:onTintColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == formSectionIndex) {
        return 8;
    }

    return 0;
}

- (NSIndexPath *)indexPathForCellWithAccessoryView:(UIView *)accessoryView
{
    NSUInteger index = [self.tableView.visibleCells indexOfObjectPassingTest:^BOOL(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return obj.accessoryView == accessoryView;
    }];

    if (index != NSNotFound) {
        return [self.tableView indexPathForCell:self.tableView.visibleCells[index]];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == formSectionIndex) {

        if ((indexPath.row == groupedPaymentCardRowIndex) || (indexPath.row == multiUseRowIndex)) {
            
            HPTSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            [cell.switchControl addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            if (indexPath.row == groupedPaymentCardRowIndex) {
                cell.textLabel.text = NSLocalizedString(@"FORM_GROUP_PAYMENT_CARDS", nil);
                cell.switchControl.on = groupedPaymentCard;
            }
            
            else if (indexPath.row == multiUseRowIndex) {
                cell.textLabel.text = NSLocalizedString(@"FORM_MULTI_USE", nil);
                cell.switchControl.on = multiUse;
            }
            
            [cell layoutSubviews];
            
            return cell;

        }
        
        else if ((indexPath.row == authRowIndex) || (indexPath.row == currencyRowIndex) || (indexPath.row == colorRowIndex)) {
            
            HPTSegmentedControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentedControlCell" forIndexPath:indexPath];
            [cell.segmentedControl addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.segmentedControl removeAllSegments];
            
            if (indexPath.row == authRowIndex) {
                cell.textLabel.text = NSLocalizedString(@"FORM_AUTH", nil);
                
                [cell.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"FORM_AUTH_DEFAULT", nil) atIndex:0 animated:NO];
                [cell.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"FORM_AUTH_IF_AVAILABLE", nil) atIndex:1 animated:NO];
                [cell.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"FORM_AUTH_MANDATORY", nil) atIndex:2 animated:NO];
                [cell.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"FORM_AUTH_NONE", nil) atIndex:3 animated:NO];
                
                cell.segmentedControl.selectedSegmentIndex = authenticationIndicatorSegmentIndex;
            }
            
            else if (indexPath.row == colorRowIndex) {
                cell.textLabel.text = NSLocalizedString(@"FORM_COLOR", nil);
                
                [cell.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"FORM_COLOR_DEFAULT", nil) atIndex:0 animated:NO];
                [cell.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"FORM_COLOR_RED", nil) atIndex:1 animated:NO];
                [cell.segmentedControl insertSegmentWithTitle:NSLocalizedString(@"FORM_COLOR_PURPLE", nil) atIndex:2 animated:NO];
                
                cell.segmentedControl.selectedSegmentIndex = colorSegmentIndex;
            }
            
            else if (indexPath.row == currencyRowIndex) {
                cell.textLabel.text = NSLocalizedString(@"FORM_CURRENCY", nil);
                
                NSUInteger i = 0;
                
                for (NSString *theCurrency in currencies) {
                    [cell.segmentedControl insertSegmentWithTitle:theCurrency atIndex:i++ animated:NO];
                }
                
                cell.segmentedControl.selectedSegmentIndex = currencySegmentIndex;
            }
            
            [cell.segmentedControl sizeToFit];
            return cell;
        }
        
        else if (indexPath.row == amountRowIndex) {
            
            HPTStepperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StepperCell" forIndexPath:indexPath];
            [cell.stepper addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            cell.textLabel.text = NSLocalizedString(@"FORM_AMOUNT", nil);
            cell.stepper.value = amount;
            cell.stepper.stepValue = 0.5;
            cell.detailTextLabel.attributedText = [self formattedAmountWithMargin];
            
            return cell;
        }
        
        else if (indexPath.row == productCategoryRowIndex) {
            
            HPTMoreOptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionsCell" forIndexPath:indexPath];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)selectedPaymentProducts.count];
            cell.textLabel.text = NSLocalizedString(@"FORM_PAYMENT_PRODUCT_CATEGORIES", nil);
            
            return cell;
        }
        
        else if (indexPath.row == submitRowIndex) {
            
            HPTSubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubmitCell" forIndexPath:indexPath];
            
            cell.textLabel.text = NSLocalizedString(@"FORM_SUBMIT", nil);
            
            return cell;
        }
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == formSectionIndex) {
        return NSLocalizedString(@"FORM_TITLE", nil);
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == submitRowIndex) {
        
        HPTPaymentPageRequest *paymentPageRequest = [[HPTPaymentPageRequest alloc] init];
        
        paymentPageRequest.amount = @(amount);
        paymentPageRequest.currency = currencies[currencySegmentIndex];
        paymentPageRequest.orderId = [NSString stringWithFormat:@"TEST_SDK_IOS_%f", [NSDate date].timeIntervalSince1970];
        paymentPageRequest.shortDescription = @"Outstanding item";
        paymentPageRequest.customer.country = @"FR";
        paymentPageRequest.customer.firstname = @"John";
        paymentPageRequest.customer.lastname = @"Doe";
        paymentPageRequest.paymentCardGroupingEnabled = groupedPaymentCard;
        paymentPageRequest.multiUse = multiUse;
        paymentPageRequest.paymentProductCategoryList = selectedPaymentProducts.allObjects;
        
        switch (authenticationIndicatorSegmentIndex) {
            case 1:
                paymentPageRequest.authenticationIndicator = HPTAuthenticationIndicatorIfAvailable;
                break;
            case 2:
                paymentPageRequest.authenticationIndicator = HPTAuthenticationIndicatorMandatory;
                break;
            case 3:
                paymentPageRequest.authenticationIndicator = HPTAuthenticationIndicatorBypass;
                break;
        }
        
        /* You may define other request attributes like the customer email:
         paymentPageRequest.customer.email = @"john.doe@mywebsite.com";
         */
        
        HPTPaymentScreenViewController *paymentScreen = [HPTPaymentScreenViewController paymentScreenViewControllerWithRequest:paymentPageRequest];
        
        paymentScreen.delegate = self;
        
        [self presentViewController:paymentScreen animated:YES completion:nil];
    }
    
    else if (indexPath.row == productCategoryRowIndex) {
        productCategoriesViewController = [[HPTPaymentProductCategoriesTableViewController alloc] initWithSelectedPaymentProducts:selectedPaymentProducts];
        
        [self.navigationController pushViewController:productCategoriesViewController animated:YES];
    }
}

#pragma mark - Values

- (NSString *)formattedAmount
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    numberFormatter.currencyCode = currencies[currencySegmentIndex];
    
    return [numberFormatter stringFromNumber:@(amount)];
}

- (NSAttributedString *)formattedAmountWithMargin
{
    NSString *formattedAmount = [self formattedAmount];
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:formattedAmount];
    
    [result addAttribute:NSKernAttributeName value:@(7) range:NSMakeRange(formattedAmount.length - 1, 1)];

    return result;
}

- (void)updateAmount
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:amountRowIndex inSection:formSectionIndex]];
    
    cell.detailTextLabel.attributedText = [self formattedAmountWithMargin];
    
    [cell layoutSubviews];
}

- (void)controlValueChanged:(id)sender
{
    NSIndexPath *indexPath = [self indexPathForCellWithAccessoryView:sender];
    
    if (indexPath.row == groupedPaymentCardRowIndex) {
        groupedPaymentCard = [sender isOn];
    }
    
    else if (indexPath.row == multiUseRowIndex) {
        multiUse = [sender isOn];
    }
    
    else if (indexPath.row == authRowIndex) {
        authenticationIndicatorSegmentIndex = [sender selectedSegmentIndex];
    }

    else if (indexPath.row == currencyRowIndex) {
        currencySegmentIndex = [sender selectedSegmentIndex];
        [self updateAmount];
    }
    
    else if (indexPath.row == colorRowIndex) {
        colorSegmentIndex = [sender selectedSegmentIndex];
        [self setupGlobalTintColor];
        [self.tableView reloadData];
    }
    
    else if (indexPath.row == amountRowIndex) {
        amount = [(UIStepper *)sender value];
        [self updateAmount];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    if (productCategoriesViewController != nil) {
        selectedPaymentProducts = productCategoriesViewController.selectedPaymentProducts;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:productCategoryRowIndex inSection:formSectionIndex]] withRowAnimation:UITableViewRowAnimationFade];
        productCategoriesViewController = nil;
    }
}

@end
