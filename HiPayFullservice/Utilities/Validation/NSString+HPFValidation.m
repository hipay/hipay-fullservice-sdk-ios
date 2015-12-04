//
//  NSString+HPFValidation.m
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import "NSString+HPFValidation.h"

@implementation NSString (HPFValidation)

- (BOOL)isDefined {
    return ![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
}

@end
