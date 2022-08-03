//
//  TopOnAdManager.m
//  AnyThinkSDKDemo
//
//  Created by Martin Lau on 2020/1/10.
//  Copyright © 2020 AnyThink. All rights reserved.
//

#import "TopOnAdManager.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "ATBaiduTemplateRenderingAttribute.h"

@implementation TopOnAdManager
+(instancetype) sharedManager {
    static TopOnAdManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[TopOnAdManager alloc] init];
        
    });
    return sharedManager;
}

-(void) initTopOnSDK {
    [ATAPI setLogEnabled:YES];
        
    [ATAPI integrationChecking];

    [ATAPI setHeaderBiddingTestModeWithDeviceID:@"1F7DB84C-5DCF-4095-B059-F18A7D17946C"];
    // set personaliz state
    [[ATAPI sharedInstance] setPersonalizedAdState:ATPersonalizedAdStateType];

    // only for pangle
    [ATAPI setNetworkTerritory:ATNetworkTerritory_CN];

    //channel&subchannle -> customData.channel&subchannel
    [ATAPI sharedInstance].channel = @"test_channel";
    [ATAPI sharedInstance].subchannel = @"test_subchannel";
    [ATAPI sharedInstance].customData = @{kATCustomDataUserIDKey:@"test_custom_user_id",
                                          kATCustomDataChannelKey:@"custom_data_channel",
                                          kATCustomDataSubchannelKey:@"custom_data_subchannel",
                                          kATCustomDataAgeKey:@18,
                                          kATCustomDataGenderKey:@1,
                                          kATCustomDataNumberOfIAPKey:@19,
                                          kATCustomDataIAPAmountKey:@20.0f,
                                          kATCustomDataIAPCurrencyKey:@"usd",
                                          kATCustomDataSegmentIDKey:@16382351
    };
    
    [[ATAPI sharedInstance] setCustomData:@{
        kATCustomDataChannelKey:@"placement_custom_data_channel",
        kATCustomDataSubchannelKey:@"placement_custom_data_subchannel"
    } forPlacementID:@"b5c1b048c498b9"];

    [ATAPI sharedInstance].networkConsentInfo = @{kATNetworkNameUnityAds : @(0)};

//    [[ATAPI sharedInstance] setDeniedUploadInfoArray:@[kATDeviceDataInfoOSVersionNameKey,
//                                                       kATDeviceDataInfoOSVersionCodeKey,
//                                                       kATDeviceDataInfoPackageNameKey,
//                                                       kATDeviceDataInfoAppVersionCodeKey,
//                                                       kATDeviceDataInfoAppVersionNameKey,
//                                                       kATDeviceDataInfoBrandKey,
//                                                       kATDeviceDataInfoModelKey,
//                                                       kATDeviceDataInfoScreenKey,
//                                                       kATDeviceDataInfoNetworkTypeKey,
//                                                       kATDeviceDataInfoMNCKey,
//                                                       kATDeviceDataInfoMCCKey,
//                                                       kATDeviceDataInfoLanguageKey,
//                                                       kATDeviceDataInfoTimeZoneKey,
//                                                       kATDeviceDataInfoUserAgentKey,
//                                                       kATDeviceDataInfoOrientKey,
//                                                       kATDeviceDataInfoIDFAKey,
//                                                       kATDeviceDataInfoIDFVKey]];
        
    [[ATAPI sharedInstance] getUserLocationWithCallback:^(ATUserLocation location) {
        if (location == ATUserLocationInEU) {
            NSLog(@"----------ATUserLocationInEU");
            if ([ATAPI sharedInstance].dataConsentSet == ATDataConsentSetUnknown) {
                NSLog(@"----------ATDataConsentSetUnknown");
            }
        }else if (location == ATUserLocationOutOfEU){
            NSLog(@"----------ATUserLocationOutOfEU");
        }else{
            NSLog(@"----------ATUserLocationUnknown");
        }
    }];
                
    [[ATAPI sharedInstance] getAreaSuccess:^(NSString *areaCodeStr) {
        NSLog(@"getArea:%@",areaCodeStr);
    } failure:^(NSError *error) {
            NSLog(@"getArea:%@",error.domain);
    }];
    
    ATBaiduTemplateRenderingAttribute *temp = [[ATBaiduTemplateRenderingAttribute alloc]init];
    temp.iconWidth = @"22";
    [[ATAdManager sharedManager] setBaiduTemplateRenderingAttribute: temp];
        
    // 设置系统平台信息，默认设置IOS=1
//    ATSystemPlatformTypeIOS = 1,
//    ATSystemPlatformTypeUnity = 2,
//    ATSystemPlatformTypeCocos2dx = 3,
//    ATSystemPlatformTypeCocosCreator = 4,
//    ATSystemPlatformTypeReactNative = 5,
//    ATSystemPlatformTypeFlutter = 6,
//    ATSystemPlatformTypeAdobeAir = 7
    [[ATAPI sharedInstance] setSystemPlatformType:ATSystemPlatformTypeIOS];
        
    // init SDK
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            [[ATAPI sharedInstance] startWithAppID:kTopOnAppID appKey:kTopOnAppKey error:nil];
        }];
    } else {
        // Fallback on earlier versions
        [[ATAPI sharedInstance] startWithAppID:kTopOnAppID appKey:kTopOnAppKey error:nil];
    }
}



@end
