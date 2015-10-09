//
//  AbsractMapper.h
//  Pods
//
//  Created by Jonathan TIRET on 01/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPTAbstractMapper : NSObject

@property (nonatomic, readonly, nullable) NSDictionary *rawData;

- (instancetype _Nonnull)initWithRawData:(NSDictionary * _Nullable)rawData;
- (id _Nonnull)mappedObject;

@end
