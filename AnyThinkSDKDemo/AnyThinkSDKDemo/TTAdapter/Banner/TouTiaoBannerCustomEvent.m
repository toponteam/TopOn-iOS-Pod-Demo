//
//  TouTiaoBannerCustomEvent.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "TouTiaoBannerCustomEvent.h"

@implementation TouTiaoBannerCustomEvent

- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {
    NSLog(@"TouTiaoBannerCustomEvent::bannerAdViewDidLoad:WithAdmodel:");
    [self trackBannerAdLoaded:bannerAdView adExtra:nil];
}

- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {
    NSLog(@"TouTiaoBannerCustomEvent::bannerAdViewDidBecomVisible:WithAdmodel:");
}

- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {
    NSLog(@"TouTiaoBannerCustomEvent::bannerAdViewDidClick:WithAdmodel:");
    [self trackBannerAdClick];
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *_Nullable)error {
    NSLog(@"%@",[NSString stringWithFormat:@"TouTiaoBannerCustomEvent::bannerAdView:didLoadFailWithError:%@",error]);
    [self handleLoadingFailure:error];
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterwords {
    NSLog(@"TouTiaoBannerCustomEvent::bannerAdView:dislikeWithReason:");
//    [self.bannerView loadNextWithoutRefresh];
    if ([self.delegate respondsToSelector:@selector(bannerView:didTapCloseButtonWithPlacementID:extra:)]) {
        [self.delegate bannerView:self.bannerView didTapCloseButtonWithPlacementID:self.banner.placementModel.placementID extra:[self delegateExtra]];
    }
    [self trackBannerAdClosed];
}

- (NSString *)networkUnitId {
    return self.serverInfo[@"slot_id"];
}


@end
