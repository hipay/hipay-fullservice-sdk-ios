//
//  HPFPaymentCardsScreenViewController.m
//  Pods
//
//  Created by Nicolas FILLION on 25/10/2016.
//
//

#import "HPFPaymentCardsScreenViewController.h"
#import "HPFPaymentScreenUtils.h"
#import "HPFPaymentScreenMainViewController.h"
#import "HPFPaymentCardToken.h"
#import "HPFOrderRequest.h"
#import "HPFGatewayClient.h"
#import "HPFPaymentCardTokenDatabase.h"
#import "HPFPaymentCardTableViewCell.h"
#import "HPFTransactionRequestResponseManager.h"
#import <LocalAuthentication/LAContext.h>

@interface HPFPaymentCardsScreenViewController () {

    id<HPFRequest> transactionLoadingRequest;
    HPFTransaction *transaction;
}

@property (strong, nonatomic) IBOutlet UITableView *tableCards;
@property (nonatomic, strong) NSMutableArray *selectedCards;
@property (nonatomic, strong) NSMutableArray *selectedCardsObjects;

@property (nonatomic, strong) NSArray *cardsTouchID;

@property (nonatomic, getter=isPayButtonActive) BOOL payButtonActive;
@property (nonatomic, getter=isPayButtonLoading) BOOL payButtonLoading;

@end

@implementation HPFPaymentCardsScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = HPFLocalizedString(@"PAYMENT_CARDS_SCREEN_TITLE");
    [self.tableCards registerNib:[UINib nibWithNibName:@"HPFPaymentButtonTableViewCell" bundle:HPFPaymentScreenViewsBundle()] forCellReuseIdentifier:@"PaymentButton"];

    id<HPFPaymentProductViewControllerDelegate> paymentProductViewDelegate = (id<HPFPaymentProductViewControllerDelegate>) self.parentViewController.parentViewController;
    self.delegate = paymentProductViewDelegate;
}

- (void) setupCards {

    self.payButtonActive = NO;
    self.payButtonLoading = NO;

    self.selectedCardsObjects = [[HPFPaymentCardTokenDatabase paymentCardTokensForCurrency:self.paymentPageRequest.currency] mutableCopy];

    self.cardsTouchID = [HPFPaymentCardTokenDatabase paymentCardTokensTouchIDForCurrency:self.paymentPageRequest.currency];

    NSMutableArray *cards = [NSMutableArray arrayWithCapacity:[self.selectedCardsObjects count]];
    for (int i = 0; i < self.selectedCardsObjects.count; ++i) {
        [cards addObject:@NO];
    }

    self.selectedCards = cards;

    [self.tableCards reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self cancelRequests];

    [self.delegate cancelActivity];
    self.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setupCards];
}

- (void)paymentButtonTableViewCellDidTouchButton:(HPFPaymentButtonTableViewCell *)cell {

    [self checkTouchID];
}

- (void)cancelRequests
{
    [transactionLoadingRequest cancel];
}

#pragma mark - Handle transaction


- (void)checkTransactionError:(NSError *)transactionError
{
    
    [HPFTransactionRequestResponseManager sharedManager].delegate = self;
    [[HPFTransactionRequestResponseManager sharedManager] manageError:transactionError withCompletionHandler:^(HPFTransactionErrorResult *result) {

        if(result.formAction == HPFFormActionQuit) {
            [self.delegate paymentProductViewController:nil didFailWithError:transactionError];
        }

        [self checkRequestResultStatus:result];

    }];
}

- (void)checkTransactionStatus:(HPFTransaction *)theTransaction
{
    
    [HPFTransactionRequestResponseManager sharedManager].delegate = self;
    [[HPFTransactionRequestResponseManager sharedManager] manageTransaction:theTransaction withCompletionHandler:^(HPFTransactionErrorResult *result) {

        if(result.formAction == HPFFormActionQuit) {

            [self.delegate paymentProductViewController:nil didEndWithTransaction:theTransaction];
        }

        [self checkRequestResultStatus:result];

    }];
}

- (void)checkRequestResultStatus:(HPFTransactionErrorResult *)result
{
    switch (result.formAction) {
        case HPFFormActionReset:
            // do nothing
            //[self resetForm];
            break;

        case HPFFormActionFormReload:
            //retry manually
            [self submit];
            break;

        case HPFFormActionBackgroundReload:
            [self needsBackgroundTransactionOrOrderReload];
            break;

        default:
            break;
    }
}

