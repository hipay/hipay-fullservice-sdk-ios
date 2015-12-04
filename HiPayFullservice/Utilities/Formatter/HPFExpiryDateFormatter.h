//
//  HPFExpiryDateFormatter.h
//  Pods
//
//  Created by Jonathan TIRET on 09/11/2015.
//
//

#import "HPFFormatter.h"

@interface HPFExpiryDateFormatter : HPFFormatter

+ (instancetype)sharedFormatter;

- (NSAttributedString *)formattedDateWithPlainText:(NSString *)plainText;
- (BOOL)dateIsCompleteForPlainText:(NSString *)plainText;
- (NSDateComponents *)dateComponentsForPlainText:(NSString *)plainText;

@end
