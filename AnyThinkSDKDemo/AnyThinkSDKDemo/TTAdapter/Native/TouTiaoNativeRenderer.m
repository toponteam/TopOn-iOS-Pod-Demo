//
//  TouTiaoNativeRenderer.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "TouTiaoNativeRenderer.h"
#import "TouTiaoNativeCustomEvent.h"
#import <BUAdSDK/BUAdSDK.h>
#import <AnyThinkNative/AnyThinkNative.h>


@implementation TouTiaoNativeRenderer
-(__kindof UIView*)createMediaView {
    return nil;
}

-(void) renderOffer:(ATNativeADCache *)offer {
    [super renderOffer:offer];
    _customEvent = offer.assets[kAdAssetsCustomEventKey];
    _customEvent.adView = self.ADView;
    self.ADView.customEvent = _customEvent;
//    [self.ADView detatchRelatedView];
    
    BUNativeExpressAdManager *nativeExpressAd = (BUNativeExpressAdManager *)offer.assets[@"tt_nativeexpress_manager"];
    nativeExpressAd.delegate = _customEvent;
    BUNativeExpressAdView *nativeFeed = offer.assets[kAdAssetsCustomObjectKey];
    nativeFeed.rootViewController = self.configuration.rootViewController;
    [nativeFeed render];
    [self.ADView addSubview:(UIView*)nativeFeed];
    nativeFeed.center = CGPointMake(CGRectGetMidX(self.ADView.bounds), CGRectGetMidY(self.ADView.bounds));
    
}

-(BOOL)isVideoContents {
    return _customEvent.isVideo;
}
@end
