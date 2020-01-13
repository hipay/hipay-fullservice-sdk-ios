//
//  AbsractMapper.h
//  Pods
//
//  Created by HiPay on 01/10/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPFAbstractMapper : NSObject

@property (nonatomic, readonly, nullable) id rawData;

+ (instancetype _Nullable)mapperWithRawData:(id _Nullable)rawData;

- (instancetype _Nullable)initWithRawData:(id _Nullable)rawData;

- (id _Nonnull)mappedObject;

@end
