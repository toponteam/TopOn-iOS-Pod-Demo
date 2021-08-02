// Copyright 2004-present Facebook. All Rights Reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
@class FBBKConfiguration;

#ifndef FBBK_DEPRECATED
    #define FBBK_DEPRECATED(MESSAGE) __attribute__((deprecated(MESSAGE)))
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 * FBBKBiddingKit
 */
@interface FBBKBiddingKit : NSObject

/**
 * Initialises the FBBKBiddingKit SDK
 * This should be called before calling any other bidding kit methods.
 * You can pass it a custom configuration as an argument.
 * The configuration is an object of FBBKConfiguration class.
 * Configuration will be deep copied after initialization.
 *
 * @param configuration with parameters
 */
+ (void)initializeWithConfiguration:(nullable FBBKConfiguration *)configuration;

/**
 * DEPRECATED
 *
 * Initialises the FBBKBiddingKit SDK
 * This should be called before calling any other bidding kit methods.
 * You can pass it a custom configuration as an argument.
 * The configuration is a json.
 * Example:
 * {
 *  "auction" : { "timeout_ms" : 1000 }
 * }
 *
 * @param config represents the configuration as a string
 */
+ (void)initializeWithConfig:(NSString *)config FBBK_DEPRECATED("No longer supported. Please use +initializeWithConfiguration: instead");

/**
 * DEPRECATED
 *
 * Enables/disables verbose logging for the SDK.
 * If enabled all logs will appear in console with prefix '[FBBiddingKit]'
 * Set to 'NO' to mute SDK and remove logs (recommended for release builds).
 *
 * Default value is 'NO'.
 */
@property (class, atomic, assign, getter = isVerboseLoggingEnabled) BOOL verboseLoggingEnabled FBBK_DEPRECATED("No longer supported. Please use FBBKConfiguration.verboseLoggingEnabled instead");

@end

NS_ASSUME_NONNULL_END
