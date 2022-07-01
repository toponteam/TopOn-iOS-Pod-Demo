//
//  ATNativeShowController.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/6/27.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATNativeShowController.h"
#import <ZYGCDTimer.h>
#import "ATNativeSelfRenderView.h"
#import <Masonry/Masonry.h>
#import <ZYGCDTimer.h>


@import AnyThinkNative;

@interface ATNativeShowController ()<ATNativeADDelegate>

@property(nonatomic, strong) NSString *placementID;

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UIView *contentView;

@property(nonatomic, strong) ZYGCDTimer *checkLoadStatusTimer;

@property(nonatomic, strong) NSString *tempPlacementID0;

@property(nonatomic, strong) NSString *tempPlacementID1;


@end

@implementation ATNativeShowController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self setTimer];
    [self setLauout];
    [self loadNative];
}
#pragma mark - init
- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.placementID = @"b5b0f5663c6e4a";
    
    self.tempPlacementID0 = @"b5c2c6d50e7f44";
    self.tempPlacementID1 = @"b5bacac5f73476";

    self.scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];

    [self.scrollView addSubview:self.contentView];
    
}

- (void)setLauout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.scrollView);
          make.width.equalTo(self.scrollView);
      }];
}

- (void)setTimer{
    self.checkLoadStatusTimer = [ZYGCDTimer timerWithTimeInterval:10 target:self selector:@selector(checkLoadStatus) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
    [self.checkLoadStatusTimer fire];
}

#pragma mark - timer
- (void)checkLoadStatus{
    
    [self judgeShow];
}

- (void)judgeShow{
    
    NSArray *array = [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:self.placementID];

    if (array.count) {
        
        [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

        NSMutableArray *viewArray = [NSMutableArray array];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ATNativeADView *adView = [self getNativeADView:self.placementID];
            if (adView) {
                [viewArray addObject:adView];
            }
        }];
        
        [self setLayoutArray:viewArray];
        
        [self loadNative];
        
    }else{
        [self loadNative];
    }
}

#pragma mark - load

- (void)loadNative{
    
    CGSize size = CGSizeMake(kScreenW, 350);
    
    NSDictionary *extra = @{
        kATExtraInfoNativeAdSizeKey:[NSValue valueWithCGSize:size],
        kATExtraNativeImageSizeKey:kATExtraNativeImageSize690_388,
        kATNativeAdSizeToFitKey:@YES,
        // Start APP
        kATExtraNativeIconImageSizeKey: @(AT_SIZE_72X72),
        kATExtraStartAPPNativeMainImageSizeKey:@(AT_SIZE_1200X628),
    };
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:extra delegate:self];
    
    
    [[ATAdManager sharedManager] loadADWithPlacementID:self.tempPlacementID0 extra:extra delegate:self];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:self.tempPlacementID1 extra:extra delegate:self];
    
}

- (ATNativeADView *)getNativeADView:(NSString *)placementID{
    
    ATNativeADConfiguration *config = [self getNativeADConfiguration];
    
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:placementID];
    ATNativeSelfRenderView *selfRenderView = [self getSelfRenderViewOffer:offer];
    ATNativeADView *nativeADView = [self getNativeADView:config offer:offer selfRenderView:selfRenderView];
    
    [self prepareWithNativePrepareInfo:selfRenderView nativeADView:nativeADView];

    [offer rendererWithConfiguration:config selfRenderView:selfRenderView nativeADView:nativeADView];

    [self.contentView addSubview:nativeADView];
    
    return nativeADView;
}

- (void)setLayoutArray:(NSArray <ATNativeADView *> *)layoutView{
    
    __block ATNativeADView *lastView = nil;
    
    [layoutView enumerateObjectsUsingBlock:^(ATNativeADView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(50);
                make.width.equalTo(@kScreenW);
                make.height.equalTo(@350);
            }];
            
        }else if (idx == layoutView.count - 1){

            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(50);
                make.width.equalTo(@kScreenW);
                make.height.equalTo(@350);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-50);
            }];
            
        }else{

            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(50);
                make.width.equalTo(@kScreenW);
                make.height.equalTo(@350);
            }];
        }
        
        lastView = obj;
    }];
}

#pragma mark - private
- (ATNativeADConfiguration *)getNativeADConfiguration{
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    config.ADFrame = CGRectMake(0, kNavigationBarHeight, kScreenW, 350);
    config.mediaViewFrame = CGRectMake(0, kNavigationBarHeight + 150.0f, kScreenW, 350 - kNavigationBarHeight - 150);
    
    config.delegate = self;
    config.sizeToFit = YES;
    config.rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    config.context = @{
        kATNativeAdConfigurationContextAdOptionsViewFrameKey:[NSValue valueWithCGRect:CGRectMake(CGRectGetWidth(self.view.bounds) - 43.0f, .0f, 43.0f, 18.0f)],
        kATNativeAdConfigurationContextAdLogoViewFrameKey:[NSValue valueWithCGRect:CGRectMake(.0f, .0f, 54.0f, 18.0f)],
        kATNativeAdConfigurationContextNetworkLogoViewFrameKey:[NSValue valueWithCGRect:CGRectMake(CGRectGetWidth(config.ADFrame) - 54.0f, CGRectGetHeight(config.ADFrame) - 18.0f, 54.0f, 18.0f)]
    };
    return config;
}

