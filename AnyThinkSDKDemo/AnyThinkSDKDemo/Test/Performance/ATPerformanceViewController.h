//
//  ATPerformanceViewController.h
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/21.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZYGCDTimer.h>


@import AnyThinkSplash;
@import AnyThinkBanner;
@import AnyThinkNative;


NS_ASSUME_NONNULL_BEGIN

@interface ATPerformanceViewController : UIViewController<ATSplashDelegate, ATAdLoadingDelegate,ATBannerDelegate,ATNativeADDelegate>


@property (weak, nonatomic) IBOutlet UIButton *interBtn;

@property (weak, nonatomic) IBOutlet UIButton *rewardBtn;
@property (weak, nonatomic) IBOutlet UIButton *logBtn;

@property(nonatomic,strong,nullable) ATNativeADView *nativeAdView;


@property(nonatomic, strong) ZYGCDTimer *checkLoadStatusTimer;

@property(nonatomic, strong) NSString *perSplashPlacementID;

@property(nonatomic, strong) NSString *perNativePlacementID;

@property(nonatomic, strong) NSString *perBannerPlacementID;

@property(nonatomic, strong) NSArray *splashIDArray;

@property(nonatomic, strong) NSArray *bannerIDArray;

@property(nonatomic, strong) NSArray *nativeIDArray;

@property(nonatomic, assign) BOOL isSplashShow;

@property (nonatomic, strong,nullable) UIView *bannerAdView;


@property(nonatomic, assign) CGSize bannerAdSize;

@property(nonatomic, assign) CGSize nativeAdSize;


@property(nonatomic, strong) NSDate *lastSplashDate;

@property(nonatomic, strong) NSDate *lastBannerDate;

@property(nonatomic, strong) NSDate *lastNativeDate;


@property(nonatomic, strong) NSDate *loadSplashDate;

@property(nonatomic, strong) NSDate *showSplashDate;


@property(nonatomic, assign) BOOL timeOn;

- (UIInterfaceOrientation)currentInterfaceOrientation;

- (void)CallPolice:(NSDate*)lastDate;

- (NSString *)getRandomID:(NSArray *)idArray placementID:(NSString *)placementID;


@end

NS_ASSUME_NONNULL_END
