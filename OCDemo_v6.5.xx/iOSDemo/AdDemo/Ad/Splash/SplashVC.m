//
//  SplashVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/18.
//

#import "SplashVC.h"

#import <AnyThinkSDK/AnyThinkSDK.h>

#import "AdLoadConfigTool.h"

#import "AppDelegate.h"

#import "LaunchLoadingView.h"

@interface SplashVC () <ATSplashDelegate>
 
@end
 
@implementation SplashVC

// Placement ID
#define SplashPlacementID @"n67eb688a3eeea"

// Scene ID, optional, can be generated in the dashboard. If not available, pass an empty string
#define SplashSceneID @""
 
- (void)viewDidLoad {
    [super viewDidLoad];
 
    // Add loading view, which needs to be removed in the delegate after the ad finishes displaying
    [[LaunchLoadingView sharedInstance] show];
     
    // To improve splash ad efficiency, it is recommended to initiate the ad loading request before entering the current page, such as after SDK initialization. For demonstration purposes, this demo requests the ad when viewDidLoad is called
    [self loadAd];
}

/// Enter home page
- (void)enterHomeVC {
    [[LaunchLoadingView sharedInstance] dismiss];
}

#pragma mark - Load Ad
/// Load ad
- (void)loadAd {
    
    NSMutableDictionary *loadConfigDict = [NSMutableDictionary dictionary];
    
    // Splash ad timeout duration
    [loadConfigDict setValue:@(5) forKey:kATSplashExtraTolerateTimeoutKey];
    // Custom load parameter
    [loadConfigDict setValue:@"media_val_SplashVC" forKey:kATAdLoadingExtraMediaExtraKey];
    
    // Optional integration, if using Pangle ad network, add the following configuration
    //[AdLoadConfigTool splash_loadExtraConfigAppend_Pangle:loadConfigDict];
    
    // If using Tencent GDT (YouLiangHui), recommended to integrate
    //[AdLoadConfigTool splash_loadExtraConfigAppend_Tencent:loadConfigDict];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:SplashPlacementID
                                                 extra:loadConfigDict
                                              delegate:self
                                         containerView:[self footLogoView]];
}
 
/// Optional integration of splash bottom logo view
- (UIView *)footLogoView {
    
    // Width should be screen width, height <= 25% of screen height (depending on ad network requirements)
    UIView * footerCtrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kOrientationScreenWidth, 120)];
    footerCtrView.backgroundColor = UIColor.whiteColor;
    
    // Add image
    UIImageView * logoImageView = [UIImageView new];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    logoImageView.contentMode = UIViewContentModeCenter;
    logoImageView.frame = footerCtrView.frame;
    [footerCtrView addSubview:logoImageView];
    
    // Add tap gesture
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerImgClick:)];
    logoImageView.userInteractionEnabled = YES;
    [logoImageView addGestureRecognizer:tap];
     
    return footerCtrView;
}
 
/// Footer click event
- (void)footerImgClick:(UITapGestureRecognizer *)tap {
    ATDemoLog(@"footer click !!");
}
 
#pragma mark - Show Ad
- (void)showSplash {
    
    // Scene tracking feature, optional integration
    [[ATAdManager sharedManager] entrySplashScenarioWithPlacementID:SplashPlacementID scene:SplashSceneID];
    
//    // Query available ad cache for display (optional integration)
//    NSArray <NSDictionary *> * adCaches = [[ATAdManager sharedManager] getSplashValidAdsForPlacementID:SplashPlacementID];
//    ATDemoLog(@"getValidAds : %@",adCaches);
//
//    // Query ad loading status (optional integration)
//    ATCheckLoadModel * status = [[ATAdManager sharedManager] checkSplashLoadStatusForPlacementID:SplashPlacementID];
//    ATDemoLog(@"checkLoadStatus : %d",status.isLoading);
    
    // Check if ad is ready
    if (![[ATAdManager sharedManager] splashReadyForPlacementID:SplashPlacementID]) {
        [self loadAd];
        return;
    }
    
    // Show configuration. Scene parameter should be the scene ID from the dashboard, pass empty string if not available. showCustomExt parameter can be used to pass custom parameter string
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:SplashSceneID showCustomExt:@"testShowCustomExt"];
    
    // Splash ad related parameter configuration
    NSMutableDictionary *configDict = [NSMutableDictionary dictionary];
    
    // Optional integration, custom skip button. Most ad networks no longer support custom skip buttons. Currently, custom skip buttons are supported by Pangle (TT), Direct Deal, ADX, Native as Splash, and Youkeyingmob. Run the app to see the actual effect
