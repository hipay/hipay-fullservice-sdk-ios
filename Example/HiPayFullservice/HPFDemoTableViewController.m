//
//  HPFDemoTableViewController.m
//  HiPayFullservice
//
//  Created by Jonathan Tiret on 28/11/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//

#import "HPFDemoTableViewController.h"
#import "HPFSwitchTableViewCell.h"
#import "HPFSegmentedControlTableViewCell.h"
#import "HPFStepperTableViewCell.h"
#import "HPFMoreOptionsTableViewCell.h"
#import "HPFInfoTableViewCell.h"
#import "HPFSwitchInfosTableViewCell.h"
#import "HPFTokenizableCardPaymentProductViewController.h"

@interface HPFDemoTableViewController ()

@end

@implementation HPFDemoTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Section indexes
    formSectionIndex = 0;
    resultSectionIndex = NSNotFound;
    
    // Form row indexes
    groupedPaymentCardRowIndex = 0;
    currencyRowIndex = 1;
    amountRowIndex = 2;
    applePayRowIndex = 3;
    multiUseRowIndex = 4;
    cardScanRowIndex = 5;
    authRowIndex = 6;
    colorRowIndex = 7;
    productCategoryRowIndex = 8;
    submitRowIndex = 9;
    
    // Error row indexes
    resultSectionIndex = NSNotFound;
    errorDescriptionRowIndex = NSNotFound;
    transactionStateRowIndex = NSNotFound;
    fraudReviewRowIndex = NSNotFound;
    cancelRowIndex = NSNotFound;
    
    // Default form values
    insertResultSection = NO;
    currencies = @[@"EUR", @"USD", @"BRL", @"RUB"];
    currencySegmentIndex = 0;
    authenticationIndicatorSegmentIndex = 3;
    colorSegmentIndex = 0;
    [self setupGlobalTintColor];
    groupedPaymentCard = YES;
    amount = 10.f;
    selectedPaymentProducts = [NSSet setWithObjects:HPFPaymentProductCategoryCodeRealtimeBanking, HPFPaymentProductCategoryCodeCreditCard, HPFPaymentProductCategoryCodeDebitCard, HPFPaymentProductCategoryCodeEWallet, nil];
    
    [self.tableView registerClass:[HPFSwitchTableViewCell class] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerClass:[HPFStepperTableViewCell class] forCellReuseIdentifier:@"StepperCell"];
    [self.tableView registerClass:[HPFSegmentedControlTableViewCell class] forCellReuseIdentifier:@"SegmentedControlCell"];
    [self.tableView registerClass:[HPFMoreOptionsTableViewCell class] forCellReuseIdentifier:@"OptionsCell"];
    [self.tableView registerClass:[HPFInfoTableViewCell class] forCellReuseIdentifier:@"LabelCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"HPFSubmitTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SubmitCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"HPFSwitchInfosTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SwitchInfosCell"];
    
    self.title = NSLocalizedString(@"APP_TITLE", nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaultGlobalTintColor = self.view.tintColor;

    if ([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (insertResultSection) {
        insertResultSection = NO;
        resultSectionIndex = 1;

        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:resultSectionIndex] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:resultSectionIndex] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    multiUse = [HPFClientConfig.sharedClientConfig isPaymentCardStorageEnabled];

    cardScan = [HPFClientConfig.sharedClientConfig isPaymentCardScanEnabled];

    applePay = [HPFClientConfig.sharedClientConfig isApplePayEnabled];

    if (productCategoriesViewController != nil) {
        selectedPaymentProducts = productCategoriesViewController.selectedPaymentProducts;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:productCategoryRowIndex inSection:formSectionIndex]] withRowAnimation:UITableViewRowAnimationFade];
        productCategoriesViewController = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (resultSectionIndex == NSNotFound) {
        return 1;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == formSectionIndex) {
        return 10;
    }
    
    if (section == resultSectionIndex) {
        if (fraudReviewRowIndex != NSNotFound) {
            return 2;
        }
        
        return 1;
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

- (void)setSubmitButtonLoadingMode:(BOOL)isLoading
{
    loading = isLoading;

    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if ([cell isKindOfClass:[HPFSubmitTableViewCell class]]) {
            ((HPFSubmitTableViewCell *)cell).loading = isLoading;
        }
    }
}

