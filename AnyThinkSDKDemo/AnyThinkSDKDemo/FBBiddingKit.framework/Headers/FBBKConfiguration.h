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

extern NSString *_Nonnull const kFBBKAuctionEndpoint;
extern NSString *_Nonnull const kFBBKNotificationEndpoint;

NS_ASSUME_NONNULL_BEGIN
/**
 * Configuration object for FBBiddingKit
 */
@interface FBBKConfiguration : NSObject <NSCopying>

/**
 * Allows to set up custom timeout interval for all actions.
 * Measured in seconds.
 *
 * Default value is '10'.
 */
@property (nonatomic, assign) NSTimeInterval auctionTimeout;
/**
 * Enables/disables verbose logging for the SDK.
 * If enabled all logs will appear in console with prefix '[FBBiddingKit]'
 * Set to 'NO' to mute SDK and remove logs (recommended for release builds).
 *
 * Default value is 'NO'.
 */
@property (nonatomic, assign, getter = isVerboseLoggingEnabled) BOOL verboseLoggingEnabled;

@end

NS_ASSUME_NONNULL_END
