//
//  AdSDKManager.m
//  iOSDemo
//
//  Created by ltz on 2025/3/26.
//

#import "AdSDKManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "LaunchLoadingView.h"
#import "AdLoadConfigTool.h"
#import "SDKGlobalConfigTool.h"
#import "TestModeTool.h"
 
static AdSDKManager *sharedManager = nil;

@interface AdSDKManager() <ATAdLoadingDelegate, ATSplashDelegate>

/// Loading page, use your own loading image
@property (strong, nonatomic) LaunchLoadingView * launchLoadingView;

@end

@implementation AdSDKManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AdSDKManager alloc] init];
    });
    return sharedManager;
}

#pragma mark - public func
/// GDPR/UMP flow initialization
- (void)initSDK_EU:(AdManagerInitFinishBlock)block {
    [[ATAPI sharedInstance] showGDPRConsentDialogInViewController:[UIApplication sharedApplication].keyWindow.rootViewController dismissalCallback:^{
        // Here is an example of requesting ATT permission when the user consents or data consent is unknown and it is not the first launch. You can adjust it according to the actual situation of the app.
        if (([ATAPI sharedInstance].dataConsentSet == ATDataConsentSetUnknown && ([[NSUserDefaults standardUserDefaults] boolForKey:@"GDPR_First_Flag"] == YES))
            
            || [ATAPI sharedInstance].dataConsentSet == ATDataConsentSetPersonalized) {
            
            if (@available(iOS 14, *)) {
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                    
                }];
            }
        }
        
        //v6.4.93 and below [ATAPI sharedInstance].dataConsentSet cant get result at App first launch.
        // if you want to get UMP consent result , please follow this example:
//        NSString *purposeConsents = [[NSUserDefaults standardUserDefaults] stringForKey:@"IABTCF_PurposeConsents"];
//        NSLog(@"purposeConsents:%@", purposeConsents);
//        if (![purposeConsents containsString:@"1"]) {
//           //not allow
//        } else {
//           //allow
//        }
        
        [self initSDK];
        if (block) {
            block();
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GDPR_First_Flag"];
    }];
}
 
/// Initialize SDK, this method will not initialize the ad platform SDK at the same time
- (void)initSDK {
    
    // Log switch
    [ATAPI setLogEnabled:YES];
    // Integration check
    [ATAPI integrationChecking];
    
    // Optional integration, set splash ad preset strategy
    // [[ATSDKGlobalSetting sharedManager] setPresetPlacementConfigPathBundle:[NSBundle mainBundle]];
    
    // SDK custom parameter configuration, single item
    [SDKGlobalConfigTool setCustomChannel:@"channel xxx"];
    
    // Optional integration, if Pangle ad platform is used, set overseas privacy items
//    [SDKGlobalConfigTool pangleCOPPACCPASetting];

    // SDK custom parameter configuration, multiple items together, check other configurations in SDKGlobalConfigTool class
//    [SDKGlobalConfigTool setCustomData:@{kATCustomDataUserIDKey:@"test_custom_user_id",
//                                         kATCustomDataChannelKey:@"custom_data_channel",
//                                         kATCustomDataSubchannelKey:@"custom_data_subchannel",
//                                         kATCustomDataAgeKey:@18,
//                                         kATCustomDataGenderKey:@1,//The value filled in when grouping traffic needs to be consistent with the value passed in
//                                         kATCustomDataNumberOfIAPKey:@19,
//                                         kATCustomDataIAPAmountKey:@20.0f,
//                                         kATCustomDataIAPCurrencyKey:@"usd",}];
 
    // Debug mode related tool TestModeTool
//    [TestModeTool showDebugUI:]
    
    // Initialize SDK
    NSError * initError = nil;
    [[ATAPI sharedInstance] startWithAppID:kTopOnAppID appKey:kTopOnAppKey error:&initError];
    if (initError) {
        //Initialize failed
        NSLog(@"init failed : %@",initError);
    }
}
 
#pragma mark - Splash Ad Related

- (void)startSplashAd {
    // Splash ad shows launch image
    [self addLaunchLoadingView];
    
    [self loadSplashWithPlacementID:FirstAppOpen_PlacementID];
}

- (void)addLaunchLoadingView {
    // Add launch page
    // Add loading page, need to remove in delegate when ad display is finished
    self.launchLoadingView = [LaunchLoadingView new];
    [self.launchLoadingView show];
    // Launch demo example uses timer
    [self.launchLoadingView startTimer];
}

/// Load splash ad
- (void)loadSplashWithPlacementID:(NSString *)placementID {
    NSMutableDictionary *loadConfigDict = [NSMutableDictionary dictionary];
    
    // Splash timeout duration
    [loadConfigDict setValue:@(FirstAppOpen_Timeout) forKey:kATSplashExtraTolerateTimeoutKey];
    // Custom load parameters
    [loadConfigDict setValue:@"media_val_SplashVC" forKey:kATAdLoadingExtraMediaExtraKey];
    
    // Optional integration, if Pangle ad platform is used, the following configuration can be added
    //[AdLoadConfigTool splash_loadExtraConfigAppend_Pangle:loadConfigDict];
    
    // If you choose to use Tencent(GDT), it is recommended to integrate
    [AdLoadConfigTool splash_loadExtraConfigAppend_Tencent:loadConfigDict];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:placementID
                                                 extra:loadConfigDict
                                              delegate:self
                                         containerView:[self footLogoView]];
}

