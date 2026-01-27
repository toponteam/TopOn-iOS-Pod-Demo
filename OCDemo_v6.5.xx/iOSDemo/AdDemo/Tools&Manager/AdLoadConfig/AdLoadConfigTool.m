//
//  AdLoadConfigTool.m
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import "AdLoadConfigTool.h"
#import <AnyThinkSDK/AnyThinkSDK.h>

@implementation AdLoadConfigTool

#pragma mark - KuaiShou Half-Screen Interstitial Ad Size
/// Add interstitial load config for KuaiShou platform only
/// Append KuaiShou interstitial ad load config
/// - Parameter config: Mutable dictionary object, values added by this method
+ (void)interstitial_loadExtraConfigAppend_KuaiShou:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️interstitial_loadExtraConfigAppend_KuaiShou: Input config instance is null");
    }
    CGSize size = CGSizeMake(kScreenW - 30.0f, 300.0f);
    // Set half-screen interstitial ad size, supported platform: KuaiShou, may affect display effect
    [config setValue:[NSValue valueWithCGSize:size] forKey:kATInterstitialExtraAdSizeKey];
}

#pragma mark - Klevin Reward Type Configuration
/// Add rewarded load config for Klevin platform only
/// Append Klevin Rewarded ad load config
/// - Parameter config: Mutable dictionary object, values added by this method
+ (void)rewarded_loadExtraConfigAppend_Klevin:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️splash_loadExtraConfigAppend_Klevin: Input config instance is null");
    }
    
    // Klevin platform only, current rootVC for ad display
    // [config setValue:targetViewController forKey:kATExtraInfoRootViewControllerKey];
    
    // Klevin platform only, reward trigger type: 1:Revival; 2:Check-in; 3:Props; 4:Virtual currency; 5:Other; defaults to 5 if not set
    [config setValue:@1 forKey:kATRewardedVideoKlevinRewardTriggerKey];
     
    // Klevin platform only, reward card duration in seconds
    [config setValue:@3 forKey:kATRewardedVideoKlevinRewardTimeKey];
}

#pragma mark - Pangle Custom Logo
/// Add splash load config for Pangle platform only
/// Append Pangle Splash ad load config
/// - Parameter config: Mutable dictionary object, values added by this method
+ (void)splash_loadExtraConfigAppend_Pangle:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️splash_loadExtraConfigAppendPangle: Input config instance is null");
    }
    //Pangle only, please pass UIImage object
    [config setValue:[UIImage imageNamed:@"logo"] forKey:kATSplashExtraAppLogoImageKey];
}

#pragma mark - Admob Adaptive Banner Settings
/// Add banner load config for Admob platform only
/// Append Admob Banner ad load config
/// - Parameter config: Mutable dictionary object, values added by this method
+ (void)banner_loadExtraConfigAppend_Admob:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️splash_loadExtraConfigAppendPangle: Input config instance is null");
    }

    //Admob adaptive banner settings, import header first: #import <GoogleMobileAds/GoogleMobileAds.h>
    //GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth adaptive
    //GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth portrait
    //GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth landscape
//    GADAdSize admobSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(kScreenW);
//    
//    // Admob platform only, adaptive banner size
//    [config setValue:[NSValue valueWithCGSize:admobSize.size] forKey:kATAdLoadingExtraAdmobBannerSizeKey];
//    [config setValue:@(admobSize.flags) forKey:kATAdLoadingExtraAdmobAdSizeFlagsKey];
}

#pragma mark - Tencent Splash Background Image and Color for Visual Optimization
/// Splash load config for Tencent GDT platform only
/// - Parameter config: Mutable dictionary object, values added by this method
+ (void)splash_loadExtraConfigAppend_Tencent:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️splash_loadExtraConfigAppend_Tencent: Input config instance is null");
    }
    
    UIImage * appLaunchBGImg = [UIImage imageNamed:@"Enter your background image"];
    [config setValue:appLaunchBGImg forKey:@"kATGDTSplashBackgroundImageKey"];
    
    //Choose background for ad loading, recommend matching app's background color
    UIColor * appLaunchBGColor = [UIColor whiteColor];
    [config setValue:appLaunchBGColor forKey:kATSplashExtraBackgroundColorKey];
}

#pragma mark - Request Adaptive Height Ads
/// Request adaptive size native ads (available for some ad platforms)
/// Append load optional size to fit (width=x,height=0) config
/// - Parameter config: Mutable dictionary object, values added by this method
+ (void)native_loadExtraConfigAppend_SizeToFit:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️native_loadExtraConfigAppend_SizeToFit: Input config instance is null");
    }
    //Enable width-based adaptive height ads, only effective for some platforms (Pangle, JD, KuaiShou)
    [config setValue:@YES forKey:kATNativeAdSizeToFitKey];
}

#pragma mark - KuaiShou Native Ad Swipe and Click Controls
/// KuaiShou native ads swipe and click controls
/// Kuaishou native ads swipe and click controls
/// - Parameter config: Mutable dictionary object, values added by this method
+ (void)native_loadExtraConfigAppend_KuaiShou_SlideOrClickAble:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️native_loadExtraConfigAppend_KuaiShou_SlideOrClickAble: Input config instance is null");
    }
    //KuaiShou native ad swipe and click controls, import header file
    //#import <AnyThinkKuaiShouAdapter/ATKSExtraConfig.h>
