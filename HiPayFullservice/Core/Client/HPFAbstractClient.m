//
//  HPFAbstractClient.m
//  Pods
//
//  Created by Jonathan TIRET on 05/10/2015.
//
//

#import "HPFAbstractClient.h"
#import "HPFErrors.h"

@implementation HPFAbstractClient

- (HPFErrorCode)errorCodeForNumber:(NSString *)codeNumber
{
    
    if (codeNumber.length != 3 && codeNumber.length != 7) {
        return HPFErrorCodeAPIOther;
    }
    
    NSString *range = [codeNumber substringToIndex:3];
    
    if ([range isEqualToString:@"100"]) {
        return HPFErrorCodeAPIConfiguration;
    }
    
    else if ([range isEqualToString:@"101"]) {
        return HPFErrorCodeAPIValidation;
    }
    
    else if ([range isEqualToString:@"102"]) {
        return HPFErrorCodeAPICheckout;
    }
    
    else if ([range isEqualToString:@"300"]) {
        return HPFErrorCodeAPICheckout;
    }
    
    else if ([range isEqualToString:@"303"]) {
        return HPFErrorCodeAPICheckout;
    }
    
    else if ([range isEqualToString:@"304"]) {
        return HPFErrorCodeAPICheckout;
    }
    
    else if ([range isEqualToString:@"301"]) {
        return HPFErrorCodeAPICheckout;
    }
    
    else if ([range isEqualToString:@"302"]) {
        return HPFErrorCodeAPIMaintenance;
    }
    
    else if ([range isEqualToString:@"400"]) {
        return HPFErrorCodeAPIAcquirer;
    }
    
    else if ([range isEqualToString:@"401"]) {
        return HPFErrorCodeAPIAcquirer;
    }
    
    // Luhn check
    if ([codeNumber isEqualToString:@"409"]) {
        return HPFErrorCodeAPIValidation;
    }
    
    return HPFErrorCodeAPIOther;
}

- (NSError *)errorForResponseBody:(NSDictionary *)body andError:(NSError *)error
{
    NSMutableDictionary *userInfo = @{NSUnderlyingErrorKey: error}.mutableCopy;
    NSInteger code;
    
    if ([error.domain isEqual:HPFHiPayFullserviceErrorDomain] && error.code == HPFErrorCodeHTTPClient && ([[body objectForKey:@"code"] isKindOfClass:[NSString class]] || [[body objectForKey:@"code"] isKindOfClass:[NSNumber class]]) && [[body objectForKey:@"message"] isKindOfClass:[NSString class]]) {
        
        NSString *stringCode;
        
        if ([[body objectForKey:@"code"] isKindOfClass:[NSString class]]) {
            stringCode = [body objectForKey:@"code"];
        } else {
            stringCode = ((NSNumber *)[body objectForKey:@"code"]).stringValue;
        }
        
        code = [self errorCodeForNumber:stringCode];
        
        if (code != HPFErrorCodeAPIOther) {

            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterRoundFloor;
            NSNumber *codeNumber = [formatter numberFromString:stringCode];
            
            if (codeNumber != nil) {
                [userInfo setObject:codeNumber forKey:HPFErrorCodeAPICodeKey];
                
                NSString *message = [body objectForKey:@"message"];
                if (message.length > 0) {
                    [userInfo setObject:message forKey:HPFErrorCodeAPIMessageKey];
                }
                
                NSString *description = [body objectForKey:@"description"];
                if (description.length > 0) {
                    [userInfo setObject:description forKey:HPFErrorCodeAPIDescriptionKey];
                }
            }
        }
    }
    else if (error.code == HPFErrorCodeHTTPNetworkUnavailable ||
             error.code == HPFErrorCodeHTTPConnectionFailed ||
             error.code == HPFErrorCodeHTTPConfig) {
        code = error.code;
    }
    else {
        code = HPFErrorCodeAPIOther;
        if (body != nil) {
            [userInfo setObject:body forKey:HPFErrorCodeHTTPParsedResponseKey];
        }
    }
    
    return [NSError errorWithDomain:HPFHiPayFullserviceErrorDomain code:code userInfo:userInfo];
}

@end
