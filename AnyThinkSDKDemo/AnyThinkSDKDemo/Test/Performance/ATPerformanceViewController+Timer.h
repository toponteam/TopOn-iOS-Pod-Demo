//
//  ATPerformanceViewController+Timer.h
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/24.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATPerformanceViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATPerformanceViewController (Timer)

- (void)launchTimer;

- (void)checkLoadStatus;

- (void)checkSplashLoadStatus;

- (void)checkBannerLoadStatus;

- (void)checkNativeLoadStatus;


@end

NS_ASSUME_NONNULL_END
