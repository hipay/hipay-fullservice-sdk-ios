//
//  HPFScanCardTableViewCell.h
//  Pods
//
//  Created by Nicolas FILLION on 16/02/2017.
//
//

#import <UIKit/UIKit.h>

@class HPFScanCardTableViewCell;

@protocol HPFScanCardTableViewCellDelegate <NSObject>

@required

- (void)scanCardTableViewCellDidTouchButton:(HPFScanCardTableViewCell *)cell;

@end

@interface HPFScanCardTableViewCell : UITableViewCell
{
    __weak IBOutlet UIButton *button;
}

@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic, weak) id<HPFScanCardTableViewCellDelegate> delegate;

@end
