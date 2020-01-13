//
//  HPFSecureVaultClient+Testing.h
//  HiPayFullservice
//
//  Created by HiPay on 02/10/2015.
//  Copyright © 2015 HiPay. All rights reserved.
//


@interface HPFSecureVaultClient (Testing)

+ (HPFHTTPClient *)createClient;
- (HPFPaymentCardToken *)paymentCardTokenWithData:(NSDictionary *)rawData;

- (void)manageRequestWithHTTPResponse:(HPFHTTPResponse *)response error:(NSError *)error andCompletionHandler:(HPFSecureVaultClientCompletionBlock)completionBlock;

@end
