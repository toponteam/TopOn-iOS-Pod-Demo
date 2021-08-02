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

/**
 * Tapjoy Bid Format
 */
typedef NS_ENUM(NSInteger, FBBKTapjoyAdBidFormat) {
    FBBKTapjoyAdBidFormatInterstitial,
    FBBKTapjoyAdBidFormatRewardedVideo,
};

NS_ASSUME_NONNULL_BEGIN
/**
 * Parameters for Tapjoy Bidder
 */
@interface FBBKTapjoyBidderParameters : NSObject
/**
 * Designated Initializer for specific bidder parameters
 * Required for FBBKTapjoyBidder
 * @param sdkKey for Tapjoy bidder. Provided by Tapjoy SDK
 * @param placementId Placement for the given bidder
 * @param adBidFormat Advertisment Format parameter for the given bidder
 * @param bidToken Token for bidding. Provided by Tapjoy SDK
 */
- (instancetype)initWithSDKKey:(NSString *)sdkKey
                   placementId:(NSString *)placementId
                   adBidFormat:(FBBKTapjoyAdBidFormat)adBidFormat
                      bidToken:(NSString *)bidToken NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
/**
 * SDK key for Tapjoy
 * Required parameter and should be passed in the designated initializer
 */
@property (nonatomic, readonly, copy) NSString *sdkKey;
/**
 * Placement for the given bidder
 * Required parameter and should be passed in the designated initializer
 */
@property (nonatomic, readonly, copy) NSString *placementId;
/**
 * Advertisment Format parameter for the given bidder
 * Required parameter and should be passed in the designated initializer
 */
@property (nonatomic, readonly) FBBKTapjoyAdBidFormat adBidFormat;
/**
 * Token for bidding. Provided by Tapjoy SDK
 * Required parameter and should be passed in the designated initializer
 * see https://docs.google.com/document/d/1-KnvBLLJ2uqaBWHX0vjWb2zlTVEynWtBGCK4L38VOZg/ for more information
 */
@property (nonatomic, readonly, copy) NSString *bidToken;
/**
 * This method sets the Flag indicating if this request is subject to the COPPA regulations
 * established by the USA FTC for the given bidder
 * Default is 'NO'
 */
@property (nonatomic, assign) BOOL coppa;
/**
 * Sets test mode for the given bidder
 * Marks this request as a test request and these requests won't be considered as real traffic.
 * It should be used for testing integrations.
 * Default is 'NO'
 */
@property (nonatomic, assign) BOOL testMode;

@end

NS_ASSUME_NONNULL_END
