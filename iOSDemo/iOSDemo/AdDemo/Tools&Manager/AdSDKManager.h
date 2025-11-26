//
//  AdSDKManager.h
//  iOSDemo
//
//  Created by ltz on 2025/3/26.
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <AnyThinkSplash/AnyThinkSplash.h>

// Initialization completion callback
typedef void (^AdManagerInitFinishBlock)(void);
// Splash ad loading callback
typedef void (^AdManagerSplashAdLoadBlock)(BOOL isSuccess);

// App ID from the dashboard
#define kTopOnAppID  @"h67eb68399d31b"

// App-level AppKey or Account-level AppKey from the dashboard
#define kTopOnAppKey @"a3983938bf3b5294c7f1a4b6cc67c6368"

// Cold start splash ad timeout duration
#define FirstAppOpen_Timeout 8

// Cold start splash ad placement ID
#define FirstAppOpen_PlacementID @"n67eb688a3eeea"

@interface AdSDKManager : NSObject

+ (instancetype)sharedManager;
 
/// If the app is distributed in the EU, use this method for initialization
- (void)initSDK_EU:(AdManagerInitFinishBlock)block;

/// Initialize SDK
- (void)initSDK;

#pragma mark - Splash Ad Related

/// Start splash ad
- (void)startSplashAd;
 
@end
