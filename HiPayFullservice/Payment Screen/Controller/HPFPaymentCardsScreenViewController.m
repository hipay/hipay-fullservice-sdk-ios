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
#import "HPFPaymentCardTokenDatabase.h"
#import "HPFPaymentCardToken.h"
#import "HPFPaymentCardTokenDoc.h"
#import "HPFPaymentCardTableViewCell.h"

@interface HPFPaymentCardsScreenViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableCards;
@property (nonatomic, strong) NSMutableArray *selectedCards;
@property (nonatomic, strong) NSMutableArray *selectedCardsObjects;
@property (nonatomic, strong) NSMutableArray *selectedCardsDocs;
@property (nonatomic) BOOL isPayButtonActive;
@property (nonatomic) BOOL isPayButtonLoading;

@end

@implementation HPFPaymentCardsScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isPayButtonActive = NO;
    self.isPayButtonLoading = NO;
    
    self.title = HPFLocalizedString(@"PAYMENT_CARDS_SCREEN_TITLE");

    self.selectedCardsObjects = [HPFPaymentCardTokenDatabase paymentCardTokens];
    self.selectedCardsDocs = [HPFPaymentCardTokenDatabase loadPaymentCardTokenDocs];

    NSMutableArray *cards = [NSMutableArray arrayWithCapacity:[self.selectedCardsObjects count]];
    for (int i = 0; i < self.selectedCardsObjects.count; ++i) {
        [cards addObject:@NO];
    }
 
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
        return HPFLocalizedString(@"CARD_STORED_SELECTION");
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.selectedCards.count;

        case 1:
            return 1;

        case 2:
            return 1;

        default:
            return 0;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    } else {
        return FALSE;
    }
}

- (UIImage *) brandToImage:(NSString *)brand {

    if (brand != nil && brand.length > 0) {
        if ([brand caseInsensitiveCompare:@"mastercard"] == NSOrderedSame) {
            return [UIImage imageNamed:@"ic_credit_card_mastercard.png" inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];

        } else if ([brand caseInsensitiveCompare:@"visa"] == NSOrderedSame) {
            return [UIImage imageNamed:@"ic_credit_card_visa.png" inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];
        }
    }

    return [UIImage imageNamed:@"ic_credit_card.png" inBundle:HPFPaymentScreenViewsBundle() compatibleWithTraitCollection:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

            cardCell.cardImageView.image = [self brandToImage:paymentCardToken.brand];

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
            cardCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cardCell.textLabel.text = HPFLocalizedString(@"CARD_STORED_ANOTHER_SELECTION");
            return cardCell;
            
        }

        default:
            return nil;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
                
                self.isPayButtonActive = activePayButton;
                [self.tableCards reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            }
            [self.tableCards endUpdates];

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


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        HPFPaymentCardTokenDoc *paymentCardTokenDoc = self.selectedCardsDocs[indexPath.row];
        [paymentCardTokenDoc deleteDoc];

        [self.selectedCardsObjects removeObjectAtIndex:indexPath.row];
        [self.selectedCards removeObjectAtIndex:indexPath.row];
        [self.selectedCardsDocs removeObjectAtIndex:indexPath.row];

        [self.tableCards deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {

    return UITableViewCellEditingStyleDelete;
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