- (BOOL)submitButtonEnabled
{
    return !loading;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == formSectionIndex) {

        if ((indexPath.row == groupedPaymentCardRowIndex) || (indexPath.row == multiUseRowIndex) || (indexPath.row == cardScanRowIndex)) {
            
            HPFSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
            [cell.switchControl addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            if (indexPath.row == groupedPaymentCardRowIndex) {
                cell.textLabel.text = NSLocalizedString(@"FORM_GROUP_PAYMENT_CARDS", nil);
                cell.switchControl.on = groupedPaymentCard;
            }

            else if (indexPath.row == applePayRowIndex) {
                cell.textLabel.text = NSLocalizedString(@"FORM_APPLE_PAY", nil);
                cell.switchControl.on = applePay;
            }

            else if (indexPath.row == multiUseRowIndex) {
                cell.textLabel.text = NSLocalizedString(@"FORM_CARD_STORAGE", nil);
                cell.switchControl.on = multiUse;
            }

            else if (indexPath.row == cardScanRowIndex) {
                cell.textLabel.text = NSLocalizedString(@"FORM_CARD_SCAN", nil);
                cell.switchControl.on = cardScan;
            }

            [cell layoutSubviews];
            
            return cell;

        } else if (indexPath.row == applePayRowIndex) {
            
            HPFSwitchInfosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchInfosCell" forIndexPath:indexPath];
            cell.label.text = NSLocalizedString(@"FORM_APPLE_PAY", nil);
            cell.labelInfos.text = NSLocalizedString(@"FORM_APPLE_PAY_INFOS", nil);

            [cell.switchControl addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.switchControl.on = applePay;
            
            return cell;
            
        } else if ((indexPath.row == authRowIndex) || (indexPath.row == currencyRowIndex) || (indexPath.row == colorRowIndex)) {
            
            HPFSegmentedControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentedControlCell" forIndexPath:indexPath];
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
            
            HPFStepperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StepperCell" forIndexPath:indexPath];
            [cell.stepper addTarget:self action:@selector(controlValueChanged:) forControlEvents:UIControlEventValueChanged];
            
            cell.textLabel.text = NSLocalizedString(@"FORM_AMOUNT", nil);
            cell.stepper.value = amount;
            cell.stepper.stepValue = 0.5;
            cell.stepper.maximumValue = 1000.0;
            cell.stepper.minimumValue = 1.0;
            cell.detailTextLabel.attributedText = [self formattedAmountWithMargin];
            
            return cell;
        }
        
        else if (indexPath.row == productCategoryRowIndex) {
            
            HPFMoreOptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionsCell" forIndexPath:indexPath];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)selectedPaymentProducts.count];
            cell.textLabel.text = NSLocalizedString(@"FORM_PAYMENT_PRODUCT_CATEGORIES", nil);
            
            return cell;
        }
        
        else if (indexPath.row == submitRowIndex) {

            HPFSubmitTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SubmitCell"];

            cell.loading = loading;
            cell.enabled = [self submitButtonEnabled];
            cell.delegate = self;

            //HPFSubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubmitCell" forIndexPath:indexPath];
            //cell.textLabel.text = NSLocalizedString(@"FORM_SUBMIT", nil);
            
            return cell;
        }
        
    }

    else {
        
        if (indexPath.row == cancelRowIndex) {
            
            HPFSubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"RESULT_CANCEL", nil);
            cell.detailTextLabel.text = nil;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:cell.detailTextLabel.font.pointSize];

            return cell;
        }
        
        else if (indexPath.row == errorDescriptionRowIndex) {
            
            HPFSubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"RESULT_ERROR", nil);
            cell.detailTextLabel.font = [UIFont italicSystemFontOfSize:cell.detailTextLabel.font.pointSize];
            
            if (transactionError.userInfo[HPFErrorCodeAPIMessageKey] != nil) {
                cell.detailTextLabel.text = transactionError.userInfo[HPFErrorCodeAPIMessageKey];
            } else {
                cell.detailTextLabel.text = transactionError.localizedDescription;
            }
            
            return cell;
        }
        
        else if (indexPath.row == transactionStateRowIndex) {
            
            HPFSubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"RESULT_STATE", nil);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:cell.detailTextLabel.font.pointSize];
            
            switch (transaction.state) {
                case HPFTransactionStateCompleted:
                    cell.detailTextLabel.text = NSLocalizedString(@"RESULT_STATE_COMPLETED", nil);
                    break;
                    
                case HPFTransactionStatePending:
                    cell.detailTextLabel.text = NSLocalizedString(@"RESULT_STATE_PENDING", nil);
                    break;
                    
                case HPFTransactionStateForwarding:
                    cell.detailTextLabel.text = NSLocalizedString(@"RESULT_STATE_FORWARDING", nil);
                    break;
                    
                case HPFTransactionStateError:
                    cell.detailTextLabel.text = NSLocalizedString(@"RESULT_STATE_ERROR", nil);
                    break;
                    
                case HPFTransactionStateDeclined:
                    cell.detailTextLabel.text = NSLocalizedString(@"RESULT_STATE_DECLINED", nil);
                    break;
                    
                default:
                    break;
            }
            
            return cell;
        }
        
        else if (indexPath.row == fraudReviewRowIndex) {
            
            HPFSubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"RESULT_FRAUD", nil);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:cell.detailTextLabel.font.pointSize];

            switch (transaction.fraudScreening.result) {
                case HPFFraudScreeningResultAccepted:
                    cell.detailTextLabel.text = NSLocalizedString(@"RESULT_FRAUD_ACCEPTED", nil);
                    break;
                    
                case HPFFraudScreeningResultBlocked:
                    cell.detailTextLabel.text = NSLocalizedString(@"RESULT_FRAUD_BLOCKED", nil);
                    break;
                    
                case HPFFraudScreeningResultPending:
                    cell.detailTextLabel.text = NSLocalizedString(@"RESULT_FRAUD_PENDING", nil);
                    break;
                    
                case HPFFraudScreeningResultChallenged:
                    cell.detailTextLabel.text = NSLocalizedString(@"RESULT_FRAUD_CHALLENGED", nil);
                    break;
                    
                default:
                    break;
            }
            
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
    
    if (section == resultSectionIndex) {
        return NSLocalizedString(@"RESULT_TITLE", nil);
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == applePayRowIndex) {
        return 72.f;
    }
    
    return UITableViewAutomaticDimension;
}

