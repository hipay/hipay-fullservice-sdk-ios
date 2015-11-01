//
//  HPTForwardViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import <UIKit/UIKit.h>
#import "HPTTransaction.h"

@class HPTForwardViewController;

@protocol HPTForwardViewControllerDelegate <NSObject>

@required

- (void)forwardViewController:(HPTForwardViewController *)viewController didEndWithTransaction:(HPTTransaction *)transaction;

- (void)forwardViewController:(HPTForwardViewController *)viewController didFailWithError:(NSError *)error;

- (void)forwardViewControllerDidCancel:(HPTForwardViewController *)viewController;

@end

@interface HPTForwardViewController : UIViewController

@property (nonatomic, readonly) HPTTransaction *transaction;
@property (nonatomic, weak) id<HPTForwardViewControllerDelegate> delegate;

+ (HPTForwardViewController *)relevantForwardViewControllerWithTransaction:(HPTTransaction *)transaction;

- (instancetype)initWithTransaction:(HPTTransaction *)transaction;

@end