//
//  ATPerformanceViewController+LoadShowRemove.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/24.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATPerformanceViewController+LoadShowRemove.h"
#import <Masonry/Masonry.h>
#import "ATNativeSelfRenderView.h"




@implementation ATPerformanceViewController (LoadShowRemove)

#pragma mark - load
- (void)loadAllAd{
    
    [self loadAllSplashAd];
    
       
    [self loadAllBannerAd];
    
    
    [self loadAllNativeAd];
    
    
}

- (void)loadAllSplashAd{
    [self.splashIDArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self loadSplashAd:obj];
    }];
}

- (void)loadAllBannerAd{
    [self.bannerIDArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self loadBannerAd:obj];
    }];
}

- (void)loadAllNativeAd{
    
    [self.nativeIDArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self loadNativeAd:obj];
    }];
}

- (void)loadSplashAd:(NSString *)splashPlacementID{
    
    NSLog(@"🔥---开屏发起load---splashPlacementID:%@",splashPlacementID);
    self.loadSplashDate = [NSDate date];
    
    [self CallPolice:self.lastSplashDate];
    
    UIInterfaceOrientation deviceOrientaion = [self currentInterfaceOrientation];
    BOOL landscape = UIInterfaceOrientationIsLandscape(deviceOrientaion);
    
    UILabel *label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(.0f, .0f, landscape ? 120 : UIScreen.mainScreen.bounds.size.width, landscape ? UIScreen.mainScreen.bounds.size.height : 100.0f)];
    label.text = @"Container";
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:@5.5 forKey:kATSplashExtraTolerateTimeoutKey];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:splashPlacementID extra:mutableDict delegate:self containerView:label defaultAdSourceConfig: nil];
}

- (void)loadBannerAd:(NSString *)bannerPlacementID{
    NSLog(@"🔥---横幅发起load---bannerPlacementID%@",bannerPlacementID);
    
    [self CallPolice:self.lastBannerDate];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:bannerPlacementID extra:@{
        kATAdLoadingExtraBannerAdSizeKey:[NSValue valueWithCGSize:self.bannerAdSize],
        kATAdLoadingExtraBannerSizeAdjustKey:@NO} delegate:self];
}

- (void)loadNativeAd:(NSString *)nativePlacementID{
    
    NSLog(@"🔥---原生发起load--nativePlacementID:%@",nativePlacementID);
    
    [self CallPolice:self.lastNativeDate];
    
    NSDictionary *extra = @{
        kATExtraInfoNativeAdSizeKey:[NSValue valueWithCGSize:self.nativeAdSize],
        kATExtraNativeImageSizeKey:kATExtraNativeImageSize690_388,
        kATNativeAdSizeToFitKey:@YES,
        // Start APP
        kATExtraNativeIconImageSizeKey: @(AT_SIZE_72X72),
        kATExtraStartAPPNativeMainImageSizeKey:@(AT_SIZE_1200X628),
    };
    [[ATAdManager sharedManager] loadADWithPlacementID:self.perNativePlacementID extra:extra delegate:self];
}

#pragma mark - show
- (void)showSplahAd{
    
    self.showSplashDate = [NSDate date];
    
    UIWindow *mainWindow = nil;
    if ( @available(iOS 13.0, *) ) {
        mainWindow = [UIApplication sharedApplication].windows.firstObject;
        [mainWindow makeKeyWindow];
    }else {
        mainWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    [[ATAdManager sharedManager] showSplashWithPlacementID:self.perSplashPlacementID scene:@"f5e54970dc84e6" window:mainWindow extra:@{} delegate:self];
    
    NSLog(@"🔥开屏展示之前---%@",self.perSplashPlacementID);
    self.perSplashPlacementID = [self getRandomID:self.splashIDArray placementID:self.perSplashPlacementID];
    NSLog(@"🔥开屏展示之后---%@",self.perSplashPlacementID);
    
}

- (void)showBannerAd{
    
    NSInteger tag = 3333333;
    [[self.view viewWithTag:tag] removeFromSuperview];
    
    ATBannerView *bannerView = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.perBannerPlacementID scene:@"f600938d045dd3"];
    
    NSLog(@"🔥横幅展示之前---%@",self.perBannerPlacementID);
    self.perBannerPlacementID = [self getRandomID:self.bannerIDArray placementID:self.perBannerPlacementID];
    NSLog(@"🔥横幅展示之后---%@",self.perBannerPlacementID);

    if (bannerView != nil) {
        bannerView.delegate = self;
        bannerView.presentingViewController = self;
        bannerView.translatesAutoresizingMaskIntoConstraints = NO;
        bannerView.tag = tag;
        
        self.bannerAdView = [[UIView alloc]init];// bannerView;
        self.bannerAdView.backgroundColor =  randomColor;
        [self.bannerAdView addSubview:bannerView];
        
        [self.view addSubview:self.bannerAdView];
        
        
        CGFloat y = self.nativeAdSize.height + kNavigationBarHeight + 20 + 50;
        
        self.bannerAdView.frame = CGRectMake(0, y, self.bannerAdSize.width, self.bannerAdSize.height);
        
        [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bannerAdView);
        }];
    }
}

- (void)showNativeAd{
    
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    config.ADFrame = CGRectMake(.0f, kNavigationBarHeight + 20, self.nativeAdSize.width, self.nativeAdSize.height);
    
    config.mediaViewFrame = CGRectMake(0, 110, self.nativeAdSize.width, self.nativeAdSize.height - 110.0f);
    config.delegate = self;
    config.sizeToFit = YES;
    config.rootViewController = self;
    config.context = @{
        kATNativeAdConfigurationContextAdOptionsViewFrameKey:[NSValue valueWithCGRect:CGRectMake(CGRectGetWidth(self.view.bounds) - 43.0f, .0f, 43.0f, 18.0f)],
        kATNativeAdConfigurationContextAdLogoViewFrameKey:[NSValue valueWithCGRect:CGRectMake(.0f, .0f, 54.0f, 18.0f)],
        kATNativeAdConfigurationContextNetworkLogoViewFrameKey:[NSValue valueWithCGRect:CGRectMake(CGRectGetWidth(config.ADFrame) - 54.0f, CGRectGetHeight(config.ADFrame) - 18.0f, 54.0f, 18.0f)]
    };
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:self.perNativePlacementID];
    ATNativeSelfRenderView *selfRenderView = [[ATNativeSelfRenderView alloc]initWithOffer:offer];
    
    ATNativeADView *nativeADView = [[ATNativeADView alloc]initWithConfiguration:config currentOffer:offer placementID:self.perNativePlacementID];
    
    [nativeADView registerClickableViewArray:@[selfRenderView.iconImageView,selfRenderView.titleLabel,selfRenderView.textLabel,selfRenderView.ctaLabel,selfRenderView.mainImageView]];
    
    self.nativeAdView  = nativeADView;
    
    self.nativeAdView.backgroundColor = randomColor;
    
    UIView *mediaView = [nativeADView getMediaView];
    
    mediaView.frame =  CGRectMake(0, 110, self.nativeAdSize.width, self.nativeAdSize.height - 110.0f);
    
    mediaView.backgroundColor = randomColor;
    
    [selfRenderView addSubview:mediaView];
    
    
    ATNativePrepareInfo *info = [ATNativePrepareInfo loadPrepareInfo:^(ATNativePrepareInfo * _Nonnull prepareInfo) {
        prepareInfo.textLabel = selfRenderView.textLabel;
        prepareInfo.advertiserLabel = selfRenderView.advertiserLabel;
        prepareInfo.titleLabel = selfRenderView.titleLabel;
        prepareInfo.ratingLabel = selfRenderView.ratingLabel;
        prepareInfo.iconImageView = selfRenderView.iconImageView;
        prepareInfo.mainImageView = selfRenderView.mainImageView;
        prepareInfo.logoImageView = selfRenderView.logoImageView;
        prepareInfo.sponsorImageView = selfRenderView.sponsorImageView;
        prepareInfo.dislikeButton = selfRenderView.dislikeButton;
        prepareInfo.ctaLabel = selfRenderView.ctaLabel;
        prepareInfo.mediaView = mediaView;
    }];
    [nativeADView prepareWithNativePrepareInfo:info];
    
    [offer rendererWithConfiguration:config selfRenderView:selfRenderView nativeADView:nativeADView];
    
    [self.view addSubview:self.nativeAdView];
    
    NSMutableArray *tempArray = [self.nativeIDArray mutableCopy];
    
    if (tempArray.count > 1) {
        [tempArray removeObject:self.perNativePlacementID];
    }
    
    NSLog(@"🔥原生展示之前---%@",self.perNativePlacementID);
    self.perNativePlacementID = [self getRandomID:self.nativeIDArray placementID:self.perNativePlacementID];
    NSLog(@"🔥原生展示之后---%@",self.perNativePlacementID);

}

#pragma mark - remove
- (void)removeBanner{
    
    if (self.bannerAdView && self.bannerAdView.superview) {
        [self.bannerAdView removeFromSuperview];
        self.bannerAdView = nil;
    }
    
}

- (void)removeNative{
    if (self.nativeAdView && self.nativeAdView.superview) {
        [self.nativeAdView removeFromSuperview];
        self.nativeAdView = nil;
    }
}


@end
