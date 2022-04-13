//
//  ATNativeShowViewController.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/7.
//

#import "ATNativeShowViewController.h"
#import <AnyThinkNative/ATNativeADView.h>
#import "ATNativeRenderView.h"

@interface ATNativeShowViewController () <ATAdLoadingDelegate, ATNativeADDelegate>

@property (nonatomic, weak) DMADView *adView;

@property (nonatomic, copy) NSString *placementID;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *voiceChange;

@property (nonatomic, strong) UIButton *voiceRestart;

@property (nonatomic, strong) UIButton *voicePause;

@property (nonatomic, strong) UIButton *voicePlay;

@property(nonatomic, assign) BOOL mute;

@property(nonatomic, assign) BOOL isPlaying;

@end

@implementation ATNativeShowViewController

- (instancetype)initWithAdView:(DMADView *)adView placementID:(NSString *)placementID
{
    if (self = [super init]) {
        _adView = adView;
        _placementID = placementID;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI
{
    [self.view addSubview:self.voiceChange];
    [self.view addSubview:self.voiceRestart];
    [self.view addSubview:self.voicePause];
    [self.view addSubview:self.voicePlay];
    [self.view addSubview:self.adView];
    
//    [self.view addSubview:self.closeBtn];

    
    [self.voicePlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
        make.bottom.equalTo(self.view.mas_bottom).offset(-kScaleW(26));
    }];
    
    [self.voiceChange mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
        make.bottom.equalTo(self.voicePlay.mas_top).offset(-kScaleW(26));
    }];
    
    [self.voiceRestart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.voiceChange.mas_right).offset(kScaleW(26));
        make.bottom.equalTo(self.voiceChange.mas_bottom);
    }];
    
    [self.voicePause mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo((kScreenW - kScaleW(26) * 4) / 6);
        make.left.equalTo(self.voiceRestart.mas_right).offset(kScaleW(26));
        make.bottom.equalTo(self.voiceChange.mas_bottom);
    }];
}

- (void)showAd
{
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    config.ADFrame = CGRectMake(.0f, 100.0f, CGRectGetWidth(self.view.bounds), 350.0f);
    config.mediaViewFrame = CGRectMake(0, 120.0f, CGRectGetWidth(self.view.bounds), 350.0f - 120.0f);
    config.delegate = self;
    config.sizeToFit = YES;
    // 临时,只在 demo 用.
    config.renderingViewClass = [DMADView class];
    config.rootViewController = self;
    config.context = @{
        
        kATNativeAdConfigurationContextAdOptionsViewFrameKey:[NSValue valueWithCGRect:CGRectMake(CGRectGetWidth(self.view.bounds) - 43.0f, .0f, 43.0f, 18.0f)],
        
        kATNativeAdConfigurationContextAdLogoViewFrameKey:[NSValue valueWithCGRect:CGRectMake(.0f, .0f, 54.0f, 18.0f)],
        
        kATNativeAdConfigurationContextNetworkLogoViewFrameKey:[NSValue valueWithCGRect:CGRectMake(CGRectGetWidth(config.ADFrame) - 54.0f, CGRectGetHeight(config.ADFrame) - 18.0f, 54.0f, 18.0f)]
        
    };
    
    self.adView = [[ATAdManager sharedManager] retriveAdViewWithPlacementID:self.placementID configuration:config scene:@"f600938967feb5"];
    if (self.adView == nil) {
        NSLog(@"show failed");
        return;
    }
//    self.adView.tag = adViewTag;
    [self.view addSubview:self.adView];

    ATNativeADView *tempView = self.adView;
    if ([self.adView isKindOfClass:[ATNativeADView class]] == NO) {
        tempView = self.adView.subviews.firstObject;
    }
    NSLog(@"获取广告平台id：%ld",tempView.networkFirmID);
}

#pragma mark - delegate with extra
-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"ATNativeViewController:: didFinishLoadingADWithPlacementID:%@", placementID);
    
    [self showAd];
}

-(void) didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"ATNativeViewController:: didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    
//    [self.view makeToast:[NSString stringWithFormat:@"ATNativeViewController:: didFailToLoadADWithPlacementID:%@ error:%@", placementID, error]];
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
    NSLog(@"ATNativeViewController:: didTapCloseButtonInAdView:placementID:%@ extra:%@", placementID, extra);
    
    [self.adView removeFromSuperview];
    self.adView = nil;
    adView = nil;
}

- (void)didCloseDetailInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: didCloseDetailInAdView:placementID:%@ extra:%@", placementID, extra);
}

-(void) nativeAdDidClickInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: nativeAdDidClickInAdViewForPlacementID:placementID:%@ extra:%@", placementID, extra);
}

-(void) nativeAdDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success {
    NSLog(@"ATNativeViewController:: nativeAdDeepLinkOrJumpForPlacementID:placementID:%@ extra:%@", placementID, extra);
}

-(void) nativeAdDidStartPlayingVideoInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: nativeAdDidStartPlayingVideoInAdViewForPlacementID:placementID:%@ extra:%@", placementID, extra);
}

-(void) nativeAdDidEndPlayingVideoInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: nativeAdDidEndPlayingVideoInAdViewForPlacementID:placementID:%@ extra:%@", placementID, extra);
}

-(void) nativeAdDidEnterFullScreenVideoInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: nativeAdDidEnterFullScreenVideoInAdViewForPlacementID:placementID:%@ extra:%@", placementID, extra);
}

-(void) nativeAdDidExitFullScreenVideoInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: nativeAdDidExitFullScreenVideoInAdViewForPlacementID:placementID:%@ extra:%@", placementID, extra);
}

-(void) nativeAdDidTapCloseButtonInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: nativeAdDidTapCloseButtonInAdViewForPlacementID:placementID:%@ extra:%@", placementID, extra);
}


#pragma mark - Action
- (void)clickClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickChange
{
    NSLog(@"ATNativeViewController:getNativeAdType:%ld,getCurrentNativeAdRenderType:%ld",[self.adView getNativeAdType],[self.adView getCurrentNativeAdRenderType]);
    [self.adView muteEnable:self.mute];
    self.mute = !self.mute;
}

- (void)clickRestart
{
    [self.adView removeFromSuperview];
    self.adView = nil;
    
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:@{} delegate:self];
}

- (void)clickPause
{
    NSLog(@"ATNativeViewController:videoDuration:%f,videoPlayTime:%f",[self.adView videoDuration],[self.adView videoPlayTime]);
    if (self.isPlaying) {
        [self.adView videoPause];
        self.isPlaying = NO;
    }
}

- (void)clickPlay
{
    NSLog(@"ATNativeViewController:videoDuration:%f,videoPlayTime:%f",[self.adView videoDuration],[self.adView videoPlayTime]);
    if (!self.isPlaying) {
        [self.adView videoPlay];
        self.isPlaying = YES;
    }
}

#pragma mark - lazy
- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScaleW(30), kStatusBarHeight + kScaleW(30), kScaleW(50), kScaleW(50))];
        [_closeBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)voiceChange
{
    if (!_voiceChange) {
        _voiceChange = [[UIButton alloc] init];
        _voiceChange.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voiceChange.layer.borderWidth = kScaleW(3);
        [_voiceChange setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voiceChange setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voiceChange setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voiceChange setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voiceChange.layer.masksToBounds = YES;
        _voiceChange.layer.cornerRadius = 5;
        [_voiceChange setTitle:@"Voice Change" forState:UIControlStateNormal];
        _voiceChange.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voiceChange addTarget:self action:@selector(clickChange) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceChange;
}

- (UIButton *)voiceRestart
{
    if (!_voiceRestart) {
        _voiceRestart = [[UIButton alloc] init];
        _voiceRestart.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voiceRestart.layer.borderWidth = kScaleW(3);
        [_voiceRestart setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voiceRestart setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voiceRestart setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voiceRestart setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voiceRestart.layer.masksToBounds = YES;
        _voiceRestart.layer.cornerRadius = 5;
        [_voiceRestart setTitle:@"Voice Restart" forState:UIControlStateNormal];
        _voiceRestart.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voiceRestart addTarget:self action:@selector(clickRestart) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceRestart;
}

- (UIButton *)voicePause
{
    if (!_voicePause) {
        _voicePause = [[UIButton alloc] init];
        _voicePause.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voicePause.layer.borderWidth = kScaleW(3);
        [_voicePause setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voicePause setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voicePause setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voicePause setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voicePause.layer.masksToBounds = YES;
        _voicePause.layer.cornerRadius = 5;
        [_voicePause setTitle:@"Voice Pause" forState:UIControlStateNormal];
        _voicePause.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voicePause addTarget:self action:@selector(clickPause) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voicePause;
}

- (UIButton *)voicePlay
{
    if (!_voicePlay) {
        _voicePlay = [[UIButton alloc] init];
        _voicePlay.layer.borderColor = kRGB(73, 109, 255).CGColor;
        _voicePlay.layer.borderWidth = kScaleW(3);
        [_voicePlay setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_voicePlay setTitleColor:kRGB(73, 109, 255) forState:UIControlStateNormal];
        [_voicePlay setBackgroundImage:[self imageWithColor:kRGB(73, 109, 255)] forState:UIControlStateHighlighted];
        [_voicePlay setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _voicePlay.layer.masksToBounds = YES;
        _voicePlay.layer.cornerRadius = 5;
        [_voicePlay setTitle:@"Voice Progress" forState:UIControlStateNormal];
        _voicePlay.titleLabel.font = [UIFont systemFontOfSize:14];
        [_voicePlay addTarget:self action:@selector(clickPlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voicePlay;
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
@end
