//
//  AppDelegate.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 6/2/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "AppDelegate.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

#import <AnyThinkMintegralAdapter/ATMintegralConfigure.h>
#import <AnyThinkGDTAdapter/ATGDTConfigure.h>
#import <AnyThinkPangleAdapter/ATPangleConfigure.h>
#import <AnyThinkVungleAdapter/ATVungleConfigure.h>
#import <AnyThinkAdColonyAdapter/ATAdColonyConfigure.h>
#import <AnyThinkMyTargetAdapter/ATMyTargetConfigure.h>
#import <AnyThinkFacebookAdapter/ATFacebookConfigure.h>

#define kTopOnAppID @"a5b0e8491845b3"
#define kTopOnAppKey @"7eae0567827cfe2b22874061763f30c9"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ATAPI setLogEnabled:YES];
    [ATAPI integrationChecking];
    
    [ATAPI sharedInstance].channel = @"test_channel";
    [ATAPI sharedInstance].subchannel = @"test_subchannel";
    [ATAPI sharedInstance].customData = @{kATCustomDataChannelKey:@"custom_data_channel",
                                          kATCustomDataSubchannelKey:@"custom_data_subchannel",
                                          kATCustomDataAgeKey:@18,
                                          kATCustomDataGenderKey:@1,
                                          kATCustomDataNumberOfIAPKey:@19,
                                          kATCustomDataIAPAmountKey:@20.0f,
                                          kATCustomDataIAPCurrencyKey:@"usd",
                                          kATCustomDataSegmentIDKey:@16382351
    };
//        [[ATAPI sharedInstance] setDeniedUploadInfoArray:@[kATDeviceDataInfoOSVersionNameKey,
//                                                           kATDeviceDataInfoOSVersionCodeKey,
//                                                           kATDeviceDataInfoPackageNameKey,
//                                                           kATDeviceDataInfoAppVersionCodeKey,
//                                                           kATDeviceDataInfoAppVersionNameKey,
//                                                           kATDeviceDataInfoBrandKey,
//                                                           kATDeviceDataInfoModelKey,
//                                                           kATDeviceDataInfoScreenKey,
//                                                           kATDeviceDataInfoNetworkTypeKey,
//                                                           kATDeviceDataInfoMNCKey,
//                                                           kATDeviceDataInfoMCCKey,
//                                                           kATDeviceDataInfoLanguageKey,
//                                                           kATDeviceDataInfoTimeZoneKey,
//                                                           kATDeviceDataInfoUserAgentKey,
//                                                           kATDeviceDataInfoOrientKey,
//                                                           kATDeviceDataInfoIDFAKey,
//                                                           kATDeviceDataInfoIDFVKey]];
    
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
    if (@available(iOS 14, *)) {
//         iOS 14
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            [[ATAPI sharedInstance] startWithAppID:kTopOnAppID appKey:kTopOnAppKey error:nil];
//            [self startInitToponSDK];
        }];
    } else {
        // Fallback on earlier versions
        [[ATAPI sharedInstance] startWithAppID:kTopOnAppID appKey:kTopOnAppKey error:nil];
//        [self startInitToponSDK];
    }
    
    // 设置系统平台信息，默认设置IOS=1
//    ATSystemPlatformTypeIOS = 1,
//    ATSystemPlatformTypeUnity = 2,
//    ATSystemPlatformTypeCocos2dx = 3,
//    ATSystemPlatformTypeCocosCreator = 4,
//    ATSystemPlatformTypeReactNative = 5,
//    ATSystemPlatformTypeFlutter = 6,
//    ATSystemPlatformTypeAdobeAir = 7
  //  [[ATAPI sharedInstance] setSystemPlatformType:ATSystemPlatformTypeIOS];
    
    
    return YES;
}

- (void)startInitToponSDK {
    ATMintegralConfigure *mtgConfigure = [[ATMintegralConfigure alloc] initWithAppid:@"104036" appkey:@"ef13ef712aeb0f6eb3d698c4c08add96"];
    ATGDTConfigure *gdtConfigure = [[ATGDTConfigure alloc] initWithAppid:@"1200028506"];
    ATPangleConfigure *pangleConfigure = [[ATPangleConfigure alloc] initWithAppid:@"8025677"];
    ATVungleConfigure *vungleConfigure = [[ATVungleConfigure alloc] initWithAppid:@"5b3f4ff774d9832229c3ccf1"];
    ATAdColonyConfigure *adcolonyConfigure = [[ATAdColonyConfigure alloc] initWithAppid:@"app9a5dc24248154b78ae" zoneIds:@[@"vza4636998f5314890bf",@"vza7010879fc6349da91",@"vzee3feb3b007d4fb8a2"]];
    ATMyTargetConfigure *mytargetConfigure = [[ATMyTargetConfigure alloc] init];
    ATFacebookConfigure *facebookConfigure = [[ATFacebookConfigure alloc] init];

    ATSDKConfiguration *configuration = [[ATSDKConfiguration alloc] init];
    configuration.preInitArray = @[mtgConfigure, gdtConfigure, pangleConfigure, vungleConfigure, adcolonyConfigure, mytargetConfigure, facebookConfigure];

    [[ATAPI sharedInstance] startWithAppID:kTopOnAppID appKey:kTopOnAppKey sdkConfigures:configuration error:nil];
}


#pragma mark - UISceneSession lifecycle

//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end
