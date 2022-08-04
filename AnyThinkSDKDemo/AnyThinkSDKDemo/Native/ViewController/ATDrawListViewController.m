//
//  ATDrawListViewController.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/26/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATDrawListViewController.h"
#import <AnyThinkNative/AnyThinkNative.h>
#import "ATDrawListAdCell.h"
#import "ATDrawListOtherCell.h"
#import "ATNativeSelfRenderView.h"
#import "ATDemoOfferAdMode.h"
#import "MJRefresh.h"

@interface ATDrawListViewController ()<UITableViewDelegate,UITableViewDataSource,ATNativeADDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataSourceArray;

@property(nonatomic, strong) NSString *placementID;

@end

@implementation ATDrawListViewController

#pragma mark - dealloc
-(void)dealloc {
    NSLog(@"ATDrawListViewController dealloc");
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    // CSJ_Draw = b62b41eec64f1e
    // Kuaishou_Draw = b62b41c8313009
    self.placementID = @"b62b41eec64f1e";
    
    [self setUI];
    [self footerRefresh];
}

#pragma mark - init
- (void)setUI {
    self.view.backgroundColor = [UIColor blackColor];

#if defined(__IPHONE_11_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
    if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.tableView.estimatedRowHeight = 0;
            self.tableView.estimatedSectionFooterHeight = 0;
            self.tableView.estimatedSectionHeaderHeight = 0;
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
#else
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, kNavigationBarHeight, 50, 50);
    [btn setImage:[UIImage imageNamed:@"returnImage"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
}

- (void)closeVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadNativeAd {
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:nil delegate:self];
}

- (void)footerRefresh{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upFreshLoadMoreData)];
    [self.tableView.mj_footer beginRefreshing];
}

- (void)upFreshLoadMoreData {
    [self loadNativeAd];
}

#pragma mark - data center
- (void)setDataWithRequest:(BOOL)isSuccess {
    NSMutableArray *dataSources = [self.dataSourceArray mutableCopy];
    
    if (isSuccess) {
        ATNativeAdOffer *offer = [self getOfferAndLoadNext];
        if (offer) {
            ATDemoOfferAdMode *offerModel = [[ATDemoOfferAdMode alloc] init];
            offerModel.nativeADView = [self getNativeADView:self.placementID nativeAdOffer:offer];
            offerModel.offer = offer;
            offerModel.isNativeAd = YES;
            [dataSources addObject:offerModel];
        }
    }
    
    for (int i = 0; i < 3; i ++) {
        ATDemoOfferAdMode *offerModel1 = [[ATDemoOfferAdMode alloc] init];
        offerModel1.isNativeAd = NO;
        offerModel1.drawVideoUrlStr = [NSString stringWithFormat:@"testvideo%d", i];
        [dataSources addObject:offerModel1];
    }
    
    self.dataSourceArray = [dataSources copy];
    [self.tableView reloadData];
}

// 获取广告offer对象，同时请求新的广告
- (ATNativeAdOffer *)getOfferAndLoadNext {
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:self.placementID];
    // load next
    [self loadNativeAd];
    return offer;
}

#pragma mark - private
- (ATNativeADView *)getNativeADView:(NSString *)placementID nativeAdOffer:(ATNativeAdOffer *)offer{
    
    ATNativeADConfiguration *config = [self getNativeADConfiguration];
    ATNativeSelfRenderView *selfRenderView = [self getSelfRenderViewOffer:offer];
    ATNativeADView *nativeADView = [self getNativeADView:config offer:offer selfRenderView:selfRenderView];
    
    [self prepareWithNativePrepareInfo:selfRenderView nativeADView:nativeADView];

    [offer rendererWithConfiguration:config selfRenderView:selfRenderView nativeADView:nativeADView];
    
    return nativeADView;
}

- (ATNativeADConfiguration *)getNativeADConfiguration{
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    config.ADFrame = CGRectMake(0, 0, kScreenW, kScreenH);
    config.delegate = self;
    config.rootViewController = self;
    return config;
}

