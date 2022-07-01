//
//  ATPerformanceViewController+Timer.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/24.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATPerformanceViewController+Timer.h"
#import "ATPerformanceViewController+LoadShowRemove.h"

@implementation ATPerformanceViewController (Timer)

#pragma mark - Timer
- (void)launchTimer{
    
    self.checkLoadStatusTimer = [ZYGCDTimer timerWithTimeInterval:10 target:self selector:@selector(checkLoadStatus) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
}

- (void)checkLoadStatus{
    
    [self checkSplashLoadStatus];

    [self checkBannerLoadStatus];

    [self checkNativeLoadStatus];
}

- (void)checkSplashLoadStatus{
    BOOL splashReady = [[ATAdManager sharedManager] splashReadyForPlacementID:self.perSplashPlacementID];
    if (splashReady == YES) {
        self.lastSplashDate = [NSDate date];
        if (self.isSplashShow == NO) {
            [self showSplahAd];
        }
    }else{
        [self loadAllSplashAd];
    }
}

- (void)checkBannerLoadStatus{
    
    BOOL bannerReady = [[ATAdManager sharedManager] bannerAdReadyForPlacementID:self.perBannerPlacementID];

    if (bannerReady == YES) {
        self.lastBannerDate = [NSDate date];

        [self removeBanner];
        [self showBannerAd];
        
    }else{
        [self loadAllBannerAd];
    }
}

- (void)checkNativeLoadStatus{
    
    BOOL nativeReady = [[ATAdManager sharedManager] nativeAdReadyForPlacementID:self.perNativePlacementID];

    if (nativeReady == YES) {
        self.lastNativeDate = [NSDate date];
        [self removeNative];
        [self showNativeAd];
        
    }else{

        [self loadAllNativeAd];
    }
}

@end
