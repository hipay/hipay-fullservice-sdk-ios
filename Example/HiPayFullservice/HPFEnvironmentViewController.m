//
//  HPFEnvironmentViewController.m
//  HiPayFullservice_Example
//
//  Created by Morgan BAUMARD on 06/12/2018.
//  Copyright © 2018 Jonathan TIRET. All rights reserved.
//

#import "HPFEnvironmentViewController.h"
#import <HiPayFullservice/HiPayFullservice.h>
#import "HPFTextInputTableViewCell.h"

@interface HPFEnvironmentViewController ()

@property (nonatomic,assign) NSUInteger selectedEnvironment;

@property (nonatomic,assign) NSUInteger prodRowIndex;
@property (nonatomic,assign) NSUInteger stageRowIndex;
@property (nonatomic,assign) NSUInteger customRowIndex;

@property (nonatomic,assign) NSUInteger usernameRowIndex;
@property (nonatomic,assign) NSUInteger passwordRowIndex;
@property (nonatomic,assign) NSUInteger urlRowIndex;

@property (nonatomic, assign) NSUInteger credentialsSectionEnabled;

@property (nonatomic, assign) BOOL isStageUrl;

@end

@implementation HPFEnvironmentViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"Choix environment";
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"HPFTextInputTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Input"];
        
        self.credentialsSectionEnabled = NSNotFound;
        
        self.stageRowIndex = 0;
        self.prodRowIndex = 1;
        self.customRowIndex = 2;
        
        self.usernameRowIndex = 0;
        self.passwordRowIndex = 1;
        self.urlRowIndex = 2;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.cellLayoutMarginsFollowReadableWidth = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped:)];
    
    self.selectedEnvironment = 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else if (self.credentialsSectionEnabled != NSNotFound) {
        return 3;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row == self.stageRowIndex) {
            cell.textLabel.text = @"Stage";
        }
        else if (indexPath.row == self.prodRowIndex) {
            cell.textLabel.text = @"Production";
        }
        else if (indexPath.row == self.customRowIndex) {
            cell.textLabel.text = @"Custom";
        }
        
        if (indexPath.row == self.selectedEnvironment) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        return cell;
        
    } else if (self.credentialsSectionEnabled != NSNotFound) {
        
        if (indexPath.row == self.usernameRowIndex) {
            HPFTextInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Input" forIndexPath:indexPath];
            
            cell.title.text = @"Username";
            cell.detailTextLabel.text = [HPFEnvironmentViewController usernameUserDefaults];
            
            return cell;
        }
        else if (indexPath.row == self.passwordRowIndex) {
            HPFTextInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Input" forIndexPath:indexPath];
            
            cell.title.text = @"Password";
            cell.detailTextLabel.text = [HPFEnvironmentViewController passwordUserDefaults];
            
            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"url"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"url"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"URL";
            cell.detailTextLabel.text = [HPFEnvironmentViewController isStageUrlUserDefaults] ? HPFGatewayClientBaseURLStage : HPFGatewayClientBaseURLProduction;
            
            return cell;
        }
        
    }
    
    NSLog(@"Unexpected tableView error");
    abort();
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == self.selectedEnvironment) {
            return;
        }
        
        UITableViewCell *beforeCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedEnvironment
                                                                                          inSection:indexPath.section]];
        beforeCell.accessoryType = UITableViewCellAccessoryNone;
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        self.selectedEnvironment = indexPath.row;
        
        if (indexPath.row == self.customRowIndex) {
            self.credentialsSectionEnabled = 1;
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:
                                                    [NSIndexPath indexPathForRow:0 inSection:1],
                                                    [NSIndexPath indexPathForRow:1 inSection:1],
                                                    [NSIndexPath indexPathForRow:2 inSection:1],
                                                    nil]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == self.urlRowIndex) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.urlRowIndex
                                                                                              inSection:indexPath.section]];
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"Production URL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.isStageUrl = NO;
                cell.detailTextLabel.text = HPFGatewayClientBaseURLProduction;
            }]];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"Stage URL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.isStageUrl = YES;
                cell.detailTextLabel.text = HPFGatewayClientBaseURLStage;
            }]];
            
            [alertVC addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            
            [self.navigationController presentViewController:alertVC animated:YES completion:nil];
        }
    }
}

+(NSString *)usernameUserDefaults {
    return [[NSUserDefaults standardUserDefaults] stringForKey:HPFEnvironmentViewControllerKeyUsername];
}

+(NSString *)passwordUserDefaults {
    return [[NSUserDefaults standardUserDefaults] stringForKey:HPFEnvironmentViewControllerKeyPassword];
}

+(BOOL)isStageUrlUserDefaults {
    return [[NSUserDefaults standardUserDefaults] boolForKey:HPFEnvironmentViewControllerKeyIsStageUrl];
}

+(NSString *)environmentUserDefaults {
    return [[NSUserDefaults standardUserDefaults] stringForKey:HPFEnvironmentKey];
}

+(void)updateEnvironmentUserDefaults:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:HPFEnvironmentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)updateUserDefaultsUsername:(NSString * _Nonnull)username password:(NSString * _Nonnull)password isStageUrl:(BOOL)isStageUrl {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:HPFEnvironmentViewControllerKeyUsername];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:HPFEnvironmentViewControllerKeyPassword];
    [[NSUserDefaults standardUserDefaults] setBool:isStageUrl forKey:HPFEnvironmentViewControllerKeyIsStageUrl];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)updateUserDefaultsStageUrl:(BOOL)isStage {
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveButtonTapped:(id)sender {
    NSLog(@"OK");
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"⚠️ Warning ⚠️" message:@"HiPay Demo will stop to save environment" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (self.selectedEnvironment == self.prodRowIndex) {
            [HPFEnvironmentViewController updateEnvironmentUserDefaults:HPFEnvironmentViewControllerValueProd];
        }
        else if (self.selectedEnvironment == self.stageRowIndex) {
            [HPFEnvironmentViewController updateEnvironmentUserDefaults:HPFEnvironmentViewControllerValueStage];
        }
        else if (self.selectedEnvironment == self.customRowIndex) {
            [HPFEnvironmentViewController updateEnvironmentUserDefaults:HPFEnvironmentViewControllerValueCustom];
            
            HPFTextInputTableViewCell *username = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.usernameRowIndex inSection:1]];
            HPFTextInputTableViewCell *password = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.passwordRowIndex inSection:1]];
            
            [HPFEnvironmentViewController updateUserDefaultsUsername:username.textfield.text
                                                            password:password.textfield.text
                                                          isStageUrl:self.isStageUrl];
        }
        
        abort();
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}

@end