- (void) checkTouchID {

    int index = -1;
    for (int i = 0; i < self.selectedCards.count; ++i) {
        if ([self.selectedCards[i] isEqual:@YES]) {
            index = i;
            break;
        }
    }

    if (index != -1 && self.cardsTouchID != nil && self.cardsTouchID.count > index ) {

        NSNumber *touchIdEnabled = self.cardsTouchID[index];
        if ([touchIdEnabled boolValue] == YES) {

            if ([self canEvaluatePolicy]) {

                [self evaluatePolicy];

            } else {

                [[[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_DEFAULT")
                                            message:HPFLocalizedString(@"CARD_STORED_TOUCHID_NOT_ACTIVATED")
                                           delegate:nil
                                  cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS")
                                  otherButtonTitles:nil]
                        show];
            }

        } else {

            //no touchId found, you can pay directly with this card
            [self submit];
        }

    } else {
        //should not happen
        [self submit];
    }
}

- (BOOL)canEvaluatePolicy {

    LAContext *context = [[LAContext alloc] init];
    NSError *error;

    // test if we can evaluate the policy, this test will tell us if Touch ID is available and enrolled
    return [context canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
}

- (void) userInputsEnabled:(BOOL)enabled {

    self.tableCards.userInteractionEnabled = enabled;
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

- (void)evaluatePolicy {
    LAContext *context = [[LAContext alloc] init];

    // Set text for the localized fallback button.
    context.localizedFallbackTitle = @"";

    [self userInputsEnabled:NO];
    self.payButtonActive = NO;

    [self.tableCards reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

    // Show the authentication UI with our reason string.
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:HPFLocalizedString(@"CARD_STORED_TOUCHID_REASON") reply:^(BOOL success, NSError *authenticationError) {
        dispatch_async(dispatch_get_main_queue(), ^{

            [self userInputsEnabled:YES];

            if (success) {
                [self submit];

            } else {

                self.payButtonActive = YES;
                [self.tableCards reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        });
    }];
}

- (void)submit
{

    self.payButtonLoading = YES;
    self.payButtonActive = NO;

    int index = -1;
    for (int i = 0; i < self.selectedCards.count; ++i) {
        if ([self.selectedCards[i] isEqual:@YES]) {
            index = i;
            break;
        }
    }

    [self.tableCards reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

    HPFPaymentCardToken *paymentCardToken = self.selectedCardsObjects[index];

    NSMutableString *productCode = [paymentCardToken.brand mutableCopy];
    [productCode replaceOccurrencesOfString:@" " withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, productCode.length)];

    HPFOrderRequest *orderRequest = [[HPFOrderRequest alloc] initWithOrderRelatedRequest:self.paymentPageRequest];
    orderRequest.paymentProductCode = [productCode lowercaseString];
    orderRequest.paymentMethod = [HPFCardTokenPaymentMethodRequest cardTokenPaymentMethodRequestWithToken:paymentCardToken.token eci:HPFECIRecurringECommerce authenticationIndicator:self.paymentPageRequest.authenticationIndicator];

    [self cancelRequests];

    transactionLoadingRequest = [[HPFGatewayClient sharedClient] requestNewOrder:orderRequest signature:[self signature] withCompletionHandler:^(HPFTransaction *theTransaction, NSError *error) {

        transactionLoadingRequest = nil;

        if (theTransaction != nil) {

            transaction = theTransaction;

            [self checkTransactionStatus:transaction];
        }

        else {
            [self checkTransactionError:error];
        }

        self.payButtonActive = YES;
        self.payButtonLoading = NO;

        [self.tableCards reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:UITableViewRowAnimationNone];

        [self.delegate paymentProductViewController:nil isLoading:false];
    }];

    [self.delegate paymentProductViewController:nil isLoading:true];
}

- (void)needsBackgroundTransactionOrOrderReload
{
    if (transaction != nil) {
        [self.delegate paymentProductViewController:nil needsBackgroundReloadingOfTransaction:transaction];
    }

    else {
        [self.delegate paymentProductViewControllerNeedsBackgroundOrderReload:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (self.selectedCardsObjects.count == 0) {
        return 1;
    }

    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch (section) {
        case 0: {

            if (self.selectedCardsObjects.count > 0) {
                return HPFLocalizedString(@"CARD_STORED_SELECTION");
            }

        } break;

        case 1: {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
            numberFormatter.currencyCode = self.paymentPageRequest.currency;

            return [NSString stringWithFormat:HPFLocalizedString(@"TOTAL_AMOUNT"), [numberFormatter stringFromNumber:self.paymentPageRequest.amount]];
        }

        default:
            return nil;
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.selectedCardsObjects.count == 0) {
        return 1;

    } else {
        switch (section) {
            case 0:
                return self.selectedCardsObjects.count;

            case 1:
                return 1;

            case 2:
                return 1;

            default:
                return 0;
        }
    }

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.selectedCardsObjects.count == 0) {

        return NO;

    } else {

        if (indexPath.section == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (UIImage *) brandToImage:(NSString *)brand {

    if (brand != nil && brand.length > 0) {
        if ([brand caseInsensitiveCompare:HPFPaymentProductCodeMasterCard] == NSOrderedSame) {
            return [UIImage imageNamed:@"ic_credit_card_mastercard.png" inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];

        } else if ([brand caseInsensitiveCompare:HPFPaymentProductCodeVisa] == NSOrderedSame) {
            return [UIImage imageNamed:@"ic_credit_card_visa.png" inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];

        } else if ([brand caseInsensitiveCompare:HPFPaymentProductCodeAmericanExpress] == NSOrderedSame) {
            return [UIImage imageNamed:@"ic_credit_card_amex.png" inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];

        } else if ([brand caseInsensitiveCompare:HPFPaymentProductCodeDiners] == NSOrderedSame) {
            return [UIImage imageNamed:@"ic_credit_card_diners.png" inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];
        }
    }

    return [UIImage imageNamed:@"ic_credit_card.png" inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.selectedCardsObjects.count == 0) {

        UITableViewCell *cardCell = [tableView dequeueReusableCellWithIdentifier:@"AnotherPaymentCell" forIndexPath:indexPath];
        cardCell.selectionStyle = UITableViewCellSelectionStyleNone;
        cardCell.textLabel.text = HPFLocalizedString(@"CARD_STORED_ANOTHER_SELECTION");
        return cardCell;

    } else {

        switch (indexPath.section) {
            case 0: {

                HPFPaymentCardTableViewCell *cardCell = [tableView dequeueReusableCellWithIdentifier:@"CardCell" forIndexPath:indexPath];

                HPFPaymentCardToken *paymentCardToken = self.selectedCardsObjects[indexPath.row];
                cardCell.panLabel.text = [paymentCardToken pan];

                NSString *issuer = [paymentCardToken issuer];
                if (issuer != nil && issuer.length > 0) {

                    cardCell.bankLabel.text = issuer;
                    [cardCell addDependency];

                } else {

                    cardCell.bankLabel.text = @"";
                    [cardCell removeDependency];
                }

                cardCell.cardImageView.image = [self brandToImage:[paymentCardToken.brand stringByReplacingOccurrencesOfString:@" " withString:@"-"]];

                NSNumber *boolValue = self.selectedCards[indexPath.row];
                if ([boolValue boolValue] == YES) {
                    cardCell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cardCell.accessoryType = UITableViewCellAccessoryNone;
                }

                return cardCell;

            }

            case 1: {

                HPFPaymentButtonTableViewCell *payCell = [self.tableCards dequeueReusableCellWithIdentifier:@"PaymentButton"];
                payCell.delegate = self;

                payCell.enabled = self.isPayButtonActive;
                payCell.loading = self.isPayButtonLoading;

                return payCell;

            }

            case 2: {

                UITableViewCell *cardCell = [tableView dequeueReusableCellWithIdentifier:@"AnotherPaymentCell" forIndexPath:indexPath];
                cardCell.textLabel.text = HPFLocalizedString(@"CARD_STORED_ANOTHER_SELECTION");

                return cardCell;

            }

            default:
                return nil;
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.selectedCardsObjects.count > 0) {

        switch (indexPath.section) {

            case 0: {

                int index = -1;

                for (int i = 0; i < self.selectedCards.count; i++) {

                    if (indexPath.row != i) {
                        NSNumber *boolValue = self.selectedCards[i];
                        if ([boolValue boolValue] == YES) {

                            index = i;
                            [self.selectedCards replaceObjectAtIndex:i withObject:@NO];
                        }
                    }
                }

                NSNumber *boolValue = self.selectedCards[indexPath.row];

                if ([boolValue boolValue] == YES) {
                    [self.selectedCards replaceObjectAtIndex:indexPath.row withObject:@NO];
                } else {
                    [self.selectedCards replaceObjectAtIndex:indexPath.row withObject:@YES];
                }

                NSMutableArray *indexesPath = [NSMutableArray array];
                [indexesPath addObject:indexPath];
                if (index != -1) {
                    [indexesPath addObject:[NSIndexPath indexPathForItem:index inSection:0]];
                }

                [self.tableCards beginUpdates];
                [self.tableCards reloadRowsAtIndexPaths:indexesPath withRowAnimation:UITableViewRowAnimationFade];

                BOOL activePayButton = [self.selectedCards[indexPath.row] boolValue];

                if (self.isPayButtonActive != activePayButton) {

                    self.payButtonActive = activePayButton;
                    [self.tableCards reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                }
                [self.tableCards endUpdates];

            } break;

            case 1: {


            } break;

            case 2: {

            } break;

            default:
                break;
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.isPayButtonLoading) {
        return nil;
    }

    return indexPath;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        HPFPaymentCardToken * cardToken = self.selectedCardsObjects[indexPath.row];
        [HPFPaymentCardTokenDatabase delete:cardToken forCurrency:self.paymentPageRequest.currency];

        [self.selectedCardsObjects removeObjectAtIndex:indexPath.row];
        BOOL isPayActive = [self.selectedCards[indexPath.row] boolValue];

        [self.selectedCards removeObjectAtIndex:indexPath.row];

        [self.tableCards beginUpdates];
        if (self.selectedCardsObjects.count == 0) {

            // sections removed
            [self.tableCards deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)] withRowAnimation:UITableViewRowAnimationFade];

        } else {

            [self.tableCards deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

            // disable pay button if row is removed
            if (isPayActive) {
                self.payButtonActive = NO;
                [self.tableCards reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        [self.tableCards endUpdates];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleDelete;
}

#pragma mark - HPFTransactionRequestResponseManager method

- (void)showAlertView:(UIAlertController *)alert
{
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation


// ------------------------------------------------------------------------------
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}


// ------------------------------------------------------------------------------
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}

/*
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
