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
@class FBBKBid;

NS_ASSUME_NONNULL_BEGIN

/**
 * Represents a single entry within a FBBKWaterfall
 * It which holds data from both traditional waterfall and bidding
 */
@protocol FBBKWaterfallEntry <NSObject>
/**
 * Returns a FBBKBid, if one exists.
 * This could return nil, if the entry is not from a bidder.
 *
 * @return The bid for this entry. It can be nil.
 */
@property (nonatomic, readonly, nullable) FBBKBid *bid;
/**
 * This method returns, for both bidders and traditional waterfall, the value of this
 * FBBKWaterfallEntry in cents
 *
 * @return the value offered by this WaterfallEntry in cents
 */
@property (nonatomic, readonly) double CPMCents;
/**
 * This method returns a unique identifier for each of the bidders/traditional waterfall entries
 *
 * @return the unique identifier for the bidder/traditional waterfall entry
 */
@property (nonatomic, readonly) NSString *entryName;

@end

NS_ASSUME_NONNULL_END