- (void)submitTableViewCellDidTouchButton:(HPFPaymentButtonTableViewCell *)cell
{
    [self requestSignature];

    if (resultSectionIndex != NSNotFound) {
        errorDescriptionRowIndex = NSNotFound;
        transactionStateRowIndex = NSNotFound;
        fraudReviewRowIndex = NSNotFound;
        cancelRowIndex = NSNotFound;

        resultSectionIndex = NSNotFound;
        formSectionIndex = 0;

        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (void) requestSignature {

    [self setSubmitButtonLoadingMode:YES];

    static NSString * const serverUrl = @"https://developer.hipay.com/misc/public_credentials_signature.php?amount=%@&currency=%@";
    NSString *dataUrl = [NSString stringWithFormat:serverUrl, @(amount), currencies[currencySegmentIndex]];
    NSURL *url = [NSURL URLWithString:dataUrl];

    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
            dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                dispatch_async(dispatch_get_main_queue(), ^{

                    NSError *jsonError = nil;
                    if (data == nil || error != nil) {
                        // Handle Error and return
                        [self setSubmitButtonLoadingMode:NO];
                        return;
                    }

                    NSDictionary* signatureDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

                    if (jsonError == nil) {

                        NSString *orderId = signatureDictionary[@"order_id"];
                        NSString *signature = signatureDictionary[@"signature"];

                        HPFPaymentPageRequest *paymentPageRequest = [self buildPageRequestWithOrderId:orderId];

                        //HPFPaymentScreenViewController *paymentScreen = [HPFPaymentScreenViewController paymentScreenViewControllerWithRequest:paymentPageRequest signature:signature];
                        //paymentScreen.delegate = self;

                        /*
                        HPFTokenizableCardPaymentProductViewController *paymentProductViewController = [[HPFTokenizableCardPaymentProductViewController alloc] initWithPaymentPageRequest:paymentPageRequest signature:signature andSelectedPaymentProduct:[[HPFPaymentProduct alloc] initWithApplePayProduct] ];

                        UIStoryboard *storyboard = [UIStoryboad storyboardWithName:@"StoreCard" bundle:HPFPaymentScreenViewsBundle()];
                        HPFPaymentScreenViewController *viewController = [storyboard instantiateInitialViewController];
                        
                        [viewController setParameters:paymentPageRequest signature:signature];
                        */
                        HPFStoreCardViewController *storeCardViewController = [HPFStoreCardViewController storeCardViewControllerWithRequest:paymentPageRequest signature:signature];

                        
                        [self presentViewController:storeCardViewController animated:YES completion:^{
                            [self setSubmitButtonLoadingMode:NO];
                        }];
                        
                        

                    } else {

                        [self setSubmitButtonLoadingMode:NO];
                    }

                });

            }];

    [downloadTask resume];

}

