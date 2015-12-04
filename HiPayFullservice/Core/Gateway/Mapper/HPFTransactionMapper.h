//
//  HPFTransactionMapper.h
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPFAbstractMapper.h"
#import "HPFTransactionRelatedItemMapper.h"

@interface HPFTransactionMapper : HPFTransactionRelatedItemMapper

+ (NSDictionary *)transactionStateMapping;

@end
