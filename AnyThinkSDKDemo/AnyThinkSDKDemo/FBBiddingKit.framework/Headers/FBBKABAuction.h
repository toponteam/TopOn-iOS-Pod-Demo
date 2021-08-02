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
@protocol FBBKABTest;
@protocol FBBKABTestSegment;
@protocol FBBKWaterfall;
@protocol FBBKWaterfallEntry;
@protocol FBBKABAuctionDelegate;

NS_ASSUME_NONNULL_BEGIN
/**
 * Represents an auction that supports AB testing. This protocol allows running different auctions
 * for different users based on the FBBKABTestSegment they're associated with, which are
 * determined by FBBKABTest. Each segment is associated with a set of real-time bidders.
 * Use -startWithABTest:waterfall: to start an auction.
 */
@protocol FBBKABAuction <NSObject>
/**
 * An integer indentifier for a particular A/B Auction
 */
@property (nonatomic, readonly) NSInteger abAuctionId;
/**
 * Delegate for A/B Auction instance. Set up for listenening to updates and notifications
 */
@property (nonatomic, weak, nullable) id<FBBKABAuctionDelegate> delegate;
/**
 * Chooses an A/B auction for segment and starts it with values provided by waterfall
 * This method can be called only once.
 *
 * All bidders in the auction run in parallel and all start at the same time.
 * They are all given the same timeout defined by the configuration set in
 * +[FBBKBiddingKit initializeWithConfig:] method.
 * Bidders that do not obtain a bid in the provided time slot will not be
 * considered for the auction, even if they return a bid later.
 *
 * @param test A/B test for this auction
 * @param waterfall Interface for providing waterfall entries
 */
- (void)startWithABTest:(id<FBBKABTest>)test waterfall:(id<FBBKWaterfall>)waterfall;
/**
* Chooses an A/B auction for segment and starts a remote auction with values provided by waterfall
* This method can be called only once.
*
*
* @param test A/B test for this auction
* @param waterfall Interface for providing waterfall entries
* @param url The base url for the server running the auction. Exact endpoint will be appended.
*/
- (void)startRemoteWithABTest:(id<FBBKABTest>)test waterfall:(id<FBBKWaterfall>)waterfall url:(NSURL *)url;
/**
 * Must be called just before an ad is displayed. Notifies bidders of the demand source
 * (real-time or not) that has eventually displayed the ad. This is later used to estimate
 * ARPDAU by bidding kit and is necessary for optimisations
 *
 * @param winnerEntry the winning WaterfallEntry which is being shown on screen
 */
- (void)notifyDisplayWinner:(id<FBBKWaterfallEntry>)winnerEntry;
@end

/**
 * A/B Auction Delegate
 */
@protocol FBBKABAuctionDelegate <NSObject>
@optional
/**
 * This method will be called when the A/B Auction is completed
 *
 * @param abAuction A/B Auction which notified about completion
 * @param waterfall The waterfall with the updated bidders.
 */
- (void)fbbkabAuction:(id<FBBKABAuction>)abAuction didCompleteWithWaterfall:(id<FBBKWaterfall>)waterfall;

/*
 * This method will be called when there was an error during remote auction.
 *
 * @param auction A/B Auction which notified about completion
 * @param error The error object containing the error occured.
 */
- (void)fbbkabAuction:(id<FBBKABAuction>)auction didFailWithError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