- (HPFPaymentPageRequest *) buildPageRequestWithOrderId:(NSString *)orderId {

    HPFPaymentPageRequest *paymentPageRequest = [[HPFPaymentPageRequest alloc] init];
    paymentPageRequest.orderId = orderId;
    //paymentPageRequest.orderId = [NSString stringWithFormat:@"TEST_SDK_IOS_%ld", (long) ([NSDate date].timeIntervalSince1970)];

    paymentPageRequest.amount = @(amount);
    paymentPageRequest.currency = currencies[currencySegmentIndex];
    paymentPageRequest.shortDescription = @"Outstanding item";
    paymentPageRequest.customer.country = @"FR";
    paymentPageRequest.customer.firstname = @"John";
    paymentPageRequest.customer.lastname = @"Doe";
    paymentPageRequest.paymentCardGroupingEnabled = groupedPaymentCard;
    paymentPageRequest.multiUse = multiUse;

    [HPFClientConfig.sharedClientConfig setPaymentCardStorageEnabled:multiUse];

    [HPFClientConfig.sharedClientConfig setPaymentCardScanEnabled:cardScan];

    [HPFClientConfig.sharedClientConfig setApplePayEnabled:applePay privateKeyPassword:@"test" merchantIdentifier:@"merchant.com.hipay.qa"];

    paymentPageRequest.paymentProductCategoryList = selectedPaymentProducts.allObjects;

    switch (authenticationIndicatorSegmentIndex) {
        case 1:
            paymentPageRequest.authenticationIndicator = HPFAuthenticationIndicatorIfAvailable;
            break;
        case 2:
            paymentPageRequest.authenticationIndicator = HPFAuthenticationIndicatorMandatory;
            break;
        case 3:
            paymentPageRequest.authenticationIndicator = HPFAuthenticationIndicatorBypass;
            break;
    }

    return paymentPageRequest;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.row == submitRowIndex) {}

    if (indexPath.row == productCategoryRowIndex) {
        productCategoriesViewController = [[HPFPaymentProductCategoriesTableViewController alloc] initWithSelectedPaymentProducts:selectedPaymentProducts];
        
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

    else if (indexPath.row == applePayRowIndex) {
        applePay = [sender isOn];
    }

    else if (indexPath.row == multiUseRowIndex) {
        multiUse = [sender isOn];
    }

    else if (indexPath.row == cardScanRowIndex) {
        cardScan = [sender isOn];
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
            onTintColor = tintColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.02 alpha:1.0];
            break;
            
        case 2:
            onTintColor = tintColor = [UIColor purpleColor];
            break;
            
        default:
            break;
    }

    self.view.tintColor = tintColor;
    self.navigationController.view.tintColor = tintColor;
    [[UIView appearance] setTintColor:tintColor];
    [[UISwitch appearance] setOnTintColor:onTintColor];
}

#pragma mark - Payment screen result

- (void)paymentScreenViewController:(HPFPaymentScreenViewController *)viewController didEndWithTransaction:(HPFTransaction *)theTransaction
{
    transaction = theTransaction;
    transactionStateRowIndex = 0;
    
    if (transaction.fraudScreening != nil && transaction.fraudScreening.result != HPFFraudScreeningResultUnknown) {
        fraudReviewRowIndex = 1;
    }
    
    [self insertResultSection];
}

- (void)paymentScreenViewController:(HPFPaymentScreenViewController *)viewController didFailWithError:(NSError *)error
{
    transactionError = error;
    errorDescriptionRowIndex = 0;
    
    [self insertResultSection];
}

- (void)paymentScreenViewControllerDidCancel:(HPFPaymentScreenViewController *)viewController
{
    cancelRowIndex = 0;
    [self insertResultSection];
}

- (void)insertResultSection
{
    insertResultSection = YES;
}

@end
