//
//  HPTPersonalInformationMapper.h
//  Pods
//
//  Created by Jonathan TIRET on 09/10/2015.
//
//

@interface HPTPersonalInformationMapper (Private)

- (id _Nonnull)mappedObjectWithPersonalInformation:(HPTPersonalInformation  * _Nonnull)object;
- (HPTPersonalInformation *)populateShippingAddress:(HPTPersonalInformation * _Nonnull)shippingAddress withRawData:(NSDictionary * _Nullable)rawData;

@end
