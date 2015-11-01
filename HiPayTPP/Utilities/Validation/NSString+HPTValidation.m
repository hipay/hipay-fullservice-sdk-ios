//
//  NSString+HPTValidation.m
//  Pods
//
//  Created by Jonathan Tiret on 01/11/2015.
//
//

#import "NSString+HPTValidation.h"

@implementation NSString (HPTValidation)

- (BOOL)isDefined {
    return ![[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
}

@end
