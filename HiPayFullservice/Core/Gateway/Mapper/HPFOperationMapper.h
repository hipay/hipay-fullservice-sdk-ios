//
//  HPFOperationMapper.h
//  Pods
//
//  Created by HiPay on 09/10/2015.
//
//

#import "HPFAbstractMapper.h"
#import "HPFTransactionRelatedItemMapper.h"

@interface HPFOperationMapper : HPFTransactionRelatedItemMapper

+ (NSDictionary *)operationTypeMapping;

@end
