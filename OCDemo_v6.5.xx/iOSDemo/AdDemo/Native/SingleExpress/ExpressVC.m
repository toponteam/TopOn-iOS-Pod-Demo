//
//  ExpressVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/18.
//

#import "ExpressVC.h"

#import <AnyThinkSDK/AnyThinkSDK.h>
 
#import "AdDisplayVC.h"

@interface ExpressVC () <ATNativeADDelegate>

@property (strong, nonatomic) ATNativeADView  * adView;
@property (nonatomic, strong) ATNativeAdOffer * nativeAdOffer;
// Retry attempts counter
@property (nonatomic, assign) NSInteger         retryAttempt;

@end

@implementation ExpressVC

// Placement ID

// Third-party ad platform with native template rendering
#define Native_Express_PlacementID @"n67ee1208bb52d"

// SDK rendering - actual third-party ad is self-rendered placement
//#define Native_Express_PlacementID @"n67ff515ba1460"

// Scene ID, optional, can be generated in dashboard. Pass empty string if none
#define Native_Express_SceneID @""

// Note: template aspect ratio should match dashboard selection
#define ExpressAdWidth (kScreenW)
// Note: template aspect ratio should match dashboard selection
#define ExpressAdHeight (kScreenW/2.f)

#define ExpressMediaViewWidth (kScreenW)
#define ExpressMediaViewHeight (350 - kNavigationBarHeight - 150)
 
#pragma mark - Load Ad
/// Load ad button clicked
- (void)loadAd {
 
    [self showLog:kLocalizeStr(@"Clicked load ad")];
     
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    
    // Request template ad with specified size, ad platform will match this size to return ad, not necessarily exact match, depends on template type selected in ad platform dashboard
    [loadConfigDict setValue:[NSValue valueWithCGSize:CGSizeMake(ExpressAdWidth, ExpressAdHeight)] forKey:kATExtraInfoNativeAdSizeKey];
    
    // Adaptive height，Some network supported , such as CSJ，JD，KuaiShou.
    // [loadConfigDict setValue:@YES forKey:kATNativeAdSizeToFitKey];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:Native_Express_PlacementID extra:loadConfigDict delegate:self];
}
 
#pragma mark - Show Ad
/// Show ad button clicked
- (void)showAd {
    
    // Scene statistics feature, optional integration
    [[ATAdManager sharedManager] entryNativeScenarioWithPlacementID:Native_Express_PlacementID scene:Native_Express_SceneID];
    
//    // Query available ad cache for display (optional integration)
//    NSArray <NSDictionary *> * adCaches = [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:Native_SelfRender_PlacementID];
//    ATDemoLog(@"getValidAds : %@",adCaches);
//
//    // Query ad loading status (optional integration)
//    ATCheckLoadModel * status = [[ATAdManager sharedManager] checkNativeLoadStatusForPlacementID:Native_SelfRender_PlacementID];
//    ATDemoLog(@"checkLoadStatus : %d",status.isLoading);
    
    // Check if ready
    if (![[ATAdManager sharedManager] nativeAdReadyForPlacementID:Native_Express_PlacementID]) {
        [self loadAd];
        return;
    }
    
    // Initialize config configuration
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    // Set size for template ad nativeADView, usually the size set when requesting ad
    config.ADFrame = CGRectMake(0, 0, ExpressAdWidth, ExpressAdHeight);
    config.delegate = self;
    // Set display root controller
    config.rootViewController = self;
    // Enable template ad adaptive height, when actual returned ad size differs from requested size, SDK will automatically adjust nativeADView size to actual returned ad size.
    config.sizeToFit = YES;
    // Set auto-play only in WiFi mode, effective for some ad platforms
    config.videoPlayType = ATNativeADConfigVideoPlayOnlyWiFiAutoPlayType;
 
    // Get offer ad object, consumes one ad cache after retrieval
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:Native_Express_PlacementID scene:Native_Express_SceneID];
    
    // Create ad nativeADView
    ATNativeADView *nativeADView = [[ATNativeADView alloc] initWithConfiguration:config currentOffer:offer placementID:Native_Express_PlacementID];
 
    // Render ad
    [offer rendererWithConfiguration:config selfRenderView:nil nativeADView:nativeADView];
 
    // Reference
    self.adView = nativeADView;
    
    //recommend use offer.nativeAd.nativeExpressAdViewWidth,offer.nativeAd.nativeExpressAdViewHeight first.
//    ATDemoLog(@"🔥--Ad network return size：%lf，%lf，You request size：%f,%f",offer.nativeAd.nativeExpressAdViewWidth,offer.nativeAd.nativeExpressAdViewHeight,ExpressAdWidth,ExpressAdHeight);
    
    BOOL isVideoContents = [nativeADView isVideoContents];
    ATDemoLog(@"🔥--Is Native Video Ad? ：%d",isVideoContents);
    
    // Show ad
    AdDisplayVC *showVc = [[AdDisplayVC alloc] initWithAdView:nativeADView offer:offer adViewSize:CGSizeMake(ExpressAdWidth, ExpressAdHeight)];
    [self.navigationController pushViewController:showVc animated:YES];
}
 
#pragma mark - Remove Ad
- (void)removeAd {
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
    }
    [self.adView destroyNative];
    self.adView = nil;
}
 
#pragma mark - Placement Delegate Callbacks
/// Placement loading completed
/// - Parameter placementID: Placement ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] nativeAdReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ Express 是否准备好:%@", placementID,isReady ? @"YES":@"NO"]];
    
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
    // Preload next ad
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
