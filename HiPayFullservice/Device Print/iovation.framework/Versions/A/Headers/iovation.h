//
//  iovation.h
//  libiovation
//
//  Created by Greg Crow on 9/9/13.
//  Copyright (c) 2013-2014 iovation, Inc. All rights reserved.
//

#import <TargetConditionals.h>
#import "DevicePrint.h"

#if TARGET_OS_IPHONE
/*!
 * @header
 *
 * @brief iovation ReputationShield client for iOS
 *
 * iovation ReputationManager™ identifies devices through information collected
 * by this client run on an end user’s iOS device. ReputationShield™ generates
 * a blackbox that contains all device information available. This blackbox
 * must then be transmitted to your servers to be used in a reputation check
 * (for example a @p CheckTransactionDetails call).
 *
 * @version 4.1.0
 * @copyright 2010-2014 iovation, Inc. All rights reserved.
 *
 * iovation hereby grants to Client a nonexclusive, limited, non-transferable,
 * revocable and non-sublicensable license to install, use, copy and
 * distribute the iovation ReputationShield™ SDK solely as necessary to use
 * the the iovation DevicePrint™ and ReputationManager™ services and platform
 * from within software created and distributed by Client, pursuant to the
 * <a href="https://help.iovation.com/Downloads/iovation_SDK_License>License</a>
 * and Service Agreement between iovation and Client.
 *
 */
@interface iovation : NSObject

/*!
 * Collects information about the device and returns an encrypted string, or
 * blackbox, containing this information.
 *
 * @note The blackbox returned from @p ioBegin should never be empty. An empty
 * blackbox indicates that the protection offered by the system may have been
 * compromised.
 *
 * @since v1.0.0
 *
 * @return An NSString representing a blackbox containing encrypted device information.
 *
 */

+ (NSString *)ioBegin;

@end

#else
FOUNDATION_EXPORT double iovationVersionNumber;
FOUNDATION_EXPORT const unsigned char iovationVersionString[];
#endif
