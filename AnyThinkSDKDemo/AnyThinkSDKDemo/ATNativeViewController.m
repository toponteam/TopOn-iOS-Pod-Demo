//
//  ATNativeViewController.m
//  AnyThinkSDKDemo
//
//  Created by Martin Lau on 17/04/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import "ATNativeViewController.h"
#import "MTAutolayoutCategories.h"
#import "ATNativeSelfRenderView.h"



NSString *const kMPPlacement = @"MobPower";
NSString *const kInmobiPlacement = @"Inmobi";
NSString *const kFacebookPlacement = @"Facebook";
NSString *const kFacebookHeaderBiddingPlacement = @"Facebook(Header Bidding)";
NSString *const kAdMobPlacement = @"AdMob";
NSString *const kApplovinPlacement = @"Applovin";
NSString *const kMintegralPlacement = @"Mintegral";
NSString *const kMintegralAdvancedPlacement = @"Mintegral(Advanced)";
NSString *const kMopubPlacementName = @"Mopub";
NSString *const kGDTPlacement = @"GDT";
NSString *const kGDTTemplatePlacement = @"GDT(Template)";
NSString *const kAppnextPlacement = @"Appnext";
NSString *const kTTFeedPlacementName = @"TT(Feed)";
NSString *const kTTDrawPlacementName = @"TT(Draw)";
NSString *const kAllPlacementName = @"All";
NSString *const kNendVideoPlacement = @"Nend(Video)";
NSString *const kSigmobPlacement = @"Sigmob";
NSString *const kKSDrawPlacement = @"KS(Draw)";
NSString *const kGAMPlacement = @"GAM";
NSString *const kOnlineApiPlacement = @"OnlineApi";



static NSString *const kMPPlacementID = @"b5c2084d12aca4";
static NSString *const kPlacement0ID = @"b5ad9ba61dcb39";
static NSString *const kInmobiPlacementID = @"b5b0f553483724";
static NSString *const kMintegralAdvancedPlacementID = @"b5ee1d26cb56ee";
static NSString *const kMintegralPlacementID = @"b5b0f555698607";
static NSString *const kMintegralHeaderBiddingPlacementID = @"b5d1333d023691";
static NSString *const kFacebookPlacementID = @"b5b0f551340ea9";
static NSString *const kFacebookHeaderBiddingPlacementID = @"b5d13342d52304";
static NSString *const kAdMobPlacementID = @"b5b0f55228375a";
static NSString *const kApplovinPlacementID = @"b5b0f554ec9c4e";
static NSString *const kMopubPlacementID = @"b5b0f55624527a";
static NSString *const kGDTPlacementID = @"b5bacac5f73476";
static NSString *const kGDTTemplatePlacementID = @"b5bacac780e03b";
static NSString *const kAppnextPlacementID = @"b5bc7fb2787f1e";
static NSString *const kAllPlacementID = @"b5b0f5663c6e4a";
static NSString *const kTTFeedPlacementID = @"b5c2c6d50e7f44";
static NSString *const kNendPlacementID = @"b5cb96d44c0c5f";
static NSString *const kNendVideoPlacementID = @"b5cb96d5291e93";
static NSString *const kBaiduPlacementID = @"b5d36c4ad68a26";
static NSString *const kKSPlacementID = @"b5e4613e50cbf2";//@"b5e43ac9ca3fc5";
static NSString *const kGAMPlacementID = @"b5f238964f3e6f";
static NSString *const kMyOfferPlacementID = @"b5f33878ee0646";
static NSString *const kSigmobPlacementID = @"b6170cda99de6d";
static NSString *const kKlevinPlacementID = @"b6172985f45143";
static NSString *const kDirectOfferPlacementID = @"b61bfff2c812cb";


//static NSString *const kKSDrawPlcementID = @"b5e4613e50cbf2";
//static NSString *const kTTDrawPlacementID = @"b5c2c6d62b9d65";

#ifdef NATIVE_INTEGRATED
@interface ATNativeViewController()<ATNativeADDelegate>
#else
@interface ATNativeViewController()
#endif
@property(nonatomic, readonly) NSDictionary *placementIDs;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) UIActivityIndicatorView *loadingView;
@property(nonatomic, readonly) UIButton *reloadADButton;
@property(nonatomic, readonly) UIButton *clearAdButton;
@property(nonatomic, readonly) UIButton *showAdButton;
@property(nonatomic, readonly) UILabel *failureTipsLabel;
@property(nonatomic, readonly) UIButton *removeAdButton;
@property(nonatomic, readonly) UIButton *readyButton;
@property(nonatomic, readonly) NSMutableDictionary *numberOfLoadAndCallback;

@property(nonatomic, readwrite) ATNativeADView *adView;

