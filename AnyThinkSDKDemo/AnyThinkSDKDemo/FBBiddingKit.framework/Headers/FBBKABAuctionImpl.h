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

#import "FBBKABAuction.h"
@protocol FBBKBidder;
@protocol FBBKABTestSegment;

NS_ASSUME_NONNULL_BEGIN
/**
 * Represents an auction that supports AB testing. This is implementation of FBBKABAuction protocol.
 * Use -startWithABTest:waterfall: to start an auction.
 */
@interface FBBKABAuctionImpl : NSObject <FBBKABAuction>
/**
 * Designated initalizer for auction implementation.
 * @param bidders Dictionary of bidders that would participate in the auction run in
 *                the context of a user associated with the segment provided.
 */
- (instancetype)initWithBidders:(NSDictionary<id<FBBKABTestSegment>, NSArray<id<FBBKBidder>> *> *)bidders;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
