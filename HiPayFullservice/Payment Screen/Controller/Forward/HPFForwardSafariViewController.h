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
    SFSafariViewController *safariViewController;
    UIActivityIndicatorView *spinner;
}

@end
