//
//  TouTiaoInterstitialCustomEvent.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "TouTiaoInterstitialCustomEvent.h"

@implementation TouTiaoInterstitialCustomEvent

#pragma mark - interstitial delegate method(s)

- (void)nativeExpresInterstitialAdDidLoad:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSLog(@"TouTiaoInterstitialCustomEvent::interstitialAdDidLoad:");
    [self trackInterstitialAdLoaded:interstitialAd adExtra:nil];
}

- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError * __nullable)error {
    NSLog(@"%@",[NSString stringWithFormat:@"TouTiaoInterstitialCustomEvent::interstitialAd:didFailWithError:%@", error]);
    [self trackInterstitialAdLoadFailed:error];
}

- (void)nativeExpresInterstitialAdWillVisible:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSLog(@"TouTiaoInterstitialCustomEvent::interstitialAdWillVisible:");
    [self trackInterstitialAdShow];
}

- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSLog(@"TouTiaoInterstitialCustomEvent::interstitialAdDidClick:");
    [self trackInterstitialAdClick];
}

- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSLog(@"TouTiaoInterstitialCustomEvent::interstitialAdDidClose:");
    [self trackInterstitialAdClose];
}

- (void)nativeExpresInterstitialAdWillClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSLog(@"TouTiaoInterstitialCustomEvent::interstitialAdWillClose:");
}

- (NSString *)networkUnitId {
    return self.serverInfo[@"slot_id"];
}

@end
