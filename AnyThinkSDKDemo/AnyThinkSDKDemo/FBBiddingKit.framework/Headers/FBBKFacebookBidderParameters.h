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

NS_ASSUME_NONNULL_BEGIN

/**
 * Facebook Bid Format
 */
typedef NS_ENUM(NSInteger, FBBKFacebookAdBidFormat) {
    FBBKFacebookAdBidFormatBanner_320_50,     // Bid For Banner 320x50
    FBBKFacebookAdBidFormatBanner_HEIGHT_50,  // Bid For Banner with flexible width and height 50
    FBBKFacebookAdBidFormatBanner_HEIGHT_90,  // Bid For Banner with flexible width and height 90
    FBBKFacebookAdBidFormatBanner_HEIGHT_250, // Bid For Banner with flexible width and height 250
    FBBKFacebookAdBidFormatInterstitial,      // Bid For Interstitial
    FBBKFacebookAdBidFormatInstreamVideo,     // Bid For Instream Video
    FBBKFacebookAdBidFormatRewardedVideo,     // Bid For Rewarded Video
    FBBKFacebookAdBidFormatNative,            // Bid For Native
    FBBKFacebookAdBidFormatNativeBanner,      // Bid For Native Banner
};

/**
 * Parameters for Faceboook Bidder
 */
@interface FBBKFacebookBidderParameters : NSObject
/**
 * Designated Initializer for specific bidder parameters
 * Required for FBBKFacebookBidder
 * @param appId Application identifer / Main Bundle Identifier
 * @param placementId Placement Idenfier for a specific ad
 * @param adBidFormat Advertisment Format parameter for the given bidder
 * @param bidToken Token for bidding. Provided by AppLovin SDK
 */
- (instancetype)initWithAppId:(NSString *)appId
                  placementId:(NSString *)placementId
                  adBidFormat:(FBBKFacebookAdBidFormat)adBidFormat
                     bidToken:(NSString *)bidToken NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
/**
 * Application identifer / Main Bundle Identifier
 * Required parameter and should be passed in the designated initializer
 */
@property (nonatomic, readonly, copy) NSString *appId;
/**
 * Placement Idenfier for a specific ad
 * Required parameter and should be passed in the designated initializer
 */
@property (nonatomic, readonly, copy) NSString *placementId;
/**
 * Advertisment Format parameter for the given bidder
 * Required parameter and should be passed in the designated initializer
 */
@property (nonatomic, readonly) FBBKFacebookAdBidFormat adBidFormat;
/**
 * Token for bidding. Provided by FB Audience Network SDK
 * Required parameter and should be passed in the designated initializer
 * see https://developers.facebook.com/products/audience-network/ for more information
 */
@property (nonatomic, readonly, copy) NSString *bidToken;
/**
 * Sets test mode for the given bidder
 * Marks this request as a test request and these requests won't be considered as real
 * traffic.
 * It should be used for testing integrations.
 * Default is 'NO'
 */
@property (nonatomic, assign) BOOL testMode;
/**
 * Sets the auction type for the given bidder.
 * It indicates whether the auction type is going to be first price auction or second price
 * auction
 * Default is 'FBBKAdBidAuctionTypeFirstPrice'
 */
@property (nonatomic, assign) FBBKAdBidAuctionType auctionType;
/**
 * This method sets the Flag indicating if this request is subject to the COPPA regulations
 * established by the USA FTC for the given bidder
 * Default is 'NO'
 */
@property (nonatomic, assign) BOOL coppa;
/**
 * This method sets the platformID for the given bidder
 * Default is 'nil'
 */
@property (nonatomic, copy, nullable) NSString *platformId;
/**
 * Indicates whether Facebook bidder is used as a standalone bidder
 * which is not part of the auction.
 *
 * Default value is YES.
 */
@property (nonatomic, assign) BOOL standalone;

@end

NS_ASSUME_NONNULL_END
