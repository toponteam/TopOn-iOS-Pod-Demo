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

/// Loading view with custom loading image
@property (strong, nonatomic) LaunchLoadingView * launchLoadingView;
/// Store splash ad callback blocks
@property (strong, nonatomic) NSMutableDictionary<NSString *, AdManagerSplashAdLoadBlock> *splashAdCallbacks;

@end

@implementation AdSDKManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AdSDKManager alloc] init];
        sharedManager.splashAdCallbacks = [NSMutableDictionary dictionary];
    });
    return sharedManager;
}

#pragma mark - public func
/// GDPR/UMP process initialization
- (void)initSDK_EU:(AdManagerInitFinishBlock)block {
    [[ATAPI sharedInstance] showGDPRConsentDialogInViewController:[UIApplication sharedApplication].keyWindow.rootViewController dismissalCallback:^{
        // Example of requesting ATT permission on non-first launch when user consents or data consent is unknown. Adjust according to your app's actual situation.
        if (([ATAPI sharedInstance].dataConsentSet == ATDataConsentSetUnknown && ([[NSUserDefaults standardUserDefaults] boolForKey:@"GDPR_First_Flag"] == YES))
            
            || [ATAPI sharedInstance].dataConsentSet == ATDataConsentSetPersonalized) {
            
            if (@available(iOS 14, *)) {
                [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                    
                }];
            }
        }
        
        [self initSDK];
        if (block) {
            block();
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GDPR_First_Flag"];
    }];
}
 
/// Initialize SDK, this method will not initialize ad platform SDKs simultaneously
- (void)initSDK {
    
    // Log switch
    [ATAPI setLogEnabled:YES];
    // Integration check
    [ATAPI integrationChecking];
    
    // Optional integration, set splash ad preset strategy
    // [[ATSDKGlobalSetting sharedManager] setPresetPlacementConfigPathBundle:[NSBundle mainBundle]];
    
    //SDK custom parameter configuration, single item
    [SDKGlobalConfigTool setCustomChannel:@"渠道xxx"];
    
    //Optional integration, if using Pangle ad platform, set overseas privacy settings
//    [SDKGlobalConfigTool pangleCOPPACCPASetting];

    //SDK custom parameter configuration, multiple items together, see other configurations in SDKGlobalConfigTool class
//    [SDKGlobalConfigTool setCustomData:@{kATCustomDataUserIDKey:@"test_custom_user_id",
//                                         kATCustomDataChannelKey:@"custom_data_channel",
//                                         kATCustomDataSubchannelKey:@"custom_data_subchannel",
//                                         kATCustomDataAgeKey:@18,
//                                         kATCustomDataGenderKey:@1,//Value filled during traffic grouping, must match the passed value
//                                         kATCustomDataNumberOfIAPKey:@19,
//                                         kATCustomDataIAPAmountKey:@20.0f,
//                                         kATCustomDataIAPCurrencyKey:@"usd",}];
 
    //Debug mode related tools TestModeTool
//    [TestModeTool showDebugUI:]
    
    //Initialize SDK
    [[ATAPI sharedInstance] startWithAppID:kTopOnAppID appKey:kTopOnAppKey error:nil];
}
 
#pragma mark - Splash Ad Related
- (void)addLaunchLoadingView {
    //Add launch screen
    //Add loading view, remove in delegate when ad display is complete
    self.launchLoadingView = [LaunchLoadingView new];
    [self.launchLoadingView show];
}

/// Load splash ad
- (void)loadSplashAdWithPlacementID:(NSString *)placementID result:(AdManagerSplashAdLoadBlock)block {
    
    [self.launchLoadingView startTimer];
    
    // Save callback block by placementID
    if (placementID && block) {
        self.splashAdCallbacks[placementID] = block;
    }
     
    NSMutableDictionary *loadConfigDict = [NSMutableDictionary dictionary];
    
    //Splash timeout duration
    [loadConfigDict setValue:@(FirstAppOpen_Timeout) forKey:kATSplashExtraTolerateTimeoutKey];
    //Custom load parameters
    [loadConfigDict setValue:@"media_val_SplashVC" forKey:kATAdLoadingExtraMediaExtraKey];
    
    //Optional integration, if using Pangle ad platform, add the following configuration
    //[AdLoadConfigTool splash_loadExtraConfigAppend_Pangle:loadConfigDict];
    
    //If choosing to use Tencent GDT, recommended integration
    [AdLoadConfigTool splash_loadExtraConfigAppend_Tencent:loadConfigDict];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:placementID
                                                 extra:loadConfigDict
                                              delegate:self
                                         containerView:[self footLogoView]];
}