@property(nonatomic, strong) ATNativeAdOffer *nativeAdOffer;
@property(nonatomic, strong) ATNativeADConfiguration *config;

@end
static NSString *const kLoadKey = @"load";
static NSString *const kCallbackKey = @"request";
@implementation ATNativeViewController
#ifdef NATIVE_INTEGRATED
-(instancetype) initWithPlacementName:(NSString*)name {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        _name = name;
        _placementIDs = [ATNativeViewController nativePlacementIDs];
    }
    _numberOfLoadAndCallback = [NSMutableDictionary dictionaryWithContentsOfFile:[ATNativeViewController numberOfLoadPath]];
    if (_numberOfLoadAndCallback == nil) { _numberOfLoadAndCallback = [NSMutableDictionary dictionary]; }
    return self;
}

+(NSDictionary<NSString*, NSString*>*)nativePlacementIDs {
    return @{
             kMPPlacement:kMPPlacementID,
             kMintegralPlacement:kMintegralPlacementID,
             kMintegralAdvancedPlacement:kMintegralAdvancedPlacementID,
             kHeaderBiddingPlacement:kMintegralHeaderBiddingPlacementID,
             kAllPlacementName:kAllPlacementID,
             kInmobiPlacement:kInmobiPlacementID,
             kFacebookPlacement:kFacebookPlacementID,
             kFacebookHeaderBiddingPlacement:kFacebookHeaderBiddingPlacementID,
             kAdMobPlacement:kAdMobPlacementID,
             kMopubPlacementName:kMopubPlacementID,
             kApplovinPlacement:kApplovinPlacementID,
             kGDTPlacement:kGDTPlacementID,
             kGDTTemplatePlacement:kGDTTemplatePlacementID,
             kAppnextPlacement:kAppnextPlacementID,
             kTTFeedPlacementName:kTTFeedPlacementID,
             kNendPlacement:kNendPlacementID,
             kNendVideoPlacement:kNendVideoPlacementID,
             kBaiduPlacement:kBaiduPlacementID,
             kKSPlacement:kKSPlacementID,
             kGAMPlacement:kGAMPlacementID,
             kMyOfferPlacement:kMyOfferPlacementID,
             kSigmobPlacement:kSigmobPlacementID,
             kKlevinPlacement:kKlevinPlacementID,
             kDirectOfferPlacement:kDirectOfferPlacementID
             };
}

+(NSString*)numberOfLoadPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"native_load"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _name;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _reloadADButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reloadADButton addTarget:self action:@selector(reloadADButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_reloadADButton setTitleColor:_reloadADButton.tintColor forState:UIControlStateNormal];
    [_reloadADButton setTitle:@"Reload AD" forState:UIControlStateNormal];
    _reloadADButton.frame = CGRectMake(.0f, CGRectGetMaxY(self.view.bounds) - 100.0f, (CGRectGetWidth(self.view.bounds) - 40) / 2.0f, 60.0f);
    [self.view addSubview:_reloadADButton];
    
    _showAdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showAdButton addTarget:self action:@selector(showAD) forControlEvents:UIControlEventTouchUpInside];
    [_showAdButton setTitleColor:_showAdButton.tintColor forState:UIControlStateNormal];
    [_showAdButton setTitle:@"Show AD" forState:UIControlStateNormal];
    _showAdButton.frame = CGRectMake(CGRectGetMaxX(_reloadADButton.frame) + 40.0f, CGRectGetMinY(_reloadADButton.frame), (CGRectGetWidth(self.view.bounds) - 40) / 2.0f, 60.0f);
    [self.view addSubview:_showAdButton];
    
    _clearAdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearAdButton addTarget:self action:@selector(clearAdButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_clearAdButton setTitleColor:_clearAdButton.tintColor forState:UIControlStateNormal];
    [_clearAdButton setTitle:@"clear cache" forState:UIControlStateNormal];
    _clearAdButton.frame = CGRectMake(.0f, CGRectGetMinY(_reloadADButton.frame) - 20.0f - 60.0f, (CGRectGetWidth(self.view.bounds) - 40) / 2.0f, 60.0f);
    [self.view addSubview:_clearAdButton];
    
    _removeAdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_removeAdButton addTarget:self action:@selector(removeAdButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_removeAdButton setTitleColor:_removeAdButton.tintColor forState:UIControlStateNormal];
    [_removeAdButton setTitle:@"Remove Ad" forState:UIControlStateNormal];
    _removeAdButton.frame = CGRectMake(CGRectGetMaxX(_clearAdButton.frame) + 40.0f, CGRectGetMinY(_clearAdButton.frame), (CGRectGetWidth(self.view.bounds) - 40) / 2.0f, 60.0f);
    [self.view addSubview:_removeAdButton];
    
    _readyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_readyButton addTarget:self action:@selector(readyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_readyButton setTitleColor:_readyButton.tintColor forState:UIControlStateNormal];
    [_readyButton setTitle:@"Ad Ready?" forState:UIControlStateNormal];
    _readyButton.frame = CGRectMake(CGRectGetMinX(_clearAdButton.frame), CGRectGetMinY(_clearAdButton.frame) - 65.0f, (CGRectGetWidth(self.view.bounds) - 40) / 2.0f, 60.0f);
    [self.view addSubview:_readyButton];
    
    _failureTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(.0f, 64.0f, CGRectGetWidth(self.view.bounds), 400.0f)];
    _failureTipsLabel.text = @"Failed to load ad";
    _failureTipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_failureTipsLabel];
    _failureTipsLabel.hidden = YES;
    
    if ([[ATAdManager sharedManager] nativeAdReadyForPlacementID:_placementIDs[_name]]) {
        [self showAD];
    } else {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.center = _failureTipsLabel.center;
        [_loadingView startAnimating];
        [self.view addSubview:_loadingView];
        [self increaseLoad];
        [[ATAdManager sharedManager] loadADWithPlacementID:_placementIDs[_name] extra:@{kATExtraInfoNativeAdTypeKey:@([@{kGDTPlacement:@(ATGDTNativeAdTypeSelfRendering), kGDTTemplatePlacement:@(ATGDTNativeAdTypeTemplate), kMintegralPlacement:@(ATGDTNativeAdTypeSelfRendering)}[_name] integerValue]), kATExtraInfoNativeAdSizeKey:[NSValue valueWithCGSize:CGSizeMake(CGRectGetWidth(self.view.bounds) - 50.0f, 350.0f)], kATExtraNativeImageSizeKey:kATExtraNativeImageSize690_388} delegate:self];
    }
}

