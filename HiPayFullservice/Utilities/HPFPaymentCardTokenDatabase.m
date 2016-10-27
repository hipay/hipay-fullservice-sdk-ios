//
// Created by Nicolas FILLION on 27/10/2016.
//

#import "HPFPaymentCardTokenDatabase.h"
#import "HPFPaymentCardTokenDoc.h"

@implementation HPFPaymentCardTokenDatabase

+ (NSString *)getPrivateDocsDir {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];

    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];

    return documentsDirectory;

}

+ (NSMutableArray *)loadPaymentCardTokenDocs {

    // Get private docs dir
    NSString *documentsDirectory = [HPFPaymentCardTokenDatabase getPrivateDocsDir];
    //NSLog(@"Loading bugs from %@", documentsDirectory);

    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        //NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }

    // Create HPFPaymentCardTokenDoc for each file
    NSMutableArray *retval = [NSMutableArray arrayWithCapacity:files.count];
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"paymentCardToken" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:file];
            HPFPaymentCardTokenDoc *doc = [[HPFPaymentCardTokenDoc alloc] initWithDocPath:fullPath];
            [retval addObject:doc];
        }
    }

    return retval;

}

+ (NSString *)nextPaymentCardTokenDocPath {

    // Get private docs dir
    NSString *documentsDirectory = [HPFPaymentCardTokenDatabase getPrivateDocsDir];

    // Get contents of documents directory
    NSError *error;
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if (files == nil) {
        NSLog(@"Error reading contents of documents directory: %@", [error localizedDescription]);
        return nil;
    }

    // Search for an available name
    int maxNumber = 0;
    for (NSString *file in files) {
        if ([file.pathExtension compare:@"paymentCardToken" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSString *fileName = [file stringByDeletingPathExtension];
            maxNumber = MAX(maxNumber, fileName.intValue);
        }
    }

    // Get available name
    NSString *availableName = [NSString stringWithFormat:@"%d.paymentCardToken", maxNumber+1];
    return [documentsDirectory stringByAppendingPathComponent:availableName];

}

@end
