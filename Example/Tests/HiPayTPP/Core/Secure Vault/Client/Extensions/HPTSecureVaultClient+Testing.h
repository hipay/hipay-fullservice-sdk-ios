//
//  HPTSecureVaultClient+Testing.h
//  HiPayTPP
//
//  Created by Jonathan TIRET on 02/10/2015.
//  Copyright © 2015 Jonathan TIRET. All rights reserved.
//


@interface HPTSecureVaultClient (Testing)

+ (HPTHTTPClient *)createClient;
- (HPTPaymentCardToken *)paymentCardTokenWithData:(NSDictionary *)rawData;

@end
