//
//  HPFEnvironmentViewController.h
//  HiPayFullservice_Example
//
//  Created by Morgan BAUMARD on 06/12/2018.
//  Copyright © 2018 Jonathan TIRET. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HPFEnvironmentKey @"hipay_environment"

#define HPFEnvironmentViewControllerValueProd @"production"
#define HPFEnvironmentViewControllerValueStage @"stage"
#define HPFEnvironmentViewControllerValueCustom @"custom"

#define HPFEnvironmentViewControllerKeyUsername @"username"
#define HPFEnvironmentViewControllerKeyPassword @"password"
#define HPFEnvironmentViewControllerKeyIsStageUrl @"stageUrl"

@interface HPFEnvironmentViewController : UITableViewController

+(NSString *)usernameUserDefaults;
+(NSString *)passwordUserDefaults;
+(NSString *)environmentUserDefaults;

@end