-(void) increaseLoad {
    _numberOfLoadAndCallback[kLoadKey] = @([_numberOfLoadAndCallback[kLoadKey] integerValue] + 1);
    [_numberOfLoadAndCallback writeToFile:[ATNativeViewController numberOfLoadPath] atomically:YES];
}

-(void) increaseCallback {
    _numberOfLoadAndCallback[kCallbackKey] = @([_numberOfLoadAndCallback[kCallbackKey] integerValue] + 1);
    [_numberOfLoadAndCallback writeToFile:[ATNativeViewController numberOfLoadPath] atomically:YES];
}

-(void) readyButtonTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[ATAdManager sharedManager] nativeAdReadyForPlacementID:_placementIDs[_name]] ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    
//    5.7.53
    ATCheckLoadModel *model = [[ATAdManager sharedManager] checkNativeLoadStatusForPlacementID:_placementIDs[_name]];
    NSArray *array = [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:_placementIDs[_name]];
    NSLog(@"ValidAds -- %@",array);
}

-(void) removeAdButtonTapped {
    [[self.view viewWithTag:adViewTag] removeFromSuperview];
}

-(void) clearAdButtonTapped {
    [[ATAdManager sharedManager] clearCache];
}

-(void) dealloc {
    NSLog(@"dealloc");
}

static NSInteger adViewTag = 3333;
-(void) reloadADButtonTapped {
    _failureTipsLabel.hidden = YES;
    [self.view addSubview:_loadingView];
    [self increaseLoad];
    [[ATAdManager sharedManager] loadADWithPlacementID:_placementIDs[_name] extra:@{kATExtraInfoNativeAdTypeKey:@([@{kGDTPlacement:@(ATGDTNativeAdTypeSelfRendering), kGDTTemplatePlacement:@(ATGDTNativeAdTypeTemplate)}[_name] integerValue]), kATExtraInfoNativeAdSizeKey:[NSValue valueWithCGSize:CGSizeMake(CGRectGetWidth(self.view.bounds) - 30.0f, 300.0f)], kATExtraNativeImageSizeKey:kATExtraNativeImageSize690_388} delegate:self];
}

