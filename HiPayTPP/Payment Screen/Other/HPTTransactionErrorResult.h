//
//  HPTTransactionErrorsManagerResult.h
//  Pods
//
//  Created by Jonathan TIRET on 20/11/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPTFormAction) {
    HPTFormActionReset,
    HPTFormActionFormReload,
    HPTFormActionBackgroundReload,
    HPTFormActionQuit
};

@interface HPTTransactionErrorResult : NSObject

@property (nonatomic, readonly) HPTFormAction formAction;

- (instancetype)initWithFormAction:(HPTFormAction)formAction;

@end