/// Show splash ad
- (void)showSplashWithPlacementID:(NSString *)placementID {
    // Check if ready
    if (![[ATAdManager sharedManager] splashReadyForPlacementID:placementID]) {
        return;
    }
    
    // Scenario statistics function, optional integration
    [[ATAdManager sharedManager] entrySplashScenarioWithPlacementID:placementID scene:@""];
     
    // Show configuration, Scene passes in the scenario ID from the dashboard, pass empty string if not available, showCustomExt parameter can pass custom parameter string
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:placementID showCustomExt:@"testShowCustomExt"];
    
    // Splash related parameter configuration
    NSMutableDictionary *configDict = [NSMutableDictionary dictionary];
    
    // Optional integration, custom skip button. Most platforms no longer support custom skip buttons. Currently, platforms that support changing custom skip buttons include Pangle (TT), Direct Delivery, ADX, Native as Splash and Youkeying. Specifics need to be run to see actual effects.
//    [AdLoadConfigTool splash_loadExtraConfigAppend_CustomSkipButton:configDict];
    
    // Show ad
    [[ATAdManager sharedManager] showSplashWithPlacementID:placementID config:config window:[UIApplication sharedApplication].keyWindow inViewController:[UIApplication sharedApplication].keyWindow.rootViewController extra:configDict delegate:self];
}

#pragma mark - Private Methods

/// Splash ad load callback judgment
- (void)showSplashOrEnterHomePageWithPlacementID:(NSString *)placementID loadResult:(BOOL)loadResult {
    if (loadResult) {
        [self showSplashWithPlacementID:placementID];
    } else {
        [self.launchLoadingView dismiss];
    }
}

#pragma mark - AppOpen FooterView
/// Optional integration of splash bottom LogoView, only supported by some ad platforms
- (UIView *)footLogoView {
    
    // Width is screen width, height <= 25% of screen height (determined by ad platform requirements)
    UIView * footerCtrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kOrientationScreenWidth, 120)];
    footerCtrView.backgroundColor = UIColor.whiteColor;
    
    // Add image
    UIImageView * logoImageView = [UIImageView new];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    logoImageView.contentMode = UIViewContentModeCenter;
    logoImageView.frame = footerCtrView.frame;
    [footerCtrView addSubview:logoImageView];
    
    // Add click event
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerImgClick:)];
    logoImageView.userInteractionEnabled = YES;
    [logoImageView addGestureRecognizer:tap];
     
    return footerCtrView;
}

/// Footer click event
- (void)footerImgClick:(UITapGestureRecognizer *)tap {
    ATDemoLog(@"footer click !!");
}

#pragma mark - Ad Loading Delegate
/// Ad placement load failed
/// - Parameters:
///   - placementID: Ad placement ID
///   - error: Error information
- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    // Handle splash callback
    [self showSplashOrEnterHomePageWithPlacementID:placementID loadResult:NO];
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    // All Ads load finished, please use didFinishLoadingSplashADWithPlacementID:isTimeout first
}

#pragma mark - Splash Ad Events
/// Splash load success, need to determine if timed out
/// - Parameters:
///   - placementID: Ad placement ID
///   - isTimeout: Whether timed out
- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout {
    // Handle splash callback
    [self showSplashOrEnterHomePageWithPlacementID:placementID loadResult:!isTimeout];
}

/// Splash ad timeout
/// - Parameter placementID: Ad placement ID
- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID {
    // Handle splash callback
    [self showSplashOrEnterHomePageWithPlacementID:placementID loadResult:NO];
}

/// Splash ad closed
/// - Parameters:
///   - placementID: Ad placement ID
///   - extra: Extra info
- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    // Handle splash callback
    [self showSplashOrEnterHomePageWithPlacementID:placementID loadResult:NO];
}

/// Splash ad show failed
/// - Parameters:
///   - placementID: Ad placement ID
///   - error: Error information
///   - extra: Extra info
- (void)splashDidShowFailedForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    // Handle splash callback
    [self showSplashOrEnterHomePageWithPlacementID:placementID loadResult:NO];
}
 
/// Splash ad user clicked
/// - Parameters:
///   - placementID: Ad placement ID
///   - extra: Extra info
- (void)splashDidClickForPlacementID:(nonnull NSString *)placementID extra:(nonnull NSDictionary *)extra {
    
}
 
/// Splash ad impression
/// - Parameters:
///   - placementID: Ad placement ID
///   - extra: Extra info
- (void)splashDidShowForPlacementID:(nonnull NSString *)placementID extra:(nonnull NSDictionary *)extra {
    [self.launchLoadingView dismiss];
}


#pragma mark - life
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
