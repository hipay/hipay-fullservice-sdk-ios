//
//  HPTOperation.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPTTransactionRelatedItem.h"

typedef NS_ENUM(NSInteger, HPTOperationType) {
    
    HPTOperationTypeUnknown,
    HPTOperationTypeCapture,
    HPTOperationTypeRefund,
    HPTOperationTypeCancel,
    HPTOperationTypeAcceptChallenge,
    HPTOperationTypeDenyChallenge
    
};

@interface HPTOperation : HPTTransactionRelatedItem

@property (nonatomic, readonly) HPTOperationType operation;

@end
