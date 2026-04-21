//
//  HPFCardSpriteProvider.h
//  Pods
//
//  Created by Mansour Said on 11/1/2026.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPFCardSpriteProvider : NSObject
+ (nullable UIImage *)logoForPaymentProductCode:(NSString *)code gray:(BOOL)gray;
@end

NS_ASSUME_NONNULL_END

