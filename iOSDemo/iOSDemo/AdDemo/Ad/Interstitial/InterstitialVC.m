//
//  InterstitialVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/6.
//

#import "InterstitialVC.h"

#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>

#import "AdLoadConfigTool.h"
#import "AdLoadConfigTool.h"

//@import AnyThinkInterstitial;
 
@interface InterstitialVC () <ATInterstitialDelegate>

@property (nonatomic, assign) NSInteger retryAttempt; // Retry attempt counter

@end

@implementation InterstitialVC
 
//Placement ID
#define InterstitialPlacementID @"n67ece79734678"

//Scene ID, optional, can be generated in backend. Pass empty string if none
#define InterstitialSceneID @""

#pragma mark - Load Ad
/// Load ad button clicked
- (void)loadAd {
 
    [self showLog:kLocalizeStr(@"Load ad clicked")];
      
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    
    //Optional integration, set loading pass-through parameters
    [loadConfigDict setValue:@"media_val_InterstitialVC" forKey:kATAdLoadingExtraMediaExtraKey];
    
    //(Optional integration) If using Kuaishou platform, can add half-screen interstitial ad size configuration
    //[AdLoadConfigTool interstitial_loadExtraConfigAppend_KuaiShou:loadConfigDict];
    
    //(Optional integration) If shared placement is enabled, configure related settings
    //[AdLoadConfigTool setInterstitialSharePlacementConfig:loadConfigDict];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:InterstitialPlacementID extra:loadConfigDict delegate:self];
}
 
#pragma mark - Show Ad
/// Show ad button clicked
- (void)showAd {
    
    //Scene statistics function (optional integration)
    [[ATAdManager sharedManager] entryInterstitialScenarioWithPlacementID:InterstitialPlacementID scene:InterstitialSceneID];
    
//    //Query available ad cache for display (optional integration)
//    NSArray <NSDictionary *> * adCaches = [[ATAdManager sharedManager] getInterstitialValidAdsForPlacementID:InterstitialPlacementID];
//    ATDemoLog(@"getValidAds : %@",adCaches);
//
//    //Query ad loading status (optional integration)
//    ATCheckLoadModel * status = [[ATAdManager sharedManager] checkInterstitialLoadStatusForPlacementID:InterstitialPlacementID];
//    ATDemoLog(@"checkLoadStatus : %d",status.isLoading);
    
    //Check if ready
    if (![[ATAdManager sharedManager] interstitialReadyForPlacementID:InterstitialPlacementID]) {
        [self loadAd];
        return;
    }
    
    //Display configuration, Scene passes backend scene ID, pass empty string if none, showCustomExt parameter can pass custom parameter string
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:InterstitialSceneID showCustomExt:@"testShowCustomExt"];
 
    //Show ad
    //For fullscreen interstitial, inViewController can pass root controller like tabbarController or navigationController to let ad cover tabbar or navigationBar
    [[ATAdManager sharedManager] showInterstitialWithPlacementID:InterstitialPlacementID
                                                      showConfig:config
                                                inViewController:self
                                                        delegate:self
                                              nativeMixViewBlock:nil];
}

#pragma mark - ATAdLoadingDelegate
/// Placement loading completed
/// - Parameter placementID: Placement ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] interstitialReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ interstitial ready:%@", placementID,isReady ? @"YES":@"NO"]];
    
    // Reset retry attempt
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

#pragma mark - ATInterstitialDelegate
/// Ad displayed
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)interstitialDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidShowForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialDidShowForPlacementID:%@", placementID]];
    
}

/// Ad display failed
/// - Parameters:
///   - placementID: Placement ID
///   - error: Error information
///   - extra: Extra information dictionary
- (void)interstitialFailedToShowForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialFailedToShowForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialFailedToShowForPlacementID:%@ error:%@", placementID, error]];
    
}

/// Video playback failed
/// - Parameters:
///   - placementID: Placement ID
///   - error: Error information
///   - extra: Extra information dictionary
- (void)interstitialDidFailToPlayVideoForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidFailToPlayVideoForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialDidFailToPlayVideoForPlacementID:%@ errorCode:%ld", placementID, error.code]];
    
    // Preload next ad
    [self loadAd];
}

/// Video started playing
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)interstitialDidStartPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidStartPlayingVideoForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialDidStartPlayingVideoForPlacementID:%@", placementID]];
    
}

/// Video finished playing
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)interstitialDidEndPlayingVideoForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidEndPlayingVideoForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialDidEndPlayingVideoForPlacementID:%@", placementID]];
    
}

/// Ad closed
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)interstitialDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidCloseForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialDidCloseForPlacementID:%@", placementID]];
    
    // Preload next ad
    [self loadAd];
}

/// Ad clicked (redirect)
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)interstitialDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"interstitialDidClickForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"interstitialDidClickForPlacementID:%@", placementID]];
}
  
@end
