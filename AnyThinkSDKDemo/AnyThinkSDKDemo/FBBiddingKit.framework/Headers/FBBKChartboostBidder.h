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

#import "FBBKBidder.h"

@class FBBKChartboostBidderParameters;

NS_ASSUME_NONNULL_BEGIN
/**
 * Name for Chartboost bidders. Can be checked in -bidderName method.
 */
extern NSString *const kFBBKChartboostBidderName;

/**
 * Represents a bidder connected to Chartboost's endpoint, to which you can
 * provide a set of parameters.
 * We will be using this bidder in Auction and A/B Auction
 * and you can call -retrieveBidComplete: on it's own.
 */
@interface FBBKChartboostBidder : NSObject <FBBKBidder>
/**
 * Designated initializer for Chartboost Bidder
 */
- (instancetype)initWithParameters:(FBBKChartboostBidderParameters *)parameters;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
