//
//  BannerVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/11.
//

#import "BannerVC.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import "AdLoadConfigTool.h"

@interface BannerVC () <ATBannerDelegate>

@property (nonatomic, strong) ATBannerView *bannerView;
@property (nonatomic, assign) BOOL hasLoaded; // Ad loading status flag

@end

@implementation BannerVC

//Placement ID
#define BannerPlacementID @"n67ecedf7904d9"

//Scene ID, optional, can be generated in dashboard. Pass empty string if none
#define BannerSceneID @""

//Note: banner size must match the ratio configured in dashboard
#define BannerSize CGSizeMake(320, 50)

#pragma mark - Load Ad
/// Load ad
- (void)loadAd {
 
    [self showLog:kLocalizeStr(@"Clicked load ad")];
      
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    
    /*
     注意不同平台的横幅广告有一定限制，例如配置的横幅广告640*100，为了能填充完屏幕宽，计算高度H = (屏幕宽 *100)/640；那么在load的extra的size为（屏幕宽：H）。
     
     Note that banner ads on different platforms have certain restrictions. For example, the configured banner AD is 640*100. In order to fill the screen width, the height H = (screen width *100)/640 is calculated. Then the extra size of the load is (screen width: H).
     */
    [loadConfigDict setValue:[NSValue valueWithCGSize:BannerSize] forKey:kATAdLoadingExtraBannerAdSizeKey];
    
    //Set custom parameters
    [loadConfigDict setValue:@"media_val_BannerVC" forKey:kATAdLoadingExtraMediaExtraKey];
     
    //Optional integration, add following config if using Admob ad platform
    //[AdLoadConfigTool banner_loadExtraConfigAppendAdmob:loadConfigDict];
    
    //Start loading
    [[ATAdManager sharedManager] loadADWithPlacementID:BannerPlacementID extra:loadConfigDict delegate:self];
}
 
#pragma mark - Show Ad
/// Show ad
- (void)showAd {
    
    //Scene statistics feature, optional integration
    [[ATAdManager sharedManager] entryBannerScenarioWithPlacementID:BannerPlacementID scene:BannerSceneID];
    
//    //Query available ad cache for display (optional integration)
//    NSArray <NSDictionary *> * adCaches = [[ATAdManager sharedManager] getBannerValidAdsForPlacementID:BannerPlacementID];
//    ATDemoLog(@"getValidAds : %@",adCaches);
//
//    //Query ad loading status (optional integration)
//    ATCheckLoadModel * status = [[ATAdManager sharedManager] checkBannerLoadStatusForPlacementID:BannerPlacementID];
//    ATDemoLog(@"checkLoadStatus : %d",status.isLoading);
    
    //Check if ready
    if (![[ATAdManager sharedManager] bannerAdReadyForPlacementID:BannerPlacementID]) {
        [self loadAd];
        return;
    }
    
    //Show config, Scene passes dashboard scene ID, pass empty string if none, showCustomExt parameter can pass custom parameter string
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:BannerSceneID showCustomExt:@"testShowCustomExt"];
 
    //Show ad
    ATBannerView *bannerView = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:BannerPlacementID config:config];
    if (bannerView != nil) {
        //Assignment
        bannerView.delegate = self;
        bannerView.presentingViewController = self;
        bannerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:bannerView];
        self.bannerView = bannerView;
        
        //Layout
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            make.height.equalTo(@(BannerSize.height));
            make.width.equalTo(@(BannerSize.width));
            make.top.equalTo(self.textView.mas_bottom).offset(5);
        }];
    }
}
 
#pragma mark - Destroy Ad
- (void)removeAd {
    [self.bannerView destroyBanner];
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
    self.hasLoaded = NO;
}

#pragma mark - Demo Button Actions
/// Remove banner ad through demo remove button click
- (void)removeAdButtonClickAction {
    [self removeAd];
}
 
//Temporarily hide, auto-loading will stop after hiding
- (void)hiddenAdButtonClickAction {
    self.bannerView.hidden = YES;
}
 
//Re-show after hiding
- (void)reshowAd {
    self.bannerView.hidden = NO;
}
 
#pragma mark - ATAdLoadingDelegate
/// Placement loading completed
/// - Parameter placementID: Placement ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] bannerAdReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ Banner ready:%@", placementID,isReady ? @"YES":@"NO"]];
    
    self.hasLoaded = YES;
}
 
/// Placement loading failed
/// - Parameters:
///   - placementID: Placement ID
///   - error: Error information
- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    ATDemoLog(@"didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
    
    self.hasLoaded = NO;
}

/// Received display revenue
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)didRevenueForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didRevenueForPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didRevenueForPlacementID:%@", placementID]];
}

#pragma mark - ATBannerDelegate

/// Close button clicked (when user clicks close button on banner)
/// - Parameters:
///   - bannerView: Banner ad view object
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)bannerView:(ATBannerView *)bannerView didTapCloseButtonWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didTapCloseButtonWithPlacementID:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didTapCloseButtonWithPlacementID:%@", placementID]];

    // Received close button click callback, remove bannerView
    [self removeAd];
}

/// Banner ad displayed
/// - Parameters:
///   - bannerView: Banner ad view object
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didShowAdWithPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didShowAdWithPlacementID:%@", placementID]];
     
}

/// Banner ad clicked
/// - Parameters:
///   - bannerView: Banner ad view object
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    ATDemoLog(@"didClickWithPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didClickWithPlacementID:%@", placementID]];
}

/// Banner ad auto-refreshed
/// - Parameters:
///   - bannerView: Banner ad view object
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)bannerView:(ATBannerView *)bannerView didAutoRefreshWithPlacement:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didAutoRefreshWithPlacement:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"bannerView:didAutoRefreshWithPlacement:%@", placementID]];
}

/// Banner ad auto-refresh failed
/// - Parameters:
///   - bannerView: Banner ad view object
///   - placementID: Placement ID
///   - error: Error information
- (void)bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {
    ATDemoLog(@"failedToAutoRefreshWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"bannerView:failedToAutoRefreshWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
}
 
/// Banner ad opened or jumped to deep link page
/// - Parameters:
///   - bannerView: Banner ad view object
///   - placementID: Placement ID
///   - extra: Extra information
///   - success: Whether successful
- (void)bannerView:(ATBannerView *)bannerView didDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    ATDemoLog(@"didDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"didDeepLinkOrJumpForPlacementID:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
}
 
@end
