//
//  TouTiaoNativeCustomEvent.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "TouTiaoNativeCustomEvent.h"
#import <AnyThinkNative/AnyThinkNative.h>
//#import <AnyThinkSDK/ATAdManagement.h>

@implementation TouTiaoNativeCustomEvent


- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAd views:(NSArray<__kindof BUNativeExpressAdView *> *)views {
    NSLog(@"TTNative::nativeExpressAdSuccessToLoad:nativeAds:");
    if (views.count) {
        NSMutableArray<NSDictionary*>* assets = [NSMutableArray<NSDictionary*> array];
        [views enumerateObjectsUsingBlock:^(BUNativeExpressAdView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *asset = [NSMutableDictionary dictionary];
            BUNativeExpressAdView* expressView = obj;
            asset[kAdAssetsCustomEventKey] = self;
            asset[kAdAssetsCustomObjectKey] = obj;
            asset[@"tt_nativeexpress_manager"] = nativeExpressAd;
            expressView.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            [assets addObject:asset];
        }];
        self.requestCompletionBlock(assets, nil);
    }
}

- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAd error:(NSError *_Nullable)error{
    NSLog(@"%@",[NSString stringWithFormat:@"TTNative::nativeAdsManager:didFailWithError:%@", error]);
    self.requestCompletionBlock(nil, error);
}


- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"TTNative::nativeExpressAdViewRenderSuccess:");
}

- (void)nativeExpressAdViewDidClick:(BUNativeExpressAdView *)nativeExpressAdView {
    NSLog(@"TTNative::nativeAdDidClick:withView:");
    [self trackNativeAdClick];
}

- (void)nativeExpressAdView:(BUNativeExpressAdView *)nativeExpressAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterWords {
    NSLog(@"TTNative::nativeAd:dislikeWithReason:");
    [self trackNativeAdClosed];
}

- (void)nativeExpressAdViewPlayerDidPlayFinish:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *)error {
    NSLog(@"TTNative::nativeAd:nativeExpressAdViewPlayerDidPlayFinish:");
    [self trackNativeAdVideoEnd];
}

- (NSString *)networkUnitId {
    return self.serverInfo[@"slot_id"];
}

@end
