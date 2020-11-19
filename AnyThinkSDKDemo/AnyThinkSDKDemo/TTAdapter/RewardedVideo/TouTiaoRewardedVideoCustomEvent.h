//
//  TouTiaoRewardedVideoCustomEvent.h
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
@import BUAdSDK;

NS_ASSUME_NONNULL_BEGIN

@interface TouTiaoRewardedVideoCustomEvent : ATRewardedVideoCustomEvent<BUNativeExpressRewardedVideoAdDelegate>
@property (nonatomic) BOOL isFailed;

@end

NS_ASSUME_NONNULL_END
