//
//  HPTHostedPaymentPageMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 13/10/2015.
//
//

#import "HPTHostedPaymentPageMapper.h"
#import "HPTAbstractMapper+Decode.h"
#import "HPTHostedPaymentPage.h"

@implementation HPTHostedPaymentPageMapper

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"forwardUrl"] != nil;
}

@end
