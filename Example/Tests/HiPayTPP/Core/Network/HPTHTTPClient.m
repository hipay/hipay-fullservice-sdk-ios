
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <HiPayTPP/HiPayTPP.h>
#import "HPTHTTPClient+Testing.h"

SpecBegin(HPTHTTPClient)

describe(@"HPTHTTPClient init", ^{

    NSURL *baseURL = [NSURL URLWithString:@"https://api.example.org/"];
    
    HPTHTTPClient *client = [[HPTHTTPClient alloc] initWithBaseURL:baseURL login:@"api_login" password:@"api_passws"];

    setAsyncSpecTimeout(0.2);
    
    it(@"should init properly", ^{
        expect(client).to.beKindOf([HPTHTTPClient class]);
        expect(client.baseURL).equal(baseURL);
    });
    
    it(@"should create proper GET URL request", ^{
        
        NSURLRequest *URLRequest = [client createURLRequestWithMethod:HPTHTTPMethodGet path:@"/items/1" parameters:@{@"param": @"value", @"param2": @"value2"}];
        
        expect(URLRequest).beKindOf([NSURLRequest class]);
        expect([URLRequest.URL absoluteString]).equal(@"https://api.example.org/items/1?param=value&param2=value2");
        expect(URLRequest.HTTPMethod).equal(@"GET");
    });
    
//    it(@"should call done callback", ^{
//        waitUntil(^(DoneCallback done) {
//            
//            [client performRequestWithMethod:HPTHTTPMethodGet path:@"/items/1" parameters:nil completionHandler:^(HPTHTTPResponse *response, NSError *error) {
//                
//                done();
//                
//            }];
//        });
//    });
    
});

SpecEnd

