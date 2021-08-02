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

typedef NS_ENUM(NSInteger, FBBKChartboostAdBidFormat) {
    FBBKChartboostAdBidFormatBanner,
    FBBKChartboostAdBidFormatInterstitial,
    FBBKChartboostAdBidFormatRewardedVideo
};

NS_ASSUME_NONNULL_BEGIN
/**
 * Parameters for Chartboost bidder
 */
@interface FBBKChartboostBidderParameters : NSObject
/**
 * Designated Initializer for specific bidder parameters
 */
- (instancetype)initWithAppId:(NSString *)appId
                  placementId:(NSString *)placementId
                  adBidFormat:(FBBKChartboostAdBidFormat)adBidFormat
                  publisherId:(NSString *)publisherId
                publisherName:(NSString *)publisherName
               storeURLString:(NSString *)storeURLString
          applicationCategory:(NSString *)applicationCategory NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
/**
 * Required parameter and should be passed in the designated initializer
 */
@property (nonatomic, readonly, copy) NSString *appId;

@property (nonatomic, readonly, copy) NSString *placementId;
@property (nonatomic, readonly, copy) NSString *publisherId;
@property (nonatomic, readonly, copy) NSString *publisherName;
@property (nonatomic, readonly, copy) NSString *storeURLString;
@property (nonatomic, readonly, copy) NSString *applicationCategory;
/**
 * Advertisment Format parameter for the given bidder
 * Required parameter and should be passed in the designated initializer
 */
@property (nonatomic, readonly) FBBKChartboostAdBidFormat adBidFormat;

/**
 * This method sets the Flag indicating if this request is subject to the COPPA regulations
 * established by the USA FTC for the given bidder
 * Default is 'NO'
 */
@property (nonatomic, assign) BOOL coppa;
@property (nonatomic, assign) BOOL gdpr;
@property (nonatomic, assign) BOOL consent;
/**
 * Request bids in test mode
 * Default is 'NO'
 */
@property (nonatomic, assign) BOOL testMode;

@property (nonatomic, assign) BOOL skippable;
@property (nonatomic, assign) NSInteger minimumVideoDuration;
@property (nonatomic, assign) NSInteger maximumVideoDuration;

@end

NS_ASSUME_NONNULL_END
