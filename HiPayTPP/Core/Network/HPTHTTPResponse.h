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
@property (nonatomic, readonly) NSDictionary *body;

@end
