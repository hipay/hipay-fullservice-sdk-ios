//
//  HPTArrayMapper.m
//  Pods
//
//  Created by Jonathan TIRET on 21/10/2015.
//
//

#import "HPTArrayMapper.h"
#import "HPTAbstractMapper+Decode.h"

@implementation HPTArrayMapper

- (instancetype)initWithRawData:(id)rawData objectMapperClass:(Class)objectMapperClass
{
    self = [super initWithRawData:rawData];
    if (self) {
        _objectMapperClass = objectMapperClass;
        
        if (![_objectMapperClass isSubclassOfClass:[HPTAbstractMapper class]]) {
            return nil;
        }
    }
    return self;
}

+ (instancetype)mapperWithRawData:(id)rawData objectMapperClass:(Class)objectMapperClass
{
    return [[HPTArrayMapper alloc] initWithRawData:rawData objectMapperClass:objectMapperClass];
}

- (id _Nonnull)mappedObject
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSDictionary *info in [self getObjectsArrayForObject:self.rawData]) {
        HPTAbstractMapper *mapper = [_objectMapperClass mapperWithRawData:info];
        
        if (mapper != nil) {
            [result addObject:mapper.mappedObject];
        }
    }
    
    return [NSArray arrayWithArray:result];
}

- (BOOL)isClassValid
{
    return [self.rawData isKindOfClass:[NSDictionary class]] || [self.rawData isKindOfClass:[NSArray class]];
}

- (BOOL)isValid
{
    return [super isValid];
}

@end
