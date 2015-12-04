//
//  HPFAbstractSerializationMapper.h
//  Pods
//
//  Created by Jonathan TIRET on 14/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPFAbstractSerializationMapper : NSObject

@property (nonatomic, readonly) id request;

+ (instancetype)mapperWithRequest:(id)request;

- (instancetype)initWithRequest:(id)request;
- (NSDictionary *)serializedRequest;
+ (NSString *)formatAmountNumber:(NSNumber *)amountNumber;

@end
