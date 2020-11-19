//
//  TouTiaoSplashCustomEvent.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/21/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "TouTiaoSplashCustomEvent.h"
#import <AnyThinkSplash/AnyThinkSplash.h>

@implementation TouTiaoSplashCustomEvent

- (void)splashAdDidClick:(BUSplashAdView *)splashAd {
    [self trackSplashAdClick];
}

- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    [_containerView removeFromSuperview];
    [_backgroundImageView removeFromSuperview];
    [(UIView*)splashAd removeFromSuperview];
    [self trackSplashAdClosed];
}

- (void)splashAdWillClose:(BUSplashAdView *)splashAd {
}

- (void)splashAdDidLoad:(BUSplashAdView *)splashAd {
    if ([[NSDate date] timeIntervalSinceDate:_expireDate] > 0) {
        NSError *error = [NSError errorWithDomain:ATADLoadingErrorDomain code:ATADLoadingErrorCodeADOfferLoadingFailed userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long for TT to load splash."}];
        [_backgroundImageView removeFromSuperview];
        [self trackSplashAdLoadFailed:error];
    } else {
        [_window addSubview:_containerView];
        [_window addSubview:_ttSplashView];
        [self trackSplashAdLoaded:splashAd];
        [self trackSplashAdShow];
    }
}

- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error {
    [_backgroundImageView removeFromSuperview];
    [_ttSplashView removeFromSuperview];
    [_containerView removeFromSuperview];
    [self trackSplashAdLoadFailed:error];
}

- (void)splashAdWillVisible:(BUSplashAdView *)splashAd {
}


#pragma mark - nativeExpressSplash

- (void)nativeExpressSplashViewDidLoad:(BUNativeExpressSplashView *)splashAdView {
    
}

- (void)nativeExpressSplashView:(BUNativeExpressSplashView *)splashAdView didFailWithError:(NSError * _Nullable)error {
    [_backgroundImageView removeFromSuperview];
    [_ttSplashView removeFromSuperview];
    [_containerView removeFromSuperview];
    [self trackSplashAdLoadFailed:error];
}

- (void)nativeExpressSplashViewRenderSuccess:(BUNativeExpressSplashView *)splashAdView {
    if ([[NSDate date] timeIntervalSinceDate:_expireDate] > 0) {
        NSError *error = [NSError errorWithDomain:ATADLoadingErrorDomain code:ATADLoadingErrorCodeADOfferLoadingFailed userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long for TT to load splash."}];
        [_backgroundImageView removeFromSuperview];
        [self trackSplashAdLoadFailed:error];
    } else {
        [_window addSubview:_containerView];
        [_window addSubview:_ttSplashView];
        [self trackSplashAdLoaded:splashAdView];
    }
}

- (void)nativeExpressSplashViewRenderFail:(BUNativeExpressSplashView *)splashAdView error:(NSError * __nullable)error {
    [_backgroundImageView removeFromSuperview];
    [self trackSplashAdLoadFailed:error];
}

- (void)nativeExpressSplashViewWillVisible:(BUNativeExpressSplashView *)splashAdView {
    
}

- (void)nativeExpressSplashViewDidClick:(BUNativeExpressSplashView *)splashAdView {
    [self trackSplashAdClick];
}

- (void)nativeExpressSplashViewDidClickSkip:(BUNativeExpressSplashView *)splashAdView {
    
}

- (void)nativeExpressSplashViewDidClose:(BUNativeExpressSplashView *)splashAdView {
    [_containerView removeFromSuperview];
    [_backgroundImageView removeFromSuperview];
    [(UIView*)splashAdView removeFromSuperview];
    [self trackSplashAdClosed];

}

- (void)nativeExpressSplashViewFinishPlayDidPlayFinish:(BUNativeExpressSplashView *)splashView didFailWithError:(NSError *)error {
    
}

- (NSString *)networkUnitId {
    return self.serverInfo[@"slot_id"];
}


@end
