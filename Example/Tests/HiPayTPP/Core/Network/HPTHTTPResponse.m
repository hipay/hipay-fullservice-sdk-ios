
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <HiPayTPP/HiPayTPP.h>

SpecBegin(HPTHTTPResponse)

describe(@"HPTHTTPResponse init", ^{
    
    it(@"will match init values", ^{
        
        HPTHTTPResponse *response = [[HPTHTTPResponse alloc] initWithStatusCode:200 body:@{@"key":@"value"}];
        
        expect(response).to.beAKindOf([HPTHTTPResponse class]);
        expect(response.statusCode).to.equal(200);
        expect(response.body).to.equal(@{@"key":@"value"});
    });
    
});

SpecEnd

