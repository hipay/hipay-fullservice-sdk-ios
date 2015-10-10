//
//  HPTFraudScreeningMapper.h
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

#import "HPTAbstractMapper.h"
#import "HPTFraudScreening.h"

@interface HPTFraudScreeningMapper : HPTAbstractMapper

+ (NSDictionary *)resultMapping;
+ (NSDictionary *)reviewMapping;

@end
