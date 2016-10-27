//
// Created by Nicolas FILLION on 27/10/2016.
//

#import "HPFPaymentCardTokenDoc.h"
#import "HPFPaymentCardToken.h"
#import "HPFPaymentCardTokenDatabase.h"

#define kDataKey        @"Data"
#define kDataFile       @"data.plist"

@implementation HPFPaymentCardTokenDoc

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (id)initWithDocPath:(NSString *)docPath {
    if ((self = [super init])) {
        _docPath = [docPath copy];
    }
    return self;
}

- (id)initWithPaymentCardToken:(HPFPaymentCardToken *)paymentCardToken {
    if ((self = [super init])) {
        _data = paymentCardToken;
    }
    return self;
}

- (BOOL)createDataPath {

    if (_docPath == nil) {
        self.docPath = [HPFPaymentCardTokenDatabase nextPaymentCardTokenDocPath];
    }

    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:_docPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"Error creating data path: %@", [error localizedDescription]);
    }
    return success;

}

- (HPFPaymentCardToken *)data {

    if (_data != nil) return _data;

    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    if (codedData == nil) return nil;

    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
    _data = [unarchiver decodeObjectForKey:kDataKey];
    [unarchiver finishDecoding];

    return _data;

}

- (void)saveData {

    if (_data == nil) return;

    NSMutableArray *array = [HPFPaymentCardTokenDatabase loadPaymentCardTokenDocs];

    if (array != nil && array.count > 0) {
        for (HPFPaymentCardTokenDoc *paymentCardTokenDoc in array) {

            HPFPaymentCardToken *paymentCardToken = [paymentCardTokenDoc data];
            if ([paymentCardToken isEqualToPaymentCardToken:_data]) {
                return;
            }
        }
    }

    [self createDataPath];

    NSString *dataPath = [_docPath stringByAppendingPathComponent:kDataFile];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_data forKey:kDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];

}

- (void)deleteDoc {

    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:_docPath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }

}

@end