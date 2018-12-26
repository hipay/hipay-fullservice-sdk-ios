//
//  HPFIbanUtils.h
//  HiPayFullservice.common
//
//  Created by Morgan BAUMARD on 26/12/2018.
//

#import <Foundation/Foundation.h>

@interface HPFIbanUtils : NSObject

+(BOOL)isValidIBAN:(NSString *)iban;

@end