//    
//    [config setValue:@{ // If not passed, empty dictionary defaults all to 1
//        ATKSNativeAdIsClickableKey : @1,         // NSNumber type 0:disabled 1:enabled
//        ATKSNativeAdIsSlidableKey : @1,          // NSNumber type 0:disabled 1:enabled
//        ATKSNativeAdContainrIsSlidableKey : @1,  // NSNumber type 0:disabled 1:enabled
//        ATKSNativeAdContainrIsClickableKey : @1} // NSNumber type 0:disabled 1:enabled
//        forKey:ATKSNativeInteractionConfigKey];
    
    //Example: Set ATKSNativeAdIsSlidableKey and ATKSNativeAdContainrIsSlidableKey to @1, ATKSNativeAdIsClickableKey and ATKSNativeAdContainrIsClickableKey to @0.
    //Above effect: Swiping on ad will scroll its container, and clicking ad view allows navigation.
}

#pragma mark - Splash Ad Custom Skip Button
/// Add custom splash skip button for some ad platforms
/// Append Splash ad show custom skip button config
/// - Parameter config: Mutable dictionary object, values added by this method
+ (void)splash_loadExtraConfigAppend_CustomSkipButton:(NSMutableDictionary *)config {
    if (!config) {
        ATDemoLog(@"⚠️splash_loadExtraConfigAppendPangle: Input config instance is null");
    }
    // Custom skip button, note: implement button text changes in ad countdown callback - (void)splashCountdownTime:(NSInteger)countdown forPlacementID:(NSString *)placementID extra:(NSDictionary *)extra
    UIButton * skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    skipButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80 - 20, 50, 80, 21);
    skipButton.layer.cornerRadius = 10.5;
    skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    // Most platforms no longer support custom skip buttons, currently supported: Pangle(TT), Direct, ADX, Native as Splash and Klevin, run to see actual effect
    // Custom skip button countdown duration in milliseconds
    [config setValue:@50000 forKey:kATSplashExtraCountdownKey];
    // Custom skip button
    [config setValue:skipButton forKey:kATSplashExtraCustomSkipButtonKey];
    // Custom skip button countdown callback interval
    [config setValue:@500 forKey:kATSplashExtraCountdownIntervalKey];
}

#pragma mark - Shared Placement
/// Set shared placement extra parameters - Splash ads
/// - Parameter extraDict: Extra parameters dictionary
+ (void)setSplashSharePlacementConfig:(NSMutableDictionary *)extraDict {
    
    if (![ATSDKGlobalSetting sharedManager].sharePlacementConfig) {
        [ATSDKGlobalSetting sharedManager].sharePlacementConfig = [[ATSharePlacementConfig alloc] init];
    }
    [ATSDKGlobalSetting sharedManager].sharePlacementConfig.splashLoadExtra = extraDict;
}

/// Set shared placement extra parameters - Interstitial ads
/// - Parameter extraDict: Extra parameters dictionary
+ (void)setInterstitialSharePlacementConfig:(NSMutableDictionary *)extraDict {
    
    if (![ATSDKGlobalSetting sharedManager].sharePlacementConfig) {
        [ATSDKGlobalSetting sharedManager].sharePlacementConfig = [[ATSharePlacementConfig alloc] init];
    }
    [ATSDKGlobalSetting sharedManager].sharePlacementConfig.interstitialLoadExtra = extraDict;
}

/// Set shared placement extra parameters - Rewarded video ads
/// - Parameter extraDict: Extra parameters dictionary
+ (void)setRewardedVideoSharePlacementConfig:(NSMutableDictionary *)extraDict {
    
    if (![ATSDKGlobalSetting sharedManager].sharePlacementConfig) {
        [ATSDKGlobalSetting sharedManager].sharePlacementConfig = [[ATSharePlacementConfig alloc] init];
    }
    [ATSDKGlobalSetting sharedManager].sharePlacementConfig.rewardedVideoLoadExtra = extraDict;
}

/// Set shared placement extra parameters - Banner ads
/// - Parameter extraDict: Extra parameters dictionary
+ (void)setBannerSharePlacementConfig:(NSMutableDictionary *)extraDict {
    
    if (![ATSDKGlobalSetting sharedManager].sharePlacementConfig) {
        [ATSDKGlobalSetting sharedManager].sharePlacementConfig = [[ATSharePlacementConfig alloc] init];
    }
    [ATSDKGlobalSetting sharedManager].sharePlacementConfig.bannerLoadExtra = extraDict;
}

/// Set shared placement extra parameters - Native ads
/// - Parameter extraDict: Extra parameters dictionary
+ (void)setNativeSharePlacementConfig:(NSMutableDictionary *)extraDict {
    
    if (![ATSDKGlobalSetting sharedManager].sharePlacementConfig) {
        [ATSDKGlobalSetting sharedManager].sharePlacementConfig = [[ATSharePlacementConfig alloc] init];
    }
    [ATSDKGlobalSetting sharedManager].sharePlacementConfig.nativeLoadExtra = extraDict;
}

@end



