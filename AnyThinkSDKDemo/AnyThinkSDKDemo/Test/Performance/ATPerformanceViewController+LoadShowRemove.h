//
//  ATPerformanceViewController+LoadShowRemove.h
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/24.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATPerformanceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATPerformanceViewController (LoadShowRemove)
- (void)loadAllSplashAd;

- (void)loadAllBannerAd;

- (void)loadAllNativeAd;

- (void)showSplahAd;

- (void)showBannerAd;

- (void)showNativeAd;

- (void)removeBanner;

- (void)removeNative;

- (void)loadAllAd;

@end

NS_ASSUME_NONNULL_END
