//
//  SelfRenderVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import "SelfRenderVC.h"

#import <AnyThinkNative/AnyThinkNative.h>

#import "AdLoadConfigTool.h"
#import "SelfRenderView.h"
#import "AdDisplayVC.h"

@interface SelfRenderVC () <ATNativeADDelegate>

@property (strong, nonatomic) ATNativeADView  * adView;
@property (strong, nonatomic) SelfRenderView  * selfRenderView;
@property (nonatomic, strong) ATNativeAdOffer * nativeAdOffer;
// Retry attempt counter
@property (nonatomic, assign) NSInteger         retryAttempt;

@end

@implementation SelfRenderVC

// Placement ID
#define Native_SelfRender_PlacementID @"n67eceed5a282d"

// Scene ID, optional, can be generated in the backend. Pass empty string if not available
#define Native_SelfRender_SceneID @""
 
#pragma mark - Load Ad
/// Load ad
- (void)loadAd {
 
    [self showLog:kLocalizeStr(@"Clicked load ad")];
     
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    
    // Set ad request size
    [loadConfigDict setValue:[NSValue valueWithCGSize:CGSizeMake(SelfRenderViewWidth, SelfRenderViewHeight)] forKey:kATExtraInfoNativeAdSizeKey];
    // Request adaptive size native ad (available for some ad platforms)
    [AdLoadConfigTool native_loadExtraConfigAppend_SizeToFit:loadConfigDict];
    
    // KuaiShou native ad swipe and click control
//    [AdLoadConfigTool native_loadExtraConfigAppend_KuaiShou_SlideOrClickAble:loadConfigDict];
  
    [[ATAdManager sharedManager] loadADWithPlacementID:Native_SelfRender_PlacementID extra:loadConfigDict delegate:self];
}
 
