//
//  HPFSwitchInfosTableViewCell.h
//  HiPayFullservice
//
//  Created by Nicolas FILLION on 01/08/2017.
//  Copyright © 2017 Jonathan TIRET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPFSwitchInfosTableViewCell : UITableViewCell

@property (nonatomic) __weak IBOutlet UISwitch *switchControl;
@property (nonatomic) __weak IBOutlet UILabel *label;
@property (nonatomic) __weak IBOutlet UILabel *labelInfos;


@end
