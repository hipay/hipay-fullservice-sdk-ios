//
//  HPFOperation.h
//  Pods
//
//  Created by Jonathan TIRET on 08/10/2015.
//
//

#import <Foundation/Foundation.h>
#import "HPFTransactionRelatedItem.h"

/**
 *  Describes a maintenance operation type.
 */
typedef NS_ENUM(NSInteger, HPFOperationType) {
    
    HPFOperationTypeUnknown,
    
    /**
     *  A request instructing the payment gateway to capture a previously-authorized transaction, i.e. transfer the funds from the customer's bank account to the merchant's bank account. This transaction is always preceded by an authorization.
     */
    HPFOperationTypeCapture,
    
    /**
     *  A request instructing the payment gateway to refund a previously captured transaction. A captured transaction can be partly or fully refunded.
     */
    HPFOperationTypeRefund,
    
    /**
     *  A request instructing the payment gateway to cancel a previously authorized transaction. Only authorized transactions can be cancelled, captured transactions must be refunded.
     */
    HPFOperationTypeCancel,
    
    /**
     *  A request instructing the payment gateway to accept a previously challenged transaction.
     */
    HPFOperationTypeAcceptChallenge,
    
    /**
     *  A request instructing the payment gateway to deny a previously challenged transaction.
     */
    HPFOperationTypeDenyChallenge
    
};

/**
 *  Describes a maintenance operation and its related transaction.
 */
@interface HPFOperation : HPFTransactionRelatedItem

/**
 *  The type of operation.
 */
@property (nonatomic, readonly) HPFOperationType operation;

@end