#pragma mark - Show Ad
/// Show ad
- (void)showAd {
    
    // Scene statistics feature, optional integration
    [[ATAdManager sharedManager] entryNativeScenarioWithPlacementID:Native_SelfRender_PlacementID scene:Native_SelfRender_SceneID];
    
//    // Query available ad cache for display (optional integration)
//    NSArray <NSDictionary *> * adCaches = [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:Native_SelfRender_PlacementID];
//    ATDemoLog(@"getValidAds : %@",adCaches);
//
//    // Query ad loading status (optional integration)
//    ATCheckLoadModel * status = [[ATAdManager sharedManager] checkNativeLoadStatusForPlacementID:Native_SelfRender_PlacementID];
//    ATDemoLog(@"checkLoadStatus : %d",status.isLoading);
    
    // Check if ready
    if (![[ATAdManager sharedManager] nativeAdReadyForPlacementID:Native_SelfRender_PlacementID]) {
        [self loadAd];
        return;
    }
    
    // Initialize config configuration
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    // Pre-layout for native ad
    config.ADFrame = CGRectMake(0, 0, SelfRenderViewWidth, SelfRenderViewHeight);
    // Pre-layout for video player, recommend to layout again after adding to custom view
    config.mediaViewFrame = CGRectMake(0, 0, SelfRenderViewMediaViewWidth, SelfRenderViewMediaViewHeight);
    config.delegate = self;
    config.rootViewController = self;
    // Make ad view container fit the ad
    config.sizeToFit = YES;
    // Set auto-play only in WiFi mode, effective for some ad platforms
    config.videoPlayType = ATNativeADConfigVideoPlayOnlyWiFiAutoPlayType;

    // [Manual Layout] Precisely set logo size and position, choose one implementation with [Masonry Method] below
    config.logoViewFrame = CGRectMake(kScreenW-50-10, SelfRenderViewHeight-50-10, 50, 50);
    
    // Set ad platform logo position preference (some ad platforms cannot be precisely set, use the code below, Demo examples all show bottom-right corner)
    // Only when logoUrl or logo has value in material offer, can be set through SelfRenderView layout, otherwise use examples in this method for precise control or preference position setting.
    [ATAPI sharedInstance].preferredAdLogoPosition = ATAdLogoPositionBottomRightCorner;
    
    // Set ad identifier coordinates x and y, effective for some ad platforms, set outside screen to achieve hiding effect
    // config.adChoicesViewOrigin = CGPointMake(10, 10);
    
    // Get offer ad object, consumes one ad cache after retrieval
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:Native_SelfRender_PlacementID scene:Native_SelfRender_SceneID];
    NSDictionary *offerInfoDict = [Tools getOfferInfo:offer];
    ATDemoLog(@"🔥🔥🔥--自渲染广告素材，展示前：%@",offerInfoDict);
    self.nativeAdOffer = offer;
    
    // Create self-render view and assign values based on offer information
    SelfRenderView *selfRenderView = [[SelfRenderView alloc] initWithOffer:offer];
    
    // Create ad nativeADView
    // Get native ad display container view
    ATNativeADView *nativeADView = [[ATNativeADView alloc] initWithConfiguration:config currentOffer:offer placementID:Native_SelfRender_PlacementID];
    
    // Create container array for clickable components
    NSMutableArray *clickableViewArray = [NSMutableArray array];
    
    // Get mediaView, need to add to self-render view manually, must call
    UIView *mediaView = [nativeADView getMediaView];
    if (mediaView) {
        // Assign and layout
        selfRenderView.mediaView = mediaView;
    }
    
    // Set UI controls that need to register click events, better not to add the entire parent view of the feed to click events, otherwise clicking the close button may still trigger the feed click event.
    // Close button (dislikeButton) does not need to register click events
    [clickableViewArray addObjectsFromArray:@[selfRenderView.iconImageView,
                                              selfRenderView.titleLabel,
                                              selfRenderView.textLabel,
                                              selfRenderView.ctaLabel,
                                              selfRenderView.mainImageView]];
    
    // Register click events for UI controls
    [nativeADView registerClickableViewArray:clickableViewArray];
    
    // Bind components
    ATNativePrepareInfo *info = [ATNativePrepareInfo loadPrepareInfo:^(ATNativePrepareInfo * prepareInfo) {
        prepareInfo.textLabel = selfRenderView.textLabel;
        prepareInfo.advertiserLabel = selfRenderView.advertiserLabel;
        prepareInfo.titleLabel = selfRenderView.titleLabel;
        prepareInfo.ratingLabel = selfRenderView.ratingLabel;
        prepareInfo.iconImageView = selfRenderView.iconImageView;
        prepareInfo.mainImageView = selfRenderView.mainImageView;
        prepareInfo.logoImageView = selfRenderView.logoImageView;
        prepareInfo.ctaLabel = selfRenderView.ctaLabel;
        prepareInfo.dislikeButton = selfRenderView.dislikeButton;
        prepareInfo.mediaView = selfRenderView.mediaView;
    }];
    [nativeADView prepareWithNativePrepareInfo:info];
    
    // Render ad
    [offer rendererWithConfiguration:config selfRenderView:selfRenderView nativeADView:nativeADView];
    
    // [Masonry Method] Precisely set logo size and position, choose one implementation with [Manual Layout] above, call after rendering ad
//    if (nativeADView.logoImageView && nativeADView.logoImageView.superview) {
//        [nativeADView.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.bottom.mas_equalTo(nativeADView).mas_offset(-10);
//            make.width.height.mas_equalTo(20);
//        }];
//    }
//
    // For testing print
//    [self printNativeAdInfoAfterRendererWithOffer:offer nativeADView:nativeADView];
 
    self.adView = nativeADView;
    
    // Show ad
    AdDisplayVC *showVc = [[AdDisplayVC alloc] initWithAdView:nativeADView offer:offer adViewSize:CGSizeMake(SelfRenderViewWidth, SelfRenderViewHeight)];
    [self.navigationController pushViewController:showVc animated:YES];
}
  
