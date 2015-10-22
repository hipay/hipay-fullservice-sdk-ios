//
//  HPTTransactionMapper.h
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPTAbstractMapper.h"
#import "HPTTransactionRelatedItemMapper.h"

@interface HPTTransactionMapper : HPTTransactionRelatedItemMapper

+ (NSDictionary *)transactionStateMapping;

@end
