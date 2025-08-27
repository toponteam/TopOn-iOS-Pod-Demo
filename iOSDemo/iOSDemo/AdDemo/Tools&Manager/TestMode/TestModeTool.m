//
//  TestModeTool.m
//  iOSDemo
//
//  Created by ltz on 2025/2/12.
//

#import "TestModeTool.h"
#import <AnyThinkSDK/ATDebuggerConfigDefine.h>
 
@implementation TestModeTool

/// Show Debug UI on specified vc, recommend using system UIViewController directly, passing inherited or custom vc may cause display issues
/// Requires pod 'TPNDebugUISDK' please remove after testing⚠️
/// - Parameter vc: Target vc
+ (void)showDebugUI:(UIViewController *)vc {
    //Import header file #import <AnyThinkDebuggerUISDK/ATDebuggerAPI.h>
    //Note: showType supports ATShowDebugUIPresent and ATShowDebugUIPush, if push fails, ensure your navigation controller has no extra inheritance.
    //Trigger conditions:
    //window - rootNavigation - viewController -> push debugUI
    //1.iOS SDK has been successfully initialized
    //2.No ads have been loaded yet
    //3.Disable debug mode, remove -[ATSDKGlobalSetting setDebuggerConfig:] related code
    [[ATDebuggerAPI sharedInstance] showDebuggerInViewController:vc showType:ATShowDebugUIPresent debugkey:@"Enter your DebugKey, get DebugKey from Backend->Account Management->Key, DebugKey must correspond to AppID and AppKey"];
}

/// Enable test mode (can only specify one ad platform at a time, not guaranteed 100% ad fill)
/// To disable test mode, simply comment out related methods
/// Please remove before release⚠️Please remove after testing⚠️
/// - Parameters:
///   - type: Ad platform type to test this time
///   - currentIDFAStr: Current test device IDFA, must pass valid value
+ (void)enableTestModeWith3rdSDKType:(ATAdNetWorkType)type currentIDFAStr:(NSString *)currentIDFAStr {

    [[ATSDKGlobalSetting sharedManager] setDebuggerConfig:^(ATDebuggerConfig * _Nullable debuggerConfig) {
        debuggerConfig.deviceIdfaStr = currentIDFAStr;
        //Specify the ad platform name type to test
        debuggerConfig.netWorkType = ATAdNetWorkApplovinType;
        
//        Specify a certain type of ad platform
//        debuggerConfig.adx_nativeAdType = ATADXNativeAdTypeSelfRender;//Native self-rendering
    }];
}

/// Enable header bidding ad source test mode
/// Please remove after testing⚠️
/// - Parameters:
///   - currentIDFAStr: Current test device IDFA, must pass valid value
+ (void)enableHeaderBiddingTestModeWithCurrentIDFAStr:(NSString *)currentIDFAStr {
    //Must enable logging
    [ATAPI setLogEnabled:YES];
    //Please remove after testing⚠️
    [ATSDKGlobalSetting sharedManager].headerBiddingTestModeDeviceID = currentIDFAStr;
}

@end

