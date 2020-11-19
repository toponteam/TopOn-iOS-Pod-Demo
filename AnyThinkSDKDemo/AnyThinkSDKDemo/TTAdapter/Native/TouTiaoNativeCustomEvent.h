//
//  TouTiaoNativeCustomEvent.h
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AnyThinkNative/AnyThinkNative.h>
@import BUAdSDK;

extern NSString *const kToutiaoNativeAssetsCustomEventKey;


NS_ASSUME_NONNULL_BEGIN

@interface TouTiaoNativeCustomEvent : ATNativeADCustomEvent<BUNativeAdsManagerDelegate, BUNativeAdDelegate, BUVideoAdViewDelegate,BUNativeExpressAdViewDelegate>
@property(nonatomic) BOOL isVideo;
@property(nonatomic) BOOL isFailed;

@end

NS_ASSUME_NONNULL_END
