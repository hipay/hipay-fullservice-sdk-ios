//
//  HPFCardSpriteProvider.m
//  HiPayFullservice
//
//  Created by Mansour Said on 11/1/2026.
//

#import "HPFCardSpriteProvider.h"
#import "HPFPaymentScreenUtils.h"

@implementation HPFCardSpriteProvider

+ (UIImage *_Nullable)logoForPaymentProductCode:(NSString *)code
                                           gray:(BOOL)gray {
  NSBundle *bundle = HPFPaymentScreenViewsBundle();

  UIImage *simpleImage = [UIImage imageNamed:code
                                    inBundle:bundle
               compatibleWithTraitCollection:nil];

  if (simpleImage) {
    return simpleImage;
  }

  NSString *assetName = [self assetNameForCode:code];
  UIImage *legacyImage = [UIImage imageNamed:assetName
                                    inBundle:bundle
               compatibleWithTraitCollection:nil];

  if (legacyImage) {
    return legacyImage;
  }

  return [UIImage imageNamed:@"ic_credit_card"
                           inBundle:bundle
      compatibleWithTraitCollection:nil];
}

#pragma mark - Mapping

+ (NSString *)assetNameForCode:(NSString *)code {
  if (code.length == 0) {
    return @"ic_credit_card";
  }

  NSString *normalized = [self normalizedCode:code];

  if ([normalized containsString:@"visa"]) {
    return @"VISA";
  }

  // BCMC must be checked before "mc" to avoid "bcmc" matching Mastercard
  if ([normalized containsString:@"bcmc"] ||
      [normalized containsString:@"bancontact"]) {
    return @"BCMC";
  }

  // Maestro must be checked before "mc" to avoid "maestro" matching Mastercard
  if ([normalized containsString:@"maestro"]) {
    return @"MAESTRO";
  }

  if ([normalized containsString:@"mastercard"] ||
      [normalized isEqualToString:@"mc"]) {
    return @"MASTERCARD";
  }

  if ([normalized containsString:@"amex"] ||
      [normalized containsString:@"americanexpress"]) {
    return @"AMEX";
  }

  if ([normalized isEqualToString:@"cb"]) {
    return @"CB";
  }

  return @"ic_credit_card";
}

+ (NSString *)normalizedCode:(NSString *)code {
  NSString *lower = [[code lowercaseString]
      stringByTrimmingCharactersInSet:[NSCharacterSet
                                          whitespaceAndNewlineCharacterSet]];
  NSCharacterSet *removeSet =
      [NSCharacterSet characterSetWithCharactersInString:@" _-"];
  NSArray<NSString *> *parts =
      [lower componentsSeparatedByCharactersInSet:removeSet];
  return [parts componentsJoinedByString:@""];
}

@end
