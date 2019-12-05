//
//  HPFComponent.m
//  HiPayFullservice_Example
//
//  Created by HiPay on 02/09/2019.
//  Copyright © 2019 HiPay. All rights reserved.
//

#import "HPFComponent.h"

#define ksdkServerKey @"sdk_server"
#define ksdkServerVersionKey @"sdk_server_version"

@interface HPFComponent()

@property (nonatomic, strong, readwrite) NSString *sdkType;
@property (nonatomic, strong, readwrite) NSString *sdkServerVersion;

@end

@implementation HPFComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sdkType = @"ios";
        
        NSBundle *coreBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"HPFCoreLocalization" ofType:@"bundle"]];
        NSString *version = [coreBundle objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        
        self.sdkServerVersion = version;
    }
    return self;
}

- (NSDictionary *)toJSON {
    NSMutableDictionary *dict = [NSMutableDictionary new];

    [dict setValue:self.sdkType forKey:ksdkServerKey];
    [dict setValue:self.sdkServerVersion forKey:ksdkServerVersionKey];
    
    return dict;
}

@end
