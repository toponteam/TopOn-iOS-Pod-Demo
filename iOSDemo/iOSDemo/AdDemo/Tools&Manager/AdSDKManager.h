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

//初始化完成回调
typedef void (^AdManagerInitFinishBlock)(void);
//开屏加载回调
typedef void (^AdManagerSplashAdLoadBlock)(BOOL isSuccess);

//在后台的应用ID
#define kTopOnAppID  @"h67eb68399d31b"

//在后台的应用维度AppKey，或者是账号维度AppKey
#define kTopOnAppKey @"a3983938bf3b5294c7f1a4b6cc67c6368"

//冷启动开屏超时时间
#define FirstAppOpen_Timeout 8

//冷启动开屏广告位ID
#define FirstAppOpen_PlacementID @"n67eb688a3eeea"

@interface AdSDKManager : NSObject

+ (instancetype)sharedManager;
 
/// 应用若在欧盟地区发行，使用本方法初始化
- (void)initSDK_EU:(AdManagerInitFinishBlock)block;

/// 初始化SDK
- (void)initSDK;

#pragma mark - 开屏广告相关

/// 启动开屏广告
- (void)startSplashAd;
 
@end


