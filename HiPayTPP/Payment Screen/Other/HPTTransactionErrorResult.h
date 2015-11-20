//
//  HPTTransactionErrorsManagerResult.h
//  Pods
//
//  Created by Jonathan TIRET on 20/11/2015.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HPTFormAction) {
    HPTFormActionNone,
    HPTFormActionReset,
    HPTFormActionReload,
    HPTFormActionQuit
};

@interface HPTTransactionErrorResult : NSObject

@property (nonatomic, readonly) HPTFormAction formAction;
@property (nonatomic, readonly) BOOL reloadOrder;

- (instancetype)initWithFormAction:(HPTFormAction)formAction reloadOrder:(BOOL)shoulReloadOrder;

@end
