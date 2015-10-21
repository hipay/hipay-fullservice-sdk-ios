//
//  HPTArrayMapper.h
//  Pods
//
//  Created by Jonathan TIRET on 21/10/2015.
//
//

#import <HiPayTPP/HiPayTPP.h>

@interface HPTArrayMapper : HPTAbstractMapper
{
    NSMutableArray *objectMappers;
}

@property (nonatomic, readonly) Class objectMapperClass;

+ (instancetype)mapperWithRawData:(id)rawData objectMapperClass:(Class)objectMapperClass;

- (instancetype)initWithRawData:(id)rawData objectMapperClass:(Class)objectMapperClass;

@end
