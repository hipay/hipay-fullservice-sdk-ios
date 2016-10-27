//
// Created by Nicolas FILLION on 27/10/2016.
//

#import <Foundation/Foundation.h>

@class HPFPaymentCardToken;

@interface HPFPaymentCardTokenDoc : NSObject

@property (nonatomic,strong) HPFPaymentCardToken *data;
@property (nonatomic,copy) NSString *docPath;

- (id)init;
- (id)initWithDocPath:(NSString *)docPath;
- (id)initWithPaymentCardToken:(HPFPaymentCardToken *)paymentCardToken;
- (void)saveData;
- (void)deleteDoc;

@end
