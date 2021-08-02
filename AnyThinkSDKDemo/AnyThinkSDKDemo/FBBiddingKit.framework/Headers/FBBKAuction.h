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
@protocol FBBKAuctionDelegate;
@protocol FBBKWaterfall;
@protocol FBBKWaterfallEntry;

NS_ASSUME_NONNULL_BEGIN
/**
 * This is an FBBKAuction, to which you can provide segments and bidders.
 * When doing -startUsingWaterfall:, it will run the given bidders.
 */
@protocol FBBKAuction <NSObject>
/**
 * An integer indentifier for a particular FBBKAuction
 */
@property (nonatomic, readonly) NSInteger auctionId;
/**
 * Delegate for FBBKAuction instance. Set up for listenening to updates and notifications
 */
@property (nonatomic, nullable, weak) id<FBBKAuctionDelegate> delegate;
/**
 * Starts running an auction with the given bidders FBBKBidder.
 * This method will run the auction asynchronously and will return immediately.
 * This method can be called only once.
 *
 * Bidders are added to an auction through (see -[FBBKAuctionImpl initWithBidders:];)
 * When the auction is finished, we will return a waterfall copy
 * (see -[FBBKWaterfall createWaterfallCopy];) which will include the results of the bids
 * of the auction results.
 * All bidders in the auction run in parallel and all start at the same time.
 * They are all given the same timeout defined by the configuration set in
 * (see +[FBBiddingKit initializeWithConfig:] method. Bidders that do not obtain a bid in the provided
 * time slot will not be considered for the auction, even if they return a bid later.
 *
 * @param waterfall The waterfall we want to use for this FBBKAuction
 */
- (void)startUsingWaterfall:(id<FBBKWaterfall>)waterfall;

/**
* Starts running a remote auction with the given bidders FBBKBidder.
* This method will run the auction asynchronously and will return immediately.
* This method can be called only once.
*
* @param waterfall The waterfall we want to use for this FBBKAuction
* @param url The base url for the server running the auction. Exact endpoint will be appended.
*/
- (void)startRemoteUsingWaterfall:(id<FBBKWaterfall>)waterfall url:(NSURL *)url;

/**
 * Must be called just before an ad is displayed. Notifies bidders of the demand source
 * (real-time or not) that has eventually displayed the ad. This is later used to estimate
 * ARPDAU by bidding kit and is necessary for optimisations
 *
 * @param winnerEntry the winning FBBKWaterfallEntry which is being shown on screen
 */
- (void)notifyDisplayWinner:(id<FBBKWaterfallEntry>)winnerEntry;
@end

/**
 * This is an FBBKAuctionDelegate
 * We use it to notify about the auction completion
 */
@protocol FBBKAuctionDelegate <NSObject>
@optional
/**
 * This method will be called when the auction is completed.
 *
 * @param auction Auction which notified about completion
 * @param waterfall The waterfall with the updated bidders.
 */
- (void)fbbkAuction:(id<FBBKAuction>)auction didCompleteWithWaterfall:(id<FBBKWaterfall>)waterfall;

/**
* This method will be called when there was an error during remote auction.
*
* @param auction Auction which notified about completion
* @param error The error object containing the error occured.
*/
- (void)fbbkAuction:(id<FBBKAuction>)auction didFailWithError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
