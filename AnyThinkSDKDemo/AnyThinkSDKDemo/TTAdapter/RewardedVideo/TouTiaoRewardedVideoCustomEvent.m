//
//  TouTiaoRewardedVideoCustomEvent.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "TouTiaoRewardedVideoCustomEvent.h"

@implementation TouTiaoRewardedVideoCustomEvent

#pragma mark - nativeExpressRVDelegate
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdDidLoad:");
    [self trackRewardedVideoAdLoaded:rewardedVideoAd adExtra:nil];
}

- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    NSLog(@"%@",[NSString stringWithFormat:@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdDidLoad:didFailWithError:%@",error]);
    if (!_isFailed) {
        [self trackRewardedVideoAdLoadFailed:error];
        _isFailed = true;
    }
}

- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdDidDownLoadVideo:");
}

- (void)nativeExpressRewardedVideoAdViewRenderSuccess:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdViewRenderSuccess:");
}

- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *_Nullable)error {
    NSLog(@"%@",[NSString stringWithFormat:@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdViewRenderFail:error:%@",error]);
    if (!_isFailed) {
        [self trackRewardedVideoAdLoadFailed:error];
        _isFailed = true;
    }
}

- (void)nativeExpressRewardedVideoAdWillVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdWillVisible:");
}

- (void)nativeExpressRewardedVideoAdDidVisible:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdDidVisible:");
    [self trackRewardedVideoAdShow];
    [self trackRewardedVideoAdVideoStart];
}

- (void)nativeExpressRewardedVideoAdWillClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdWillClose:");
}

- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdDidClose:");
    [self trackRewardedVideoAdCloseRewarded:self.rewardGranted];
}

- (void)nativeExpressRewardedVideoAdDidClick:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdDidClick:");
    [self trackRewardedVideoAdClick];
}

- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdDidClickSkip:");
}

- (void)nativeExpressRewardedVideoAdDidPlayFinish:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *_Nullable)error {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdDidPlayFinish:didFailWithError:");
    if (error == nil) {
        [self trackRewardedVideoAdVideoEnd];
    } else {
        [self trackRewardedVideoAdPlayEventWithError:error];
    }
}

- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdServerRewardDidSucceed:verify:");
    [self trackRewardedVideoAdRewarded];
}

- (void)nativeExpressRewardedVideoAdServerRewardDidFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    NSLog(@"TouTiaoRewardedVideoCustomEvent::nativeExpressRewardedVideoAdServerRewardDidFail:");
    self.rewardGranted = NO;
}

- (NSString *)networkUnitId {
    return self.serverInfo[@"slot_id"];
}

@end
