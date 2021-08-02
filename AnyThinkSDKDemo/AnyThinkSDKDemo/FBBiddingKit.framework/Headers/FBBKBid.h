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

NS_ASSUME_NONNULL_BEGIN
/**
* Bid object
*/
@interface FBBKBid : NSObject
/**
 * This method will return an unique name for this bidder.
 */
@property (nonatomic, readonly, copy) NSString *bidderName;
/**
 * This method will return an unique identifier for the place where this ad will be shown
 * It's different for different bidders.
 * Each ad network has a way of identifying an ad placement
 */
@property (nonatomic, readonly, nullable, copy) NSString *placementId;
/**
 * This method will return a bid payload, that can be used to show an ad.
 */
@property (nonatomic, readonly, copy) NSString *payload;
/**
 * Returns the price in cents offered by the current bidder.
 */
@property (nonatomic, readonly) double price;
/**
 * This method will return the currency for the current bid.
 * For most cases it should be "USD", unless specified otherwise by an ad network.
 */
@property (nonatomic, readonly, nullable, copy) NSString *currency;
/**
 * Designated Initializer for a bid object provided by FBBKBidder
 *
 * @param bidderName Unique name for this bidder
 * @param placementId Unique identifier for the place where this ad will be shown
 * @param payload Payload from a bid, that can be used for ad loading
 * @param price Price in cents offered by the current bidder
 * @param currency Currency for the current bid
 */
- (instancetype)initWithBidderName:(NSString *)bidderName
                       placementId:(nullable NSString *)placementId
                           payload:(NSString *)payload
                             price:(double)price
                          currency:(nullable NSString *)currency NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
