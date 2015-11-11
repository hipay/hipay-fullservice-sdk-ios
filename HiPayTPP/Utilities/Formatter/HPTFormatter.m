//
//  HPTFormatter.m
//  Pods
//
//  Created by Jonathan TIRET on 09/11/2015.
//
//

#import "HPTFormatter.h"

@implementation HPTFormatter

- (NSString *)digitsOnlyFromPlainText:(NSString *)plainText
{
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [[plainText componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

@end
