//
//  HPTHTTPResponse.h
//  Pods
//
//  Created by Jonathan TIRET on 21/09/2015.
//
//

#import <Foundation/Foundation.h>

@interface HPTHTTPResponse : NSObject

@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly) id body;

- (instancetype)initWithStatusCode:(NSInteger)statusCode body:(id)body;

@end
