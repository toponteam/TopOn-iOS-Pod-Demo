//
//  ATNativeListViewController.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/6/30.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATNativeListViewController.h"
#import "ATNaviewListAdCell.h"
#import "ATNativeListOtherCell.h"
#import "ATNativeSelfRenderView.h"
#import "ATDemoOfferAdMode.h"

@import AnyThinkNative;

@interface ATNativeListViewController ()<UITableViewDelegate,UITableViewDataSource,ATNativeADDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *dataSourceArray;

@property(nonatomic, strong) NSString *placementID;



@end

@implementation ATNativeListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    
    [self setLayout];
    
    [self loadNative];
}

#pragma mark - init
- (void)setUI{
    
    self.placementID = @"b5b0f5663c6e4a";

    self.view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.tableView];
    
}

- (void)setLayout{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

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
}

#pragma mark - data center

- (void)setData{
    
    NSArray *array = [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:self.placementID];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    if (array.count) {
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:self.placementID];
            if (offer) {
                ATDemoOfferAdMode *offerModel = [[ATDemoOfferAdMode alloc]init];
                offerModel.nativeADView = [self getNativeADView:self.placementID];
                offerModel.offer = offer;
                offerModel.isNativeAd = YES;
                [tempArray addObject:offerModel];
            }
        }];
    }
    
    for (int i = 0; i < 3; i ++) {
        ATDemoOfferAdMode *offerModel = [[ATDemoOfferAdMode alloc]init];
        offerModel.isNativeAd = NO;
        [tempArray addObject:offerModel];
    }
    
    [self.dataSourceArray addObjectsFromArray:[self sortedRandomArrayByArray:tempArray]];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 350;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ATDemoOfferAdMode *offerMode = self.dataSourceArray[indexPath.row];
    
    
    if (offerMode.isNativeAd) {
        ATNaviewListAdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATNaviewListAdCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.adView = offerMode.nativeADView;
        cell.backgroundColor = randomColor;
        return cell;
    }else{

        ATNativeListOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ATNativeListOtherCellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate



#pragma mark - Ad Delegate
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"🔥---原生加载成功");
    [self setData];
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
#pragma mark - private

- (ATNativeADView *)getNativeADView:(NSString *)placementID{
    
    ATNativeADConfiguration *config = [self getNativeADConfiguration];
    
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:placementID];
    ATNativeSelfRenderView *selfRenderView = [self getSelfRenderViewOffer:offer];
    ATNativeADView *nativeADView = [self getNativeADView:config offer:offer selfRenderView:selfRenderView];
    
    [self prepareWithNativePrepareInfo:selfRenderView nativeADView:nativeADView];

    [offer rendererWithConfiguration:config selfRenderView:selfRenderView nativeADView:nativeADView];
    
    return nativeADView;
}

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




//对数组随机排序
- (NSMutableArray *)sortedRandomArrayByArray:(NSMutableArray *)array{
    
    NSMutableArray *randomArray = [[NSMutableArray alloc]init];
    while (randomArray.count != array.count) {
        int x = arc4random() % array.count;
        id obj = array[x];
        if(![randomArray containsObject:obj]){
            [randomArray addObject:obj];
        }
    }
    return randomArray;
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView registerNib:[UINib nibWithNibName:@"ATNativeListOtherCell" bundle:nil] forCellReuseIdentifier:@"ATNativeListOtherCellID"];
        [self.tableView registerNib:[UINib nibWithNibName:@"ATNaviewListAdCell" bundle:nil] forCellReuseIdentifier:@"ATNaviewListAdCellID"];
    }
    return _tableView;
}

- (NSMutableArray *)dataSourceArray {

    if (_dataSourceArray) return _dataSourceArray;

    NSMutableArray *dataSourceArray = [NSMutableArray new];

    return _dataSourceArray = dataSourceArray;
}

@end
