//
//  TouTiaoSplashCustomEvent.h
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/21/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AnyThinkSplash/AnyThinkSplash.h>
@import BUAdSDK;

NS_ASSUME_NONNULL_BEGIN

@interface TouTiaoSplashCustomEvent : ATSplashCustomEvent<BUSplashAdDelegate>
@property(nonatomic, weak) UIView *containerView;
@property(nonatomic, weak) UIView *ttSplashView;
@property(nonatomic, weak) UIWindow *window;
@property(nonatomic, weak) UIImageView *backgroundImageView;
@property(nonatomic) NSDate *expireDate;

@end

NS_ASSUME_NONNULL_END
