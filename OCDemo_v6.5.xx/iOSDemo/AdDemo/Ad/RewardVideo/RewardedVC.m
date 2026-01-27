//
//  RewardedVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/7.
//

#import "RewardedVC.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import "AdLoadConfigTool.h"

@interface RewardedVC () <ATRewardedVideoDelegate>

@property (nonatomic, assign) NSInteger retryAttempt;

@end

@implementation RewardedVC

//Placement ID
#define RewardedPlacementID @"n67eced86831a9"

//Scene ID, optional, can be generated in backend. Pass empty string if none
#define RewardedSceneID @""

#pragma mark - Load Ad
/// Load ad button clicked
- (void)loadAd {
 
    [self showLog:kLocalizeStr(@"Load ad clicked")];
      
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    // Optional integration, the following key parameters are applicable to server-side reward verification of ad platforms and will be passed through
    [loadConfigDict setValue:@"media_val_RewardedVC" forKey:kATAdLoadingExtraMediaExtraKey];
    [loadConfigDict setValue:@"rv_test_user_id" forKey:kATAdLoadingExtraUserIDKey];
    [loadConfigDict setValue:@"reward_Name" forKey:kATAdLoadingExtraRewardNameKey];
    [loadConfigDict setValue:@3 forKey:kATAdLoadingExtraRewardAmountKey];
 
    //(Optional integration) If using Klevin ad platform, can add the following configuration
    //[AdLoadConfigTool rewarded_loadExtraConfigAppend_Klevin:loadConfigDict];
    
    //(Optional integration) If shared placement is enabled, configure related settings
    //[AdLoadConfigTool setInterstitialSharePlacementConfig:loadConfigDict];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:RewardedPlacementID extra:loadConfigDict delegate:self];
}
 
#pragma mark - Show Ad
/// Show ad button clicked
- (void)showAd {
    
    //Scene statistics function (optional integration)
    [[ATAdManager sharedManager] entryRewardedVideoScenarioWithPlacementID:RewardedPlacementID scene:RewardedSceneID];
    
//    //Query available ad cache for display (optional integration)
//    NSArray <NSDictionary *> * adCaches = [[ATAdManager sharedManager] getRewardedVideoValidAdsForPlacementID:RewardedPlacementID];
//    ATDemoLog(@"getValidAds : %@",adCaches);
//
//    //Query ad loading status (optional integration)
//    ATCheckLoadModel * status = [[ATAdManager sharedManager] checkRewardedVideoLoadStatusForPlacementID:RewardedPlacementID];
//    ATDemoLog(@"checkLoadStatus : %d",status.isLoading);
//
    //Check if ready
    if (![[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:RewardedPlacementID]) {
        [self loadAd];
        return;
    }
    
    //Display configuration, Scene passes backend scene ID, pass empty string if none, showCustomExt parameter can pass custom parameter string
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:RewardedSceneID showCustomExt:@"testShowCustomExt"];
 
    //Show ad
    [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:RewardedPlacementID config:config inViewController:self delegate:self];
}

#pragma mark - ATAdLoadingDelegate
/// Placement loading completed
/// - Parameter placementID: Placement ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ Rewarded ready:%@", placementID,isReady ? @"YES":@"NO"]];
    
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

#pragma mark - ATRewardedVideoDelegate
/// Reward success
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidRewardSuccessForPlacemenID:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidRewardSuccess:%@", placementID]];
    
}

/// Rewarded video started playing
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidStartPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidStartPlaying:%@", placementID]];
    
}
 
/// Rewarded video finished playing
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)rewardedVideoDidEndPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidEndPlaying:%@", placementID]];
    
}

/// Rewarded video playback failed
/// - Parameters:
///   - placementID: Placement ID
///   - error: Error information
///   - extra: Extra information dictionary
- (void)rewardedVideoDidFailToPlayForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidFailToPlayForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidFailToPlay:%@ errorCode:%ld", placementID, (long)error.code]];
    
    // Preload
    [self loadAd];
}

/// Rewarded ad closed
/// - Parameters:
///   - placementID: Placement ID
///   - rewarded: Whether reward was successful, YES means reward success callback was triggered
///   - extra: Extra information dictionary
- (void)rewardedVideoDidCloseForPlacementID:(NSString *)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidCloseForPlacementID:%@, rewarded:%@ extra:%@", placementID, rewarded ? @"yes" : @"no", extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidClose:%@, rewarded:%@", placementID, rewarded ? @"yes" : @"no"]];
    
    // Preload
    [self loadAd];
}
 
/// Rewarded ad clicked
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)rewardedVideoDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoDidClickForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidClick:%@", placementID]];
    
}

/// Rewarded ad opened or jumped to deep link page
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information
///   - success: Whether successful
- (void)rewardedVideoDidDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    ATDemoLog(@"rewardedVideoDidDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidDeepLinkOrJump:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
    
}

#pragma mark - Rewarded video again delegate
//Supports rewarded video "watch again" capability (abbreviated as reward again). After enabling this feature, the aggregation dimension will automatically cache a rewarded video ad, and after the first ad display and receiving the reward callback, it will render a retention popup to guide users to "watch again for more rewards". After the user clicks, the cached ad will automatically play, which helps improve user ad value and active duration.
//If you have enabled the "watch again" feature in the backend configuration, please implement the relevant callbacks. (CSJ platform supported)

/// Rewarded video again reward success
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)rewardedVideoAgainDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoAgainDidRewardSuccessForPlacemenID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidRewardSuccess:%@", placementID]];
}

/// Rewarded video again started playing
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)rewardedVideoAgainDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoAgainDidStartPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidStartPlaying:%@", placementID]];
}

/// Rewarded video again finished playing
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)rewardedVideoAgainDidEndPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    ATDemoLog(@"rewardedVideoAgainDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidEndPlaying:%@", placementID]];
}

/// Rewarded video again playback failed
/// - Parameters:
///   - placementID: Placement ID
///   - error: Error information
///   - extra: Extra information dictionary
- (void)rewardedVideoAgainDidFailToPlayForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoAgainDidFailToPlayForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidFailToPlay:%@ errorCode:%ld", placementID, (long)error.code]];
}

/// Rewarded video again clicked
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)rewardedVideoAgainDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"rewardedVideoAgainDidClickForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidClick:%@", placementID]];
}

@end
