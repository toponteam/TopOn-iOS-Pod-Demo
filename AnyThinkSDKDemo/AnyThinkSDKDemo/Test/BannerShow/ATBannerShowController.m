//
//  ATBannerShowController.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/6/27.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATBannerShowController.h"
#import <Masonry/Masonry.h>

@import AnyThinkBanner;

@interface ATBannerShowController ()<ATBannerDelegate>

@property(nonatomic, strong) NSString *placementID;

@property(nonatomic, assign) CGSize adSize;

@property(nonatomic, assign) NSInteger judgeTime;

@end

@implementation ATBannerShowController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.placementID = @"b5bacaccb61c29";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadBanner];
}

#pragma mark - laod
- (void)loadBanner{
    
    self.adSize = CGSizeMake(kScreenW, 80.0f);
    
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:@{
        kATAdLoadingExtraBannerAdSizeKey:[NSValue valueWithCGSize:self.adSize],
        kATAdLoadingExtraBannerSizeAdjustKey:@NO} delegate:self];
}

- (void)showBanner{
    
    ATBannerView *bannerView0 = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.placementID scene:@"f600938d045dd3"];
    
    if (bannerView0) {
        bannerView0.backgroundColor = randomColor;
        bannerView0.delegate = self;
        bannerView0.presentingViewController = self;
        bannerView0.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:bannerView0];
        [bannerView0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.adSize.height));
            make.width.equalTo(@(self.adSize.width));
            make.top.equalTo(self.view).offset(kNavigationBarHeight + 20);
        }];
    }
    
    
    ATBannerView *bannerView1 = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.placementID scene:@"f600938d045dd3"];
    
    if (bannerView1) {
        bannerView1.backgroundColor = randomColor;
        bannerView1.delegate = self;
        bannerView1.presentingViewController = self;
        bannerView1.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:bannerView1];
        [bannerView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.adSize.height));
            make.width.equalTo(@(self.adSize.width));
            make.top.equalTo(bannerView0.mas_bottom).offset(50);
        }];
    }
    
    ATBannerView *bannerView2 = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.placementID scene:@"f600938d045dd3"];
    
    if (bannerView2) {
        bannerView2.backgroundColor = randomColor;
        bannerView2.delegate = self;
        bannerView2.presentingViewController = self;
        bannerView2.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:bannerView2];
        [bannerView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.adSize.height));
            make.width.equalTo(@(self.adSize.width));
            make.top.equalTo(bannerView1.mas_bottom).offset(50);
        }];
    }
    
    ATBannerView *bannerView3 = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.placementID scene:@"f600938d045dd3"];
    
    if (bannerView3) {
        bannerView3.backgroundColor = randomColor;
        bannerView3.delegate = self;
        bannerView3.presentingViewController = self;
        bannerView3.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:bannerView3];
        [bannerView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.adSize.height));
            make.width.equalTo(@(self.adSize.width));
            make.top.equalTo(bannerView2.mas_bottom).offset(50);
        }];
    }

    
    ATBannerView *bannerView4 = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.placementID scene:@"f600938d045dd3"];
    
    if (bannerView4) {
        bannerView4.backgroundColor = randomColor;
        bannerView4.delegate = self;
        bannerView4.presentingViewController = self;
        bannerView4.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:bannerView4];
        [bannerView4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.adSize.height));
            make.width.equalTo(@(self.adSize.width));
            make.top.equalTo(bannerView3.mas_bottom).offset(50);
        }];
    }
    
}

- (void)judgeShow{
    
    NSArray *array = [[ATAdManager sharedManager] getBannerValidAdsForPlacementID:self.placementID];

    if (array.count >= 3 || self.judgeTime >= 5) {
        [self showBanner];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.judgeTime ++;
            [self judgeShow];
        });
    }
}

#pragma mark - delegate
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    
    NSLog(@"🔥---横幅加载成功");
    
    [self judgeShow];
}

- (void)didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    NSLog(@"🔥---横幅加载失败");

    [self loadBanner];
}

- (void)bannerView:(ATBannerView*)bannerView didAutoRefreshWithPlacement:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"🔥---横幅自动刷新成功");

}

- (void)bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"🔥---横幅自动刷新失败");

}

/// BannerView display results
- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSLog(@"🔥---横幅展示成功");

}

/// bannerView click
- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSLog(@"🔥---横幅点击");

}


/// bannerView click the close button
- (void)bannerView:(ATBannerView *)bannerView didTapCloseButtonWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSLog(@"🔥---横幅关闭按钮");

}

/// Whether the bannerView click jump is in the form of Deeplink
/// currently only returns for TopOn Adx advertisements
- (void)bannerView:(ATBannerView *)bannerView didDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success{
    NSLog(@"🔥---横幅DeepLink");

}

@end
