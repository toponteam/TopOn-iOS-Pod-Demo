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
@protocol FBBKWaterfallEntry;
NS_ASSUME_NONNULL_BEGIN

/**
 * Represents a waterfall and used as a bridge between mediation systems to bidding.
 * It is a sorted list of FBWaterfallEntry
 * We can insert both from a FBBKBid* and a FBWaterfallEntry.
 */
@protocol FBBKWaterfall <NSObject>
/**
 * This method will create a copy of the existing Waterfall.
 * We do not need to also create a copy of the WaterfallEntries.
 * Multiple threads might be calling this at the same time.
 * Look out for synchronization issues.
 *
 * @return a copy of the current waterfall.
 */
- (id<FBBKWaterfall>)createWaterfallCopy;
/**
 * This method will insert a WaterfallEntry into the Waterfall from the given Bid.
 * Multiple threads might be calling this at the same time.
 * Look out for synchronization issues.
 *
 * @param bid a given bid from which you can create a WaterfallEntry and insert in the waterfall
 */
- (void)insertEntryUsingBid:(FBBKBid *)bid;
/**
 * This method will insert a FBBKWaterfallEntry into the Waterfall.
 * Multiple threads might be calling this at the same time.
 * Look out for synchronization issues.
 *
 * @param entry a given waterfallEntry which should be inserted into the Waterfall
 */
- (void)insertEntry:(id<FBBKWaterfallEntry>)entry;
/**
 * This method will return an array of FBBKWaterfallEntry
 *
 * @return array of FBBKWaterfallEntry
 */
@property (nonatomic, readonly) NSArray<id<FBBKWaterfallEntry>> *entries;

@end

NS_ASSUME_NONNULL_END
