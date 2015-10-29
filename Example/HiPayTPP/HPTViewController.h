//
//  HPTViewController.h
//  HiPayTPP
//
//  Created by Jonathan TIRET on 09/18/2015.
//  Copyright (c) 2015 Jonathan TIRET. All rights reserved.
//

#import <HiPayTPP/HiPayTPP.h>

@import UIKit;

@interface HPTViewController : UIViewController <HPTPaymentScreenViewControllerDelegate, UIAlertViewDelegate>
{
    BOOL firstTestDone;
}

@end
