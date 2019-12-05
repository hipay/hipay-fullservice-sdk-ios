//
//  HPFEnvironmentViewController.h
//  HiPayFullservice_Example
//
//  Created by HiPay on 06/12/2018.
//  Copyright © 2018 HiPay. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HPFEnvironmentKey @"hpfe_environment"

#define HPFEnvironmentViewControllerValueProduction @"hpfe_production"
#define HPFEnvironmentViewControllerValueStage @"hpfe_stage"
#define HPFEnvironmentViewControllerValueCustom @"hpfe_custom"

#define HPFEnvironmentViewControllerKeyUsername @"hpfe_username"
#define HPFEnvironmentViewControllerKeyPassword @"hpfe_password"
#define HPFEnvironmentViewControllerKeyIsStageUrl @"hpfe_is_stageUrl"

#define HPFEnvironmentViewControllerKeyPasswordSignature @"hpfe_password_signature"
#define HPFEnvironmentViewControllerKeyIsLocalSignature @"hpfe_is_local_signature"

@interface HPFEnvironmentViewController : UITableViewController

+(BOOL)isEnvironmentStage;
+(BOOL)isEnvironmentProduction;
+(BOOL)isEnvironmentCustom;

+(NSString *)usernameUserDefaults;
+(NSString *)passwordUserDefaults;
+(BOOL)isStageUrlUserDefaults;

+(BOOL)isLocalSignatureUserDefaults;
+(NSString *)passwordSignatureUserDefaults;

@end
