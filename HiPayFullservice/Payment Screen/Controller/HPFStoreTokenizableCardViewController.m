//
//  StoreTokenizableCardViewController.m
//  HiPayFullservice
//
//  Created by Nicolas FILLION on 23/10/2017.
//

#import "HPFStoreTokenizableCardViewController.h"
#import "HPFPaymentScreenUtils.h"

@interface HPFStoreTokenizableCardViewController ()

@end

@implementation HPFStoreTokenizableCardViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.title = @"hello";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)doCancel
{
    //[paymentProductsRequest cancel];
    //[self cancelActivity];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    /*
    if ([self.delegate respondsToSelector:@selector(paymentScreenViewControllerDidCancel:)]) {
        [self.delegate paymentScreenViewControllerDidCancel:self];
    }
    */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