//    [AdLoadConfigTool splash_loadExtraConfigAppend_CustomSkipButton:configDict];
    
    // Show ad, display in the app's key window
    [[ATAdManager sharedManager] showSplashWithPlacementID:SplashPlacementID config:config window:[UIApplication sharedApplication].keyWindow inViewController:self.tabBarController extra:configDict delegate:self];
}
  

/// Splash ad loading finished
/// - Parameters:
///   - placementID: Placement ID
///   - isTimeout: Whether timeout occurred
- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout {
    ATDemoLog(@"开屏加载成功:%@----是否超时:%d",placementID,isTimeout);
    if (!isTimeout) {
        // Not timeout, show splash ad
        [self showSplash];
    }else {
        // Loading succeeded but timed out
        [self enterHomeVC];
    }
}
 
/// Placement loading failed
/// - Parameters:
///   - placementID: Placement ID
///   - error: Error information
- (void)didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    ATDemoLog(@"didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
    
    // All ad sources failed to load, enter home page
    [self enterHomeVC];
}
 
/// Splash ad loading timeout
/// - Parameter placementID: Placement ID
- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID {
    ATDemoLog(@"didTimeoutLoadingSplashADWithPlacementID:%@", placementID);
    // Timeout occurred, enter home page after home page loading is complete
    [self showLog:[NSString stringWithFormat:@"开屏超时了"]];
    // Enter home page
    [self enterHomeVC];
}

/// Receive impression revenue
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)didRevenueForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didRevenueForPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didRevenueForPlacementID:%@", placementID]];
}

/// Callback when the successful loading of the ad
/// Loading succeeded and loading process completed
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    ATDemoLog(@"didFinishLoadingADWithPlacementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@", placementID]];
}

/// Splash ad did show
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information
- (void)splashDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDidShowForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidShowForPlacementID:%@ ",placementID]];
    
    // Can hide after showing the ad to avoid blocking
    [[LaunchLoadingView sharedInstance] dismiss];
}

/// Splash ad did close
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information
- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDidCloseForPlacementID:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"splashDidCloseForPlacementID:%@ ",placementID]];
    
    // Enter home page
    [self enterHomeVC];
    
    // Pre-load for hot launch (optional)
    // [self loadAd];
}

/// Splash ad did click
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information
- (void)splashDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDidClickForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidClickForPlacementID:%@",placementID]];
}

/// Splash ad show failed
/// - Parameters:
///   - placementID: Placement ID
///   - error: Error information
///   - extra: Extra information
- (void)splashDidShowFailedForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDidShowFailedForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidShowFailedForPlacementID:%@ error:%@ ",placementID,error]];
    
    // Failed to show, also enter home page, be careful to avoid duplicate navigation
    [self enterHomeVC];
}

/// Splash ad deeplink or jump opened
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information
///   - success: Whether successful
- (void)splashDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    ATDemoLog(@"splashDeepLinkOrJumpForPlacementID:placementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"splashDeepLinkOrJumpForPlacementID:placementID:%@ ", placementID]];
}
  
/// Splash ad detail page did close
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information
- (void)splashDetailDidClosedForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashDetailDidClosedForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDetailDidClosedForPlacementID:%@ ",placementID]];
    
    // Get close reason here: dismiss_type
//    typedef NS_OPTIONS(NSInteger, ATAdCloseType) {
//        ATAdCloseUnknow = 1,            // ad close type unknow
//        ATAdCloseSkip = 2,              // ad skip to close
//        ATAdCloseCountdown = 3,         // ad countdown to close
//        ATAdCloseClickcontent = 4,      // ad clickcontent to close
//        ATAdCloseShowfail = 99          // ad showfail to close
//    };
//    ATAdCloseType closeType = [extra[kATADDelegateExtraDismissTypeKey] integerValue];
    
    // Pre-load for hot launch (optional)
    // [self loadAd];
}

/// Splash ad countdown timer
/// - Parameters:
///   - countdown: Remaining seconds
///   - placementID: Placement ID
///   - extra: Extra information
- (void)splashCountdownTime:(NSInteger)countdown forPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashCountdownTime:%ld forPlacementID:%@",countdown,placementID);
    [self showLog:[NSString stringWithFormat:@"splashCountdownTime:%ld forPlacementID:%@",countdown,placementID]];
}

/// Splash ad zoom-out view did click, only supported by Pangle, Tencent GDT, and V+
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information
- (void)splashZoomOutViewDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashZoomOutViewDidClickForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashZoomOutViewDidClickForPlacementID:%@ ",placementID]];
}

/// Splash ad zoom-out view did close, only supported by Pangle, Tencent GDT, and V+
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information
- (void)splashZoomOutViewDidCloseForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"splashZoomOutViewDidCloseForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashZoomOutViewDidCloseForPlacementID:%@ ",placementID]];
}
  
@end