/// Show splash ad
- (void)showSplashWithPlacementID:(NSString *)placementID {
    //Check if ready
    if (![[ATAdManager sharedManager] splashReadyForPlacementID:placementID]) {
        return;
    }
    
    //Scene statistics feature, optional integration
    [[ATAdManager sharedManager] entrySplashScenarioWithPlacementID:placementID scene:@""];
     
    //Show configuration, Scene passes backend scene ID, empty string if none, showCustomExt parameter can pass custom parameter string
    ATShowConfig *config = [[ATShowConfig alloc] initWithScene:placementID showCustomExt:@"testShowCustomExt"];
    
    //Splash ad related parameter configuration
    NSMutableDictionary *configDict = [NSMutableDictionary dictionary];
    
    //Optional integration, custom skip button, most platforms no longer support custom skip buttons, currently supporting custom skip button changes are Pangle(TT), direct, ADX, native as splash and Youkeyingm, specific effects need to be tested
//    [AdLoadConfigTool splash_loadExtraConfigAppend_CustomSkipButton:configDict];
    
    //Show ad
    [[ATAdManager sharedManager] showSplashWithPlacementID:placementID config:config window:[UIApplication sharedApplication].keyWindow inViewController:[UIApplication sharedApplication].keyWindow.rootViewController extra:configDict delegate:self];
}

#pragma mark - Splash Ad Load Callback Handling
- (void)splashCallBackWithPlacementID:(NSString *)placementID result:(BOOL)result {
    
    if (result == NO) {
        [self.launchLoadingView dismiss];
    }
    
    AdManagerSplashAdLoadBlock block = self.splashAdCallbacks[placementID];
    if (block) {
        block(result);
        [self.splashAdCallbacks removeObjectForKey:placementID];
    }
}

#pragma mark - AppOpen FooterView
/// Optional splash bottom LogoView integration, only supported by some ad platforms
- (UIView *)footLogoView {
    
    //Width is screen width, height <=25% of screen height (depends on ad platform requirements)
    UIView * footerCtrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kOrientationScreenWidth, 120)];
    footerCtrView.backgroundColor = UIColor.whiteColor;
    
    //Add image
    UIImageView * logoImageView = [UIImageView new];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    logoImageView.contentMode = UIViewContentModeCenter;
    logoImageView.frame = footerCtrView.frame;
    [footerCtrView addSubview:logoImageView];
    
    //Add click event
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
///   - placementID: Placement ID
///   - error: Error information
- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    //Handle splash callback
    [self splashCallBackWithPlacementID:placementID result:NO];
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    [self splashCallBackWithPlacementID:placementID result:YES];
}

#pragma mark - Splash Ad Events
/// Splash load successful, need to check if timeout
/// - Parameters:
///   - placementID: Placement ID
///   - isTimeout: Whether timeout
- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout {
    //Handle splash callback
    [self splashCallBackWithPlacementID:placementID result:!isTimeout];
}

/// Splash ad timeout
/// - Parameter placementID: Placement ID
- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID {
    //Handle splash callback
    [self splashCallBackWithPlacementID:placementID result:NO];
}

/// Splash ad closed
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information
- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    //Handle splash callback
    [self splashCallBackWithPlacementID:placementID result:NO];
}

/// Splash ad show failed
/// - Parameters:
///   - placementID: Placement ID
///   - error: Error information
///   - extra: Extra information
- (void)splashDidShowFailedForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    //Handle splash callback
    [self splashCallBackWithPlacementID:placementID result:NO];
}
 
/// Splash ad user clicked
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information
- (void)splashDidClickForPlacementID:(nonnull NSString *)placementID extra:(nonnull NSDictionary *)extra {

}
 
/// Splash ad exposed
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information
- (void)splashDidShowForPlacementID:(nonnull NSString *)placementID extra:(nonnull NSDictionary *)extra {
 
}


#pragma mark - life
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
