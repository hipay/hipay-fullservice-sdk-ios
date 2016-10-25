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

@interface HPFPaymentCardsScreenViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableCards;
@property (nonatomic, strong) NSMutableArray *selectedCards;
@property (nonatomic) BOOL isPayButtonActive;
@property (nonatomic) BOOL isPayButtonLoading;

@end

@implementation HPFPaymentCardsScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isPayButtonActive = NO;
    self.isPayButtonLoading = NO;
    
    self.title = HPFLocalizedString(@"PAYMENT_SCREEN_TITLE");
    NSMutableArray *cards = [NSMutableArray array];
    [cards addObject:@NO];
    [cards addObject:@NO];
    [cards addObject:@NO];
    [cards addObject:@NO];
    
    self.selectedCards = cards;
    
    [self.tableCards registerNib:[UINib nibWithNibName:@"HPFPaymentButtonTableViewCell" bundle:HPFPaymentScreenViewsBundle()] forCellReuseIdentifier:@"PaymentButton"];
}



- (void)paymentButtonTableViewCellDidTouchButton:(HPFPaymentButtonTableViewCell *)cell {
    
    self.isPayButtonLoading = YES;
    [self.tableCards reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Select a payment card";
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0: {
            
            UITableViewCell *cardCell = [tableView dequeueReusableCellWithIdentifier:@"CardCell" forIndexPath:indexPath];
            cardCell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
            NSNumber *boolValue = self.selectedCards[indexPath.row];
            if ([boolValue boolValue] == YES) {
                cardCell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cardCell.accessoryType = nil;
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
            cardCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cardCell;
            
        }

        default:
            break;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
            
        case 0: {
            
            int index = -1;
            BOOL isPayButtonActive = NO;
            
            for (int i = 0; i < self.selectedCards.count; i++) {
                
                if (indexPath.row != i) {
                    NSNumber *boolValue = self.selectedCards[i];
                    if ([boolValue boolValue] == YES) {
                        
                        isPayButtonActive = YES;
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
            
            [self.tableCards reloadRowsAtIndexPaths:indexesPath withRowAnimation:UITableViewRowAnimationFade];
            
            BOOL activePayButton = [self.selectedCards[indexPath.row] boolValue];
            
            if (self.isPayButtonActive != activePayButton) {
                
                self.isPayButtonActive = activePayButton;
                [self.tableCards reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        } break;
            
        case 2: {
            
            
            
        } break;
            
        default:
            break;
    }
    
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath;
}



#pragma mark - Navigation


// ------------------------------------------------------------------------------
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}


// ------------------------------------------------------------------------------
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [super prepareForSegue:segue sender:sender];

    /*
    if ([segue.identifier isEqualToString:@"ToPlaceCaptureFlowNextStep"]) {
        [self.placesCaptured addObjectsFromArray:self.selectedPlaces];
    }
    
    HPFPaymentScreenMainViewController *mainViewController = [segue destinationViewController];




    if ([destinationController isKindOfClass:[MCAddPlacesViewController class]]) {

        MCAddPlacesViewController *controller = (MCAddPlacesViewController *) destinationController;
        controller.type = self.type + 1;
        controller.placesCaptured = [self placesCaptured];
    }

    */
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

/*
- (void)loadPaymentProducts:(HPFPaymentPageRequest *)paymentPageRequest signature:(NSString *)signature
{
    _paymentPageRequest = paymentPageRequest;
    _signature = signature;

    [self mainViewController].loading = YES;
    [self mainViewController].signature = _signature;

    [[HPFTransactionRequestResponseManager sharedManager] flushHistory];

    paymentProductsRequest = [[HPFGatewayClient sharedClient] getPaymentProductsForRequest:paymentPageRequest withCompletionHandler:^(NSArray *thePaymentProducts, NSError *error) {

        [self mainViewController].loading = NO;
        paymentProductsRequest = nil;

        if ((error == nil) && (thePaymentProducts.count > 0)) {
            paymentProducts = [self fullPaymentProductsListWithPaymentProducts:thePaymentProducts andRequest:paymentPageRequest];

            [self setPaymentProductsToMainViewController];
        }

        else {

            if (error != nil) {
                [[[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_CONNECTION") message:HPFLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_CANCEL") otherButtonTitles:HPFLocalizedString(@"ERROR_BUTTON_RETRY"), nil] show];
            }

            else {
                [[[UIAlertView alloc] initWithTitle:HPFLocalizedString(@"ERROR_TITLE_DEFAULT") message:HPFLocalizedString(@"ERROR_BODY_DEFAULT") delegate:self cancelButtonTitle:HPFLocalizedString(@"ERROR_BUTTON_DISMISS") otherButtonTitles:nil] show];
            }
        }
    }];
}
*/

@end
