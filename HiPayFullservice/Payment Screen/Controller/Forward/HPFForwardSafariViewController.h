//
//  HPFForwardSafariViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import <SafariServices/SafariServices.h>
#import "HPFForwardViewController.h"

@interface HPFForwardSafariViewController : HPFForwardViewController <SFSafariViewControllerDelegate>
{
    SFSafariViewController NS_AVAILABLE_IOS(9.0) *safariViewController;
    UIActivityIndicatorView *spinner;
}

+ (BOOL)isCompatible;

@end
