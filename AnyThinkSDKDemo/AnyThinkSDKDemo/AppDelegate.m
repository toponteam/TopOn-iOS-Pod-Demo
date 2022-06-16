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
            [[ATAPI sharedInstance] startWithAppID:@"a5b0e8491845b3" appKey:@"7eae0567827cfe2b22874061763f30c9" error:nil];
        }];
    } else {
        // Fallback on earlier versions
        [[ATAPI sharedInstance] startWithAppID:@"a5b0e8491845b3" appKey:@"7eae0567827cfe2b22874061763f30c9" error:nil];
    }
    
    // 设置系统平台信息，默认设置IOS=1
//    ATSystemPlatformTypeIOS = 1,
//    ATSystemPlatformTypeUnity = 2,
//    ATSystemPlatformTypeCocos2dx = 3,
//    ATSystemPlatformTypeCocosCreator = 4,
//    ATSystemPlatformTypeReactNative = 5,
//    ATSystemPlatformTypeFlutter = 6,
//    ATSystemPlatformTypeAdobeAir = 7
    [[ATAPI sharedInstance] setSystemPlatformType:ATSystemPlatformTypeIOS];
    
    return YES;
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
