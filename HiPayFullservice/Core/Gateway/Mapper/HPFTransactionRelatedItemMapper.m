//
//  HPFTransactionRelatedItemMapper.m
//  Pods
//
//  Created by HiPay on 09/10/2015.
//
//

#import "HPFTransactionRelatedItemMapper.h"
#import "HPFAbstractMapper+Decode.h"
#import "HPFTransactionRelatedItem.h"
#import "HPFTransactionRelatedItemMapper+Private.h"

@implementation HPFTransactionRelatedItemMapper

- (id _Nonnull)mappedObject
{
    return [self mappedObjectWithTransactionRelatedItem:[[HPFTransactionRelatedItem alloc] init]];
}

- (id _Nonnull)mappedObjectWithTransactionRelatedItem:(HPFTransactionRelatedItem *)object
{
    [object setValue:@([self getBoolForKey:@"test"]) forKey:@"test"];
    [object setValue:[self getStringForKey:@"mid"] forKey:@"mid"];
    [object setValue:[self getStringForKey:@"authorizationCode"] forKey:@"authorizationCode"];
    [object setValue:[self getStringForKey:@"transactionReference"] forKey:@"transactionReference"];
    [object setValue:[self getDateForKey:@"dateCreated"] forKey:@"dateCreated"];
    [object setValue:[self getDateForKey:@"dateUpdated"] forKey:@"dateUpdated"];
    [object setValue:[self getDateForKey:@"dateAuthorized"] forKey:@"dateAuthorized"];
    [object setValue:@([self getIntegerForKey:@"status"]) forKey:@"status"];
    [object setValue:[self getStringForKey:@"message"] forKey:@"message"];
    [object setValue:[self getNumberForKey:@"authorizedAmount"] forKey:@"authorizedAmount"];
    [object setValue:[self getNumberForKey:@"capturedAmount"] forKey:@"capturedAmount"];
    [object setValue:[self getNumberForKey:@"refundedAmount"] forKey:@"refundedAmount"];
    [object setValue:[self getNumberForKey:@"decimals"] forKey:@"decimals"];
    [object setValue:[self getStringForKey:@"currency"] forKey:@"currency"];
    
    return object;
}

- (BOOL)isValid
{
    return [self.rawData objectForKey:@"transactionReference"] != nil;
}

@end
