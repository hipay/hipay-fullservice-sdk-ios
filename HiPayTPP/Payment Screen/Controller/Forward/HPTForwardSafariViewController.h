//
//  HPTForwardSafariViewController.h
//  Pods
//
//  Created by Jonathan TIRET on 29/10/2015.
//
//

#import <SafariServices/SafariServices.h>
#import "HPTForwardViewController.h"

@interface HPTForwardSafariViewController : HPTForwardViewController <SFSafariViewControllerDelegate>
{
    SFSafariViewController *safariViewController;
    UIActivityIndicatorView *spinner;
}

+ (BOOL)isCompatible;

@end
