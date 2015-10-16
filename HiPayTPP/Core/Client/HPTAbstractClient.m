//
//  HPTAbstractClient.m
//  Pods
//
//  Created by Jonathan TIRET on 05/10/2015.
//
//

#import "HPTAbstractClient.h"
#import "HPTErrors.h"

@implementation HPTAbstractClient

- (HPTErrorCode)errorCodeForNumber:(NSString *)codeNumber
{
    
    if (codeNumber.length != 3 && codeNumber.length != 7) {
        return HPTErrorCodeAPIOther;
    }
    
    NSString *range = [codeNumber substringToIndex:3];
    
    if ([range isEqualToString:@"100"]) {
        return HPTErrorCodeAPIConfiguration;
    }
    
    else if ([range isEqualToString:@"101"]) {
        return HPTErrorCodeAPIValidation;
    }
    
    else if ([range isEqualToString:@"102"]) {
        return HPTErrorCodeAPICheckout;
    }
    
    else if ([range isEqualToString:@"300"]) {
        return HPTErrorCodeAPICheckout;
    }
    
    else if ([range isEqualToString:@"303"]) {
        return HPTErrorCodeAPICheckout;
    }
    
    else if ([range isEqualToString:@"304"]) {
        return HPTErrorCodeAPICheckout;
    }
    
    else if ([range isEqualToString:@"301"]) {
        return HPTErrorCodeAPICheckout;
    }
    
    else if ([range isEqualToString:@"302"]) {
        return HPTErrorCodeAPIMaintenance;
    }
    
    else if ([range isEqualToString:@"400"]) {
        return HPTErrorCodeAPIAcquirer;
    }
    
    else if ([range isEqualToString:@"401"]) {
        return HPTErrorCodeAPIAcquirer;
    }
    
    // Luhn check
    if ([codeNumber isEqualToString:@"409"]) {
        return HPTErrorCodeAPIValidation;
    }
    
    return HPTErrorCodeAPIOther;
}

- (NSError *)errorForResponseBody:(NSDictionary *)body andError:(NSError *)error
{
    NSMutableDictionary *userInfo = @{NSUnderlyingErrorKey: error}.mutableCopy;
    NSInteger code;
    
    if (error.domain == HPTHiPayTPPErrorDomain && error.code == HPTErrorCodeHTTPClient && ([[body objectForKey:@"code"] isKindOfClass:[NSString class]] || [[body objectForKey:@"code"] isKindOfClass:[NSNumber class]]) && [[body objectForKey:@"message"] isKindOfClass:[NSString class]]) {
        
        NSString *stringCode;
        
        if ([[body objectForKey:@"code"] isKindOfClass:[NSString class]]) {
            stringCode = [body objectForKey:@"code"];
        } else {
            stringCode = ((NSNumber *)[body objectForKey:@"code"]).stringValue;
        }
        
        code = [self errorCodeForNumber:stringCode];
        
        if (code != HPTErrorCodeAPIOther) {

            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterRoundFloor;
            NSNumber *codeNumber = [formatter numberFromString:stringCode];
            
            if (codeNumber != nil) {
                [userInfo setObject:codeNumber forKey:HPTErrorCodeAPICodeKey];
                [userInfo setObject:[body objectForKey:@"message"] forKey:HPTErrorCodeAPIMessageKey];
                
                if ([[body objectForKey:@"description"] isKindOfClass:[NSString class]]) {
                    [userInfo setObject:[body objectForKey:@"description"] forKey:NSLocalizedDescriptionKey];
                }
            }
        }
    }
    
    else {
        code = HPTErrorCodeAPIOther;
    }
    
    if (code == HPTErrorCodeAPIOther) {
        [userInfo setObject:body forKey:HPTErrorCodeHTTPParsedResponseKey];
    }
    
    return [NSError errorWithDomain:HPTHiPayTPPErrorDomain code:code userInfo:userInfo];
}

@end
