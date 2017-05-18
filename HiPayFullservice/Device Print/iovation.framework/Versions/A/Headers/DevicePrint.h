//
//  DevicePrint.h
//  libiovation
//
//  Created by David E. Wheeler on 9/23/14.
//  Copyright (c) 2014 iovation, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @header
 *
 * @brief iovation device inspector SDK for iOS
 *
 * iovation ReputationManager™ identifies devices through information collected
 * by this SDK, which runs on an end user’s iOS device. DevicePrint
 * schedules and runs tasks in an asynchronous queue that collect the data
 * necessary to generate a blackbox containing details about the device. This
 * blackbox must then be transmitted to your servers to be used in a reputation
 * check (for example a @p CheckTransactionDetails call).
 *
 * @version 4.1.0
 * @copyright 2010-2014 iovation, Inc. All rights reserved.
 *
 * iovation hereby grants to Client a nonexclusive, limited, non-transferable,
 * revocable and non-sublicensable license to install, use, copy and
 * distribute the iovation ReputationShield™ SDK solely as necessary to use
 * the the iovation DevicePrint™ and ReputationManager™ services and platform
 * from within software created and distributed by Client, pursuant to the
 * <a href="https://help.iovation.com/Downloads/iovation_SDK_License">License</a>
 * and Service Agreement between iovation and Client.
 *
 */
@interface DevicePrint : NSObject

/*!
 * Starts the device inspector and returns. The inspector runs asynchronously on
 * its own thread, thereby minimizing the impact on the responsiveness of your
 * app. This method should be called in the @p -applicationDidBecomeActive:
 * method of your app delegate.
 *
 * @code
 * - (void)applicationDidBecomeActive:(UIApplication *)app
 * {
 *     [DevicePrint start];
 * }
 * @endcode
 *
 * @since v4.0.0
 *
 */
+ (void)start;

/*!
 * Schedules the device inspector to start after the speciried delay. The
 * inspector runs asynchronously on its own thread, thereby minimizing the
 * impact on the responsiveness of your app.This method should be called in the
 * @p -applicationDidBecomeActive: method of your app delegate.

 *
 * @code
 * - (void)applicationDidBecomeActive:(UIApplication *)app
 * {
 *     [DevicePrint startAFterDelay:10.0];
 * }
 * @endcode
 *
 * @since v4.0.0
 *
 * @param delay The interval to delay before starting the inspector, in seconds.
 *
 */
+ (void)startAfterDelay:(NSTimeInterval)delay;

/*!
 * Stops the device inspector and returns. This cancels all currently-running
 * inspection jobs, if any. It may take a little time for the jobs to stop,
 * although this method returns without waiting.
 *
 * You should not normally need to call this method, as DevicePrint listens
 * for @p UIApplicationDidEnterBackgroundNotification notfications in order to
 * keep itself running in the background long enough to finish its current jobs.
 * If you would rather it didn't finish its tasks in the background, you may
 * call this method in @p -applicationWillResignActive:.
 * 
 * @code
 * - (void)applicationWillResignActive:(UIApplication *)app
 * {
 *     [DevicePrint stop];
 * }
 * @endcode
 *
 * @since v4.0.0
 *
 */
+ (void)stop;

/*!
 * Suspends the device inspector and returns. Calling this method prevents the
 * DevicePrint from starting any new jobs, but already executing jobs
 * continue to execute. Consider calling this method when your application
 * needs to perform an intensive operation and requires minimal resource
 * contention.
 *
 * @code
 * [DevicePrint suspend];
 * expensiveOperation();
 * [DevicePrint resume];
 * @endcode
 *
 * @since v4.0.0
 *
 */
+ (void)suspend;

/*!
 * Resumes a suspended device inspector and returns. Call this method after
 * @p +suspend has been called, and after the completion of a resource-intensive
 * operation.
 *
 * @code
 * [DevicePrint suspend];
 * expensiveOperation();
 * [DevicePrint resume];
 * @endcode
 *
 * @since v4.0.0
 *
 */
+ (void)resume;

/*!
 * Marshalls information about the device and returns an encrypted string, or
 * blackbox, containing this information.
 *
 * @note The blackbox returned from @p bb should never be empty. An empty
 * blackbox indicates that the protection offered by the system may have been
 * compromised.
 *
 * @since v4.0.0
 *
 * @return An NSString representing a blackbox containing encrypted device information.
 *
 */
#if __has_feature(nullability)
+ (nonnull NSString *)blackbox;
#else
+ (NSString *)blackbox;
#endif

@end
