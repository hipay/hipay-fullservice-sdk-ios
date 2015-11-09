//
//  HPTExpiryDateFormatter.h
//  Pods
//
//  Created by Jonathan TIRET on 09/11/2015.
//
//

#import "HPTFormatter.h"

@interface HPTExpiryDateFormatter : HPTFormatter

+ (instancetype)sharedFormatter;

- (NSString *)formattedDateWithPlainText:(NSString *)plainText;
- (BOOL)dateIsCompleteForPlainText:(NSString *)plainText;
- (NSDateComponents *)dateComponentsForPlainText:(NSString *)plainText;

@end
