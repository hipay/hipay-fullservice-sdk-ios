//
//  HPFTransactionErrorsManagerResult.h
//  Pods
//
//  Created by Jonathan TIRET on 20/11/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPFFormAction) {
    HPFFormActionReset,
    HPFFormActionFormReload,
    HPFFormActionBackgroundReload,
    HPFFormActionQuit
};

@interface HPFTransactionErrorResult : NSObject

@property (nonatomic, readonly) HPFFormAction formAction;

- (instancetype)initWithFormAction:(HPFFormAction)formAction;

@end
