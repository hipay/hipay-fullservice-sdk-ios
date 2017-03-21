//
//  HPFFormatter.m
//  Pods
//
//  Created by Jonathan TIRET on 09/11/2015.
//
//

#import "HPFFormatter.h"
#import "HPFLogger.h"

@implementation HPFFormatter

- (NSString *)digitsOnlyFromPlainText:(NSString *)plainText
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[plainText componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

+ (void)logFromError:(NSError *)error client:(NSString *)client
{
    NSError *underlyingError = error;
    do
    {
        [[HPFLogger sharedLogger] debug:@"%@: %@", client, underlyingError.userInfo];
        underlyingError = underlyingError.userInfo[@"NSUnderlyingError"];

    } while (underlyingError.userInfo);
}

@end
