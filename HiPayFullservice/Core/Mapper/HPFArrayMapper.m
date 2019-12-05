//
//  HPFArrayMapper.m
//  Pods
//
//  Created by HiPay on 21/10/2015.
//
//

#import "HPFArrayMapper.h"
#import "HPFAbstractMapper+Decode.h"

@implementation HPFArrayMapper

- (instancetype)initWithRawData:(id)rawData objectMapperClass:(Class)objectMapperClass
{
    self = [super initWithRawData:rawData];
    if (self) {
        _objectMapperClass = objectMapperClass;
        
        if (![_objectMapperClass isSubclassOfClass:[HPFAbstractMapper class]]) {
            return nil;
        }
    }
    return self;
}

+ (instancetype)mapperWithRawData:(id)rawData objectMapperClass:(Class)objectMapperClass
{
    return [[HPFArrayMapper alloc] initWithRawData:rawData objectMapperClass:objectMapperClass];
}

- (id _Nonnull)mappedObject
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSDictionary *info in [self getObjectsArrayForObject:self.rawData]) {
        HPFAbstractMapper *mapper = [_objectMapperClass mapperWithRawData:info];
        
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
