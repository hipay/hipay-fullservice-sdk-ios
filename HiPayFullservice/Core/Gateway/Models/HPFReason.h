//
//  HPFReason.h
//  HiPayFullservice.common
//
//  Created by Nicolas FILLION on 27/11/2017.
//

#import <Foundation/Foundation.h>

@interface HPFReason : NSObject

@property (nonatomic, readonly, nonnull) NSString *message;
@property (nonatomic, readonly, nonnull) NSString *code;

@end
