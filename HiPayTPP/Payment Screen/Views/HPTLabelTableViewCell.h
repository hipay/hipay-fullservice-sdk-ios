//
//  HPTLabelTableViewCell.h
//  Pods
//
//  Created by Jonathan TIRET on 02/11/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTFormTableViewCell.h"

@interface HPTLabelTableViewCell : HPTFormTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *inputLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
