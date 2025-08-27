//
//  AdLoadConfigTool.m
//  iOSDemo
//
//  Created by ltz on 2025/2/12.
//

#import "SDKGlobalConfigTool.h"

@implementation SDKGlobalConfigTool

/// Custom traffic segmentation rule, rule format: key=value, call this method before loading ads with placement ID
/// Backend rule changes take effect in ~5 minutes; local segmentation policy cached in sandbox for 30 minutes
/// - Parameters:
///   - key: Rule key
///   - value: Rule value
///   - placementID: Placement ID
+ (void)joinSegmentRuleWithKey:(NSString *)key value:(NSString *)value placementID:(NSString *)placementID {
    
    //Placement policy has 30min sandbox cache, try deleting and reinstalling for testing, set custom segmentation rules before loading ads.
    //Example:
    //TopOn backend configured custom segmentation rule: isTest=1
    //Use this method: [AdLoadConfigTool joinSegmentRuleWithKey:@"isTest" value:@"1" placementID:placementID]
    [[ATSDKGlobalSetting sharedManager] setCustomData:@{key:value} forPlacementID:placementID];
}

/// Set custom configuration for reports or special features
+ (void)setCustomData:(NSDictionary *)dataDict {
    
    //Common keys shown in reports
//    extern NSString *const kATCustomDataUserIDKey;//User ID, String value
//    extern NSString *const kATCustomDataAgeKey;//User age, Integer value
//    extern NSString *const kATCustomDataGenderKey;//User gender, Integer value
    
    [ATSDKGlobalSetting sharedManager].customData = dataDict;
}

/// User-defined iOS device ID upload (shown in reports, corresponds to set_idfa field)
/// - Parameter idfaString: String
+ (void)setCustomDeviceIDFA:(NSString *)idfaString {
//    ATUID2Info *UID2Info = [[ATUID2Info alloc] init];
//    UID2Info.UID2Token = @"text_UID2Token";
    [[ATSDKGlobalSetting sharedManager] setDeviceInfoConfig:^(ATDeviceInfoConfig * _Nullable deviceInfoConfig) {
        deviceInfoConfig.idfaStr = idfaString;
//        deviceInfoConfig.UID2Info = UID2Info;
    }];
}

/// Set custom channel string (shown in reports, corresponds to channel field)
/// - Parameters:
///   - channelStr: Channel string
+ (void)setCustomChannel:(NSString *)channelStr {
    [ATSDKGlobalSetting sharedManager].channel = channelStr;
}

/// Set items prohibited from SDK reporting
+ (void)setDeniedUploadInfo {
    [[ATSDKGlobalSetting sharedManager] setDeniedUploadInfoArray:@[
        kATDeviceDataInfoBatteryKey,
        //ATSDKGlobalSetting.h
//        kATDeviceDataInfoOSVersionNameKey,
//        kATDeviceDataInfoOSVersionCodeKey,
//        kATDeviceDataInfoPackageNameKey,
//        kATDeviceDataInfoAppVersionCodeKey,
//        kATDeviceDataInfoAppVersionNameKey,
//        kATDeviceDataInfoBrandKey,
//        kATDeviceDataInfoModelKey,
//        kATDeviceDataInfoScreenKey,
//        kATDeviceDataInfoNetworkTypeKey,
//        kATDeviceDataInfoMNCKey,
//        kATDeviceDataInfoMCCKey,
//        kATDeviceDataInfoLanguageKey,
//        kATDeviceDataInfoTimeZoneKey,
//        kATDeviceDataInfoUserAgentKey,
//        kATDeviceDataInfoOrientKey,
//        kATDeviceDataInfoIDFAKey,
//        kATDeviceDataInfoIDFVKey,
//        kATDeviceDataInfoSIMCardStateKey,
    ]];
}

/// Set app-level filtering
/// - Parameter appleIdArr: Example: @[@"id529479190"]
+ (void)enableAppFilter:(NSArray *)appleIdArr {
    [[ATSDKGlobalSetting sharedManager] setExludeAppleIdArray:appleIdArr];
}


/// Set placement-level filtering
/// - Parameter placementIDArr: Example: @[@"b5bacad26a752a"], replace with your desired placement IDs to filter
+ (void)enablePlacementFilter:(NSArray *)placementIDArr {
    [[ATAdManager sharedManager] setAdSourceCustomizeFillterPlacementIDArray:placementIDArr];
}

/// Enable ad source-level filtering
/// - Parameter adSourceIDArr: Replace with your desired ad source IDs to filter
+ (void)enableAdSourceFilter:(NSArray *)adSourceIDArr {
    [ATAdManager sharedManager].adSourceCustomizeFillter = ^BOOL(NSDictionary *extra) {
        if ([adSourceIDArr containsObject:extra[@"adsource_id"]]) {
            ATDemoLog(@"AdSourceFilter filtered:%@",extra);
            return YES;
        }else{
            NSLog(@"AdSourceFilter not filtered:%@",extra);
            return NO;
        }
    };
}

/// Enable filtering for specific ad platforms under placement
/// - Parameters:
///   - placementID: Placement ID
///   - networkFirmIDArr: Ad platform network firm IDs
+ (void)enableAdPlatformFilterWithPlacementID:(NSString *)placementID networkFirmIDArray:(NSArray <NSNumber *>*)networkFirmIDArr {
    [[ATAdManager sharedManager] setExludePlacementid:placementID networkFirmIDArray:networkFirmIDArr];
}

/// Overseas Pangle privacy configuration
/// Pangle SDK v7.1+ removed COPPA and CCPA settings, unified to use PAConsent. TopOn SDK v6.4.56+ added corresponding APIs for your custom settings.
/// Note: When not set, Pangle SDK defaults to Consent status.
+ (void)pangleCOPPACCPASetting {
    
//#import <AnyThinkPangleAdapter/AnyThinkPangleAdapter.h>
//
//typedef NS_ENUM(NSInteger, ATPAGPAConsentType) {
//    ATPAGPAConsentTypeConsent     =  0,   ///< User has granted the consent
//    ATPAGPAConsentTypeNoConsent   =  1,   ///< User doesn't grant consent
//};
 
//    //Use this method to fill ads
//    [ATPangleConfigure setPAGPAConsentType:ATPAGPAConsentTypeConsent];
//
//    //Use this method to not fill ads
//    [ATPangleConfigure setPAGPAConsentType:ATPAGPAConsentTypeNoConsent];
}

 
@end