- (ATNativeSelfRenderView *)getSelfRenderViewOffer:(ATNativeAdOffer *)offer{
    
    ATNativeSelfRenderView *selfRenderView = [[ATNativeSelfRenderView alloc] initWithOffer:offer];
 
    selfRenderView.backgroundColor = randomColor;
    
    return selfRenderView;
}

- (ATNativeADView *)getNativeADView:(ATNativeADConfiguration *)config offer:(ATNativeAdOffer *)offer selfRenderView:(ATNativeSelfRenderView *)selfRenderView{
    
    ATNativeADView *nativeADView = [[ATNativeADView alloc]initWithConfiguration:config currentOffer:offer placementID:self.placementID];
    
    UIView *mediaView = [nativeADView getMediaView];

    NSMutableArray *array = [@[selfRenderView.iconImageView,selfRenderView.titleLabel,selfRenderView.textLabel,selfRenderView.ctaLabel,selfRenderView.mainImageView] mutableCopy];
    
    if (mediaView) {
        mediaView.frame = CGRectMake(0, kNavigationBarHeight + 150.0f, kScreenW, kScreenH - 150);
        [selfRenderView addSubview:mediaView];
        [array addObject:mediaView];
    }
    [nativeADView registerClickableViewArray:array];
    
    [selfRenderView addSubview:nativeADView.videoAdView];
    [selfRenderView addSubview:nativeADView.dislikeDrawButton];
    [selfRenderView addSubview:nativeADView.adLabel];
    [selfRenderView addSubview:nativeADView.logoImageView];
    [selfRenderView addSubview:nativeADView.logoADImageView];
    
    nativeADView.videoAdView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    
    nativeADView.dislikeDrawButton.frame = CGRectMake(kScreenW - 50, kNavigationBarHeight + 80.0f, 50,50);
    
    nativeADView.adLabel.frame = CGRectMake(kScreenW - 50, kNavigationBarHeight + 150.0f, 50, 50);
    
    nativeADView.logoImageView.frame = CGRectMake(kScreenW - 50, kNavigationBarHeight + 200.0f, 50, 50);
    nativeADView.logoADImageView.frame = CGRectMake(kScreenW - 50, kNavigationBarHeight + 250.0f, 50, 50);
    
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScreenH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ATDemoOfferAdMode *offerMode = self.dataSourceArray[indexPath.row];
    
    if (offerMode.isNativeAd) {
        
        ATDrawListAdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATDrawListAdCellID"];
        if (cell == nil) {
            cell = [[ATDrawListAdCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ATDrawListAdCellID"];
        }

        cell.drawAdView = offerMode.nativeADView;

        cell.backgroundColor = randomColor;
        return cell;
    }else{
        ATDrawListOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATDrawListOtherCellID"];
        return cell;
    }
}

#pragma mark - Ad Delegate
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"🔥---原生加载成功");
    if (self.tableView.mj_footer.refreshing == YES) {
        [self.tableView.mj_footer endRefreshing];
        [self setDataWithRequest:YES];
    }
}

- (void)didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    NSLog(@"🔥---原生加载失败");
    if (self.tableView.mj_footer.refreshing == YES) {
        [self.tableView.mj_footer endRefreshing];
        [self setDataWithRequest:NO];
    }
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

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.pagingEnabled = YES;
        _tableView.scrollsToTop = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor blackColor];
        [_tableView registerNib:[UINib nibWithNibName:@"ATDrawListOtherCell" bundle:nil] forCellReuseIdentifier:@"ATDrawListOtherCellID"];
        [_tableView registerNib:[UINib nibWithNibName:@"ATDrawListAdCell" bundle:nil] forCellReuseIdentifier:@"ATDrawListAdCellID"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceArray {

    if (_dataSourceArray) return _dataSourceArray;

    NSMutableArray *dataSourceArray = [NSMutableArray new];

    return _dataSourceArray = dataSourceArray;
}

@end
