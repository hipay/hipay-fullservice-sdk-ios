//
//  HPFOperation.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFTransactionRelatedItem.h"

typedef NS_ENUM(NSInteger, HPFOperationType) {
    
    HPFOperationTypeUnknown,
    HPFOperationTypeCapture,
    HPFOperationTypeRefund,
    HPFOperationTypeCancel,
    HPFOperationTypeAcceptChallenge,
    HPFOperationTypeDenyChallenge
    
};

@interface HPFOperation : HPFTransactionRelatedItem

@property (nonatomic, readonly) HPFOperationType operation;

@end
