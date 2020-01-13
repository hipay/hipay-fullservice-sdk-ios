//
//  HPFComponent.h
//  HiPayFullservice_Example
//
//  Created by HiPay on 02/09/2019.
//  Copyright © 2019 HiPay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HPFComponent : NSObject

@property (nonatomic, strong, readonly) NSString *sdkType;
@property (nonatomic, strong, readonly) NSString *sdkServerVersion;

- (NSDictionary *)toJSON;

@end