-(void) showAD {
    //Remove previously shown ad first.
    [self removeAdButtonTapped];
    
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    config.ADFrame = CGRectMake(0, kNavigationBarHeight, kScreenW, 350);
    config.mediaViewFrame = CGRectMake(0, kNavigationBarHeight + 150.0f, kScreenW, 350 - kNavigationBarHeight - 150);
    config.delegate = self;
    config.sizeToFit = YES;
    config.rootViewController = self;
    config.context = @{
        kATNativeAdConfigurationContextAdOptionsViewFrameKey:[NSValue valueWithCGRect:CGRectMake(CGRectGetWidth(self.view.bounds) - 43.0f, .0f, 43.0f, 18.0f)],
        kATNativeAdConfigurationContextAdLogoViewFrameKey:[NSValue valueWithCGRect:CGRectMake(.0f, .0f, 54.0f, 18.0f)],
        kATNativeAdConfigurationContextNetworkLogoViewFrameKey:[NSValue valueWithCGRect:CGRectMake(CGRectGetWidth(config.ADFrame) - 54.0f, CGRectGetHeight(config.ADFrame) - 18.0f, 54.0f, 18.0f)]
    };

    self.config = config;
    
    self.nativeAdOffer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:_placementIDs[_name] scene:@""];
    
    ATNativeSelfRenderView *selfRenderView = [[ATNativeSelfRenderView alloc]initWithOffer:self.nativeAdOffer];
    
    ATNativeADView *nativeADView = [[ATNativeADView alloc]initWithConfiguration:config currentOffer:self.nativeAdOffer placementID:_placementIDs[_name]];
    
    UIView *mediaView = [nativeADView getMediaView];

    NSMutableArray *array = [@[selfRenderView.iconImageView,selfRenderView.titleLabel,selfRenderView.textLabel,selfRenderView.ctaLabel,selfRenderView.mainImageView] mutableCopy];
    
    if (mediaView) {
        [array addObject:mediaView];
    }
    
    [nativeADView registerClickableViewArray:array];
    
    nativeADView.backgroundColor = randomColor;
    
    selfRenderView.mediaView = mediaView;
    
    [selfRenderView addSubview:mediaView];
    
    [mediaView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(selfRenderView);
            make.top.equalTo(selfRenderView.mainImageView.mas_top);
    }];

    self.adView = nativeADView;
    
    selfRenderView.backgroundColor = randomColor;
    
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
        
    [self.nativeAdOffer rendererWithConfiguration:config selfRenderView:selfRenderView nativeADView:nativeADView];
    
    self.adView.tag = adViewTag;
    
    [self.view addSubview:self.adView];
    if (self.adView == nil) NSLog(@"retrive ad view failed");
    

}
    
-(void) didStartPlayingVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID {
    NSLog(@"ATNativeViewController:: didStartPlayingVideoInAdView:placementID:%@", placementID);
}

-(void) didEndPlayingVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID {
    NSLog(@"ATNativeViewController:: didEndPlayingVideoInAdView:placementID:%@", placementID);
}

-(void) didClickNativeAdInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID {
    NSLog(@"ATNativeViewController:: didClickNativeAdInAdView:placementID:%@", placementID);
}

-(void) didShowNativeAdInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID {
    NSLog(@"ATNativeViewController:: didShowNativeAdInAdView:placementID:%@", placementID);
    adView.mainImageView.hidden = [adView isVideoContents];
}

-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    [self increaseCallback];
    NSLog(@"ATNativeViewController:: didFinishLoadingADWithPlacementID:%@", placementID);
    [_loadingView removeFromSuperview];
    _failureTipsLabel.hidden = YES;
    if ([self.view viewWithTag:adViewTag] == nil) {
        [self showAD];
    }
}

-(void) didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    [self increaseCallback];
    NSLog(@"ATNativeViewController:: didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [_loadingView removeFromSuperview];
    _failureTipsLabel.hidden = NO;
}

-(void) didEnterFullScreenVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID {
    NSLog(@"ATNativeViewController:: didEnterFullScreenVideoInAdView:placementID:%@", placementID);
}

-(void) didExitFullScreenVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID {
    NSLog(@"ATNativeViewController:: didExitFullScreenVideoInAdView:placementID:%@", placementID);
}
#pragma mark - delegate with extra
-(void) didStartPlayingVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didStartPlayingVideoInAdView:placementID:%@with extra: %@", placementID,extra);
}

-(void) didEndPlayingVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didEndPlayingVideoInAdView:placementID:%@", placementID);
}

-(void) didClickNativeAdInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didClickNativeAdInAdView:placementID:%@ with extra: %@", placementID,extra);
}

- (void) didDeepLinkOrJumpInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATNativeViewController:: didDeepLinkOrJumpInAdView:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
}

-(void) didShowNativeAdInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didShowNativeAdInAdView:placementID:%@ with extra: %@", placementID,extra);
    adView.mainImageView.hidden = [adView isVideoContents];
}

-(void) didEnterFullScreenVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didEnterFullScreenVideoInAdView:placementID:%@", placementID);
}

-(void) didExitFullScreenVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didExitFullScreenVideoInAdView:placementID:%@", placementID);
}

-(void) didTapCloseButtonInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra {
    [self.adView removeFromSuperview];
    self.adView = nil;
    NSLog(@"ATNativeViewController:: didTapCloseButtonInAdView:placementID:%@ extra:%@", placementID, extra);
}

- (void)didCloseDetailInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: didCloseDetailInAdView:placementID:%@ extra:%@", placementID, extra);

}

#endif
@end