- (ATNativeSelfRenderView *)getSelfRenderViewOffer:(ATNativeAdOffer *)offer{
    
    ATNativeSelfRenderView *selfRenderView = [[ATNativeSelfRenderView alloc]initWithOffer:offer];
 
    selfRenderView.backgroundColor = randomColor;
    
    return selfRenderView;
}

- (ATNativeADView *)getNativeADView:(ATNativeADConfiguration *)config offer:(ATNativeAdOffer *)offer selfRenderView:(ATNativeSelfRenderView *)selfRenderView{
    
    ATNativeADView *nativeADView = [[ATNativeADView alloc]initWithConfiguration:config currentOffer:offer placementID:self.placementID];
    
    UIView *mediaView = [nativeADView getMediaView];

    
    NSMutableArray *array = [@[selfRenderView.iconImageView,selfRenderView.titleLabel,selfRenderView.textLabel,selfRenderView.ctaLabel,selfRenderView.mainImageView] mutableCopy];
    
    if (mediaView) {
        [array addObject:mediaView];
    }
    
    [nativeADView registerClickableViewArray:array];
    
    nativeADView.backgroundColor = randomColor;

    mediaView.backgroundColor = [UIColor redColor];
    
    selfRenderView.mediaView = mediaView;
    
    [selfRenderView addSubview:mediaView];
    
    [mediaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(selfRenderView);
        make.top.equalTo(selfRenderView.mainImageView.mas_top);
    }];
    
    return nativeADView;
}

- (void)prepareWithNativePrepareInfo:(ATNativeSelfRenderView *)selfRenderView nativeADView:(ATNativeADView *)nativeADView{
    
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
        prepareInfo.mediaView = selfRenderView.mediaView;
    }];
    
    [nativeADView prepareWithNativePrepareInfo:info];
}

#pragma mark - delegate
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"🔥---原生加载成功");
    
    if ([placementID isEqualToString:self.tempPlacementID0] || [placementID isEqualToString:self.tempPlacementID1]) {
        
        NSArray *array = [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:placementID];
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:placementID];
        }];
    }
}

- (void)didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    NSLog(@"🔥---原生加载失败");
}

/// Native ads displayed successfully
- (void)didShowNativeAdInAdView:(ATNativeADView *)adView
                    placementID:(NSString *)placementID
                          extra:(NSDictionary *)extra{
    NSLog(@"🔥---原生展示成功");

}

/// Native ad click
- (void)didClickNativeAdInAdView:(ATNativeADView *)adView
                     placementID:(NSString *)placementID
                           extra:(NSDictionary *)extra{
    NSLog(@"🔥---原生点击");

}

/// Native video ad starts playing
- (void)didStartPlayingVideoInAdView:(ATNativeADView *)adView
                         placementID:(NSString *)placementID
                               extra:(NSDictionary *)extra{
    NSLog(@"🔥---原生开始播放视频");

}

/// Native video ad ends playing
- (void)didEndPlayingVideoInAdView:(ATNativeADView *)adView
                       placementID:(NSString *)placementID
                             extra:(NSDictionary *)extra{
    NSLog(@"🔥---原生结束播放视频");

}

/// Native enters full screen video ads
- (void)didEnterFullScreenVideoInAdView:(ATNativeADView *)adView
                            placementID:(NSString *)placementID
                                  extra:(NSDictionary *)extra{
    NSLog(@"🔥---原生--EnterFullScreen");

}

/// Native exit full screen video ad
- (void)didExitFullScreenVideoInAdView:(ATNativeADView *)adView
                           placementID:(NSString *)placementID
                                 extra:(NSDictionary *)extra{
    NSLog(@"🔥---原生--ExitFullScreen");

    
}

/// Native ad close button cliecked
- (void)didTapCloseButtonInAdView:(ATNativeADView *)adView
                      placementID:(NSString *)placementID
                            extra:(NSDictionary *)extra{
    NSLog(@"🔥---原生--TapCloseButton");

}

/// Native draw ad load successfully
- (void)didLoadSuccessDrawWith:(NSArray*)views
                   placementID:(NSString *)placementID
                         extra:(NSDictionary *)extra{
    NSLog(@"🔥---原生--Draw成功");

    
}

/// Whether the click jump of Native ads is in the form of Deeplink
/// currently only returns for TopOn Adx ads
- (void)didDeepLinkOrJumpInAdView:(ATNativeADView *)adView
                      placementID:(NSString *)placementID
                            extra:(NSDictionary*)extra
                           result:(BOOL)success{
    NSLog(@"🔥---原生--DeepLink");
}

/// Native ads click to close the details page
/// v5.7.47+
- (void)didCloseDetailInAdView:(ATNativeADView *)adView
                   placementID:(NSString *)placementID
                         extra:(NSDictionary *)extra{
    NSLog(@"🔥---原生--关闭详情页");
}


@end