/// Print related information for testing
/// - Parameters:
///   - offer: Ad material
///   - nativeADView: Ad object view
- (void)printNativeAdInfoAfterRendererWithOffer:(ATNativeAdOffer *)offer nativeADView:(ATNativeADView *)nativeADView {
    ATNativeAdRenderType nativeAdRenderType = [nativeADView getCurrentNativeAdRenderType];
    if (nativeAdRenderType == ATNativeAdRenderExpress) {
        ATDemoLog(@"⚠️⚠️⚠️--这是原生模板了");
    } else {
        ATDemoLog(@"✅✅✅--这是原生自渲染");
    }
    BOOL isVideoContents = [nativeADView isVideoContents];
    
    // Print all material content
    [Tools printNativeAdOffer:offer];
    ATDemoLog(@"🔥--是否为原生视频广告：%d",isVideoContents);
}

#pragma mark - Remove Ad
- (void)removeAd {
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
    }
    [self.adView destroyNative];
    self.adView = nil;
    // Destroy offer more timely
    [self.selfRenderView destory];
    self.selfRenderView = nil;
}
 
- (void)dealloc {
    
    // Purpose is to correctly release: [self.adView destroyNative];
    [self removeAd];
}

#pragma mark - Placement Delegate Callbacks
/// Placement loading completed
/// - Parameter placementID: Placement ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] nativeAdReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ SelfRender 是否准备好:%@", placementID,isReady ? @"YES":@"NO"]];
    
    // Reset retry attempts
    self.retryAttempt = 0;
}
 
/// Placement loading failed
/// - Parameters:
///   - placementID: Placement ID
///   - error: Error information
- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    ATDemoLog(@"didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
    
    // Retry has reached 3 times, no more retry loading
    if (self.retryAttempt >= 3) {
       return;
    }
    self.retryAttempt++;
    
    // Calculate delay time: power of 2, maximum 8 seconds
    NSInteger delaySec = pow(2, MIN(3, self.retryAttempt));

    // Delayed retry loading ad
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySec * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self loadAd];
    });
}

/// Received display revenue
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)didRevenueForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didRevenueForPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didRevenueForPlacementID:%@", placementID]];
}

#pragma mark - Native Ad Event Callbacks

/// Native ad displayed
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
- (void)didShowNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didShowNativeAdInAdView:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didShowNativeAdInAdView:%@", placementID]];
    ATDemoLog(@"🔥--原生广告adInfo信息，展示后：%@",self.nativeAdOffer.adOfferInfo);
}

/// Native ad clicked close button
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
- (void)didTapCloseButtonInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didTapCloseButtonInAdView:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"didTapCloseButtonInAdView:%@", placementID]];
    
    // Destroy ad
    [self removeAd];
    // Preload the next ad
    [self loadAd];
}

/// Native ad started playing video
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)didStartPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didStartPlayingVideoInAdView:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didStartPlayingVideoInAdView:%@", placementID]];
}

/// Native ad video playback ended
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)didEndPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didEndPlayingVideoInAdView:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didEndPlayingVideoInAdView:%@", placementID]];
}

/// Native ad user clicked
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)didClickNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didClickNativeAdInAdView:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didClickNativeAdInAdView:%@", placementID]];
}
 
/// Native ad opened or jumped to deep link page
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
///   - success: Whether successful
- (void)didDeepLinkOrJumpInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    ATDemoLog(@"didDeepLinkOrJumpInAdView:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"didDeepLinkOrJumpInAdView:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
}
 
/// Native ad entered fullscreen video playback, usually auto-jumps to a playback landing page after clicking video mediaView
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
- (void)didEnterFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    ATDemoLog(@"didEnterFullScreenVideoInAdView:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didEnterFullScreenVideoInAdView:%@", placementID]];
}

/// Native ad exited fullscreen video playback
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
- (void)didExitFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didExitFullScreenVideoInAdView:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didExitFullScreenVideoInAdView:%@", placementID]];
}
 
/// Native ad exited detail page
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
- (void)didCloseDetailInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didCloseDetailInAdView:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"didCloseDetailInAdView:%@", placementID]];
}
 
@end
