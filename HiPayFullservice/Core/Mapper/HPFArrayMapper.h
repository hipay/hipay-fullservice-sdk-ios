//
//  HPFArrayMapper.h
//  Pods
//
//  Created by HiPay on 21/10/2015.
//
//

#import "HPFAbstractMapper.h"

@interface HPFArrayMapper : HPFAbstractMapper
{
    NSMutableArray *objectMappers;
}

@property (nonatomic, readonly) Class objectMapperClass;

+ (instancetype)mapperWithRawData:(id)rawData objectMapperClass:(Class)objectMapperClass;

- (instancetype)initWithRawData:(id)rawData objectMapperClass:(Class)objectMapperClass;

@end
