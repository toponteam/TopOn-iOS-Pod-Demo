//
//  TouTiaoInterstitialCustomEvent.h
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <BUAdSDK/BUAdSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface TouTiaoInterstitialCustomEvent : ATInterstitialCustomEvent<BUInterstitialAdDelegate, BUFullscreenVideoAdDelegate, BUNativeExpresInterstitialAdDelegate>
@property (nonatomic)BOOL isFailed;

@end

NS_ASSUME_NONNULL_END
