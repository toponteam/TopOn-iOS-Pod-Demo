//
//  ATNativeViewController.m
//  AnyThinkSDKDemo
//
//  Created by Martin Lau on 17/04/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import "ATNativeViewController.h"
#import "MTAutolayoutCategories.h"
#import "ATADFootView.h"
#import "ATModelButton.h"
#import "ATNativeMessageStreamViewController.h"
#import "ATDrawViewController.h"
#import "ATNativeShowViewController.h"
#import "ATDrawViewController.h"

#import "ATMenuView.h"
#import "ATSuspendedButton.h"

NSString *const kMPPlacement = @"MobPower";
NSString *const kInmobiPlacement = @"Inmobi";
NSString *const kFacebookPlacement = @"Facebook";
NSString *const kFacebookHeaderBiddingPlacement = @"Facebook(Header Bidding)";
NSString *const kAdMobPlacement = @"AdMob";
NSString *const kApplovinPlacement = @"Applovin";
NSString *const kMintegralPlacement = @"Mintegral";
NSString *const kMintegralAdvancedPlacement = @"Mintegral(Advanced)";
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
@property (nonatomic, strong) ATADFootView *footView;

@property (nonatomic, strong) ATModelButton *nativeBtn;

@property (nonatomic, strong) ATModelButton *drawBtn;

@property (nonatomic, strong) ATModelButton *preRollBtn;

@property (nonatomic, strong) ATMenuView *menuView;

@property (nonatomic, strong) UITextView *textView;

@property(nonatomic) DMADView *adView;

@property (nonatomic, strong) ATSuspendedButton *suspendedBtn;

@property (copy, nonatomic) NSString *placementID;

@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs_native;
@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs_draw;
@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs_preRoll;
@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs;

@property (nonatomic, copy) NSString *nativeStr;

@property (nonatomic, strong) UIView *showView;

@property(nonatomic, strong) NSString *togetherLoadAdStr;


@end
static NSString *const kLoadKey = @"load";
static NSString *const kCallbackKey = @"request";
@implementation ATNativeViewController
#ifdef NATIVE_INTEGRATED
-(instancetype) initWithPlacementName:(NSString*)name {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
//        _name = name;
       
    }
//    _numberOfLoadAndCallback = [NSMutableDictionary dictionaryWithContentsOfFile:[ATNativeViewController numberOfLoadPath]];
//    if (_numberOfLoadAndCallback == nil) { _numberOfLoadAndCallback = [NSMutableDictionary dictionary]; }
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
- (NSDictionary<NSString *,NSString *> *)placementIDs_native{
    
    return @{
        @"MyOffer":                 @"b5f33878ee0646",
        @"GAM":                     @"b5f238964f3e6f",
        @"Mintegral-(Advanced)":    @"b5ee1d26cb56ee",
        @"Header Bidding":          @"b5d1333d023691",
        @"Nend":                    @"b5cb96d44c0c5f",
        @"Nend-(Video)":            @"b5cb96d5291e93",
        @"TT-(Feed)":               @"b5c2c6d50e7f44",
        @"Pangle":                  @"b612f6a831fe71",
        @"MobPower":                @"b5c2084d12aca4",
        @"Facebook":                @"b5b0f551340ea9",
        @"Facebook(NativeBanner)":  @"b5ee89fd60cddc",
        @"AdMob":                   @"b5b0f55228375a",
        @"Inmobi":                  @"b5b0f553483724",
        @"Mintegral":               @"b5b0f555698607",
        @"GDT-(self randerer)":     @"b5bacac5f73476",
        @"GDT-(Template)":          @"b5bacac780e03b",
        @"Appnext":                 @"b5bc7fb2787f1e",
        @"Baidu":                   @"b5d36c4ad68a26",
        @"KS":                      @"b5e4613e50cbf2",
        @"ADX":                     @"b5fa25023d0767",
        @"OnlineApi":               @"b5fa2508579446",
        @"All":                     @"b5c2c6d50e7f44",
        @"Gromore":                 @"b601cac6b99ead",
        @"Sigmob":                  @"b6170cda99de6d",
        @"DirectOffer":             @"b61bfff2c812cb",
        @"Klevin":                  @"b6172985f45143",
        @"StartApp":                @"b6217531b46e9d",
        @"MyTarget":                @"b623adf05c5db8",
        @"MyTarget(Template)":      @"b623ae6973ac16"
    };
}

- (NSDictionary<NSString *,NSString *> *)placementIDs_draw{
    
    return @{
        @"TT(Draw)":                @"b5c2c6d62b9d65",
        @"KS(Draw)":                @"b5e5ce042cabfb",
    };
}
- (NSDictionary<NSString *,NSString *> *)placementIDs_preRoll{
    return @{
        @"TT(Feed)":                @"b5c2c6d50e7f44"
    };
}

+(NSString*)numberOfLoadPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"native_load"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = _name;
    self.view.backgroundColor = kRGB(245, 245, 245);
    _placementIDs = [ATNativeViewController nativePlacementIDs];
    [self setupUI];
    
   
}

- (void)setupUI
{
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [clearBtn setTitle:@"clear log" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    [self.view addSubview:self.nativeBtn];
    [self.view addSubview:self.drawBtn];
    [self.view addSubview:self.preRollBtn];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.footView];
    [self.view addSubview:self.suspendedBtn];
    
    [self.nativeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
    }];

    [self.drawBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nativeBtn.mas_right).offset(kScaleW(26));
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo(self.nativeBtn.mas_height);
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
    }];

    [self.preRollBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(kScaleW(-26));
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 4) / 3);
        make.height.mas_equalTo(self.nativeBtn.mas_height);
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
    }];

    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(242));
        make.top.equalTo(self.nativeBtn.mas_bottom).offset(kScaleW(20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(20));
        make.bottom.equalTo(self.footView.mas_top).offset(kScaleW(-20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kScaleW(340));
    }];
    
    [self.suspendedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kScaleW(100));
        make.top.equalTo(self.view.mas_top).offset(kScaleW(200));
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self changeModel:self.nativeBtn];
    
}

- (void)clearLog
{
    self.textView.text = @"";
}




#pragma mark - together load
- (void)togetherLoadAd:(NSString *)togetherLoadAdStr{
    self.togetherLoadAdStr = togetherLoadAdStr;
    NSLog(@"同时加载原生广告位---%@",self.placementID);

    if (self.placementID) {
        [self loadAd];
    }
}

- (NSString *)placementID{
    if (self.togetherLoadAdStr.length) {
        NSString *tempID = self.placementIDs_native[self.togetherLoadAdStr];
        __block NSString *placementIDStr;
        if (tempID == nil) {
            [self.placementIDs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key containsString:self.togetherLoadAdStr]) {
                    placementIDStr = obj;
                    *stop = YES;
                }
            }];
            return placementIDStr ? placementIDStr : _placementID;
        }else{
            return tempID;
        }
    }else{
        return _placementID;
    }
}

#pragma mark - Action
- (void)changeModel:(UIButton *)sender
{
    if ((self.nativeBtn.isSelected && sender == self.nativeBtn) || (self.drawBtn.isSelected && sender == self.drawBtn) || (self.preRollBtn.isSelected && sender == self.preRollBtn)) {
        return;
    }
    if (sender.tag == 0) {
        self.nativeBtn.selected = YES;
        self.drawBtn.selected = NO;
        self.preRollBtn.selected = NO;
        self.placementIDs = self.placementIDs_native;
        [self.menuView showSubMenu];
        
       
    } else if (sender.tag == 1) {
        self.nativeBtn.selected = NO;
        self.drawBtn.selected = YES;
        self.preRollBtn.selected = NO;
        self.placementIDs = self.placementIDs_draw;
        [self.menuView hiddenSubMenu];
   
    } else {
        self.nativeBtn.selected = NO;
        self.drawBtn.selected = NO;
        self.preRollBtn.selected = YES;
        self.placementIDs = self.placementIDs_preRoll;
        [self.menuView hiddenSubMenu];
        
      
    }
    [self.nativeBtn setButtonIsSelectBoard];
    [self.drawBtn setButtonIsSelectBoard];
    [self.preRollBtn setButtonIsSelectBoard];
    
    [self resetPlacementID];
}

- (void)resetPlacementID {
    [self.menuView resetMenuList:self.placementIDs.allKeys];
    self.placementID = self.togetherLoadAdStr.length ? self.placementIDs[self.togetherLoadAdStr] : self.placementIDs.allValues.firstObject;
}


- (void)loadAd
{
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.bounds) - 30.0f, 351.0f);
    if ([self.placementIDs_draw.allValues containsObject:self.placementID]) {
        size = self.view.frame.size;
    }
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

- (void)checkAd
{
    // list
    NSArray *array = [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:self.placementID];
    NSLog(@"ValidAds.count:%ld--- ValidAds:%@",array.count,array);

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[ATAdManager sharedManager] nativeAdReadyForPlacementID:self.placementID] ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void)showAd
{
    
    if (self.nativeBtn.isSelected && [self.nativeStr isEqualToString:@"Native List"]) {
        // 列表
        ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
        config.ADFrame = CGRectMake(.0f, 100.0f, CGRectGetWidth(self.view.bounds), 350.0f);
        config.mediaViewFrame = CGRectMake(0, 150.0f, CGRectGetWidth(self.view.bounds), 350.0f - 150.0f);
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
//        [self.adView muteEnable:YES];
        if (self.adView == nil) {
            NSLog(@"show failed");
            return;
        }
        
        ATNativeMessageStreamViewController *messageVc = [[ATNativeMessageStreamViewController alloc] initWithAdView:self.adView];
        [self.navigationController pushViewController:messageVc animated:YES];
        
    } else if (self.drawBtn.isSelected) {
        // Draw
        ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
        config.ADFrame = self.view.bounds;
        config.delegate = self;
        config.renderingViewClass = [DMADView class];
        config.rootViewController = self;
        self.adView = [[ATAdManager sharedManager] retriveAdViewWithPlacementID:self.placementID configuration:config];
//        [self.adView muteEnable:YES];
        if (self.adView == nil) {
            NSLog(@"show failed");
            return;
        }
        self.adView.tag = 3333;
        ATDrawViewController *drawVc = [[ATDrawViewController alloc] initWithAdView:self.adView];
        [self.navigationController pushViewController:drawVc animated:YES];
        
    } else {
        
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
//        [self.adView muteEnable:YES];
        if (self.adView == nil) {
            NSLog(@"show failed");
            return;
        }
        
//        [self.view addSubview:self.adView];
        
        ATNativeShowViewController *showVc = [[ATNativeShowViewController alloc] initWithAdView:self.adView placementID:self.placementID];
        [self.navigationController pushViewController:showVc animated:YES];
        
        ATNativeADView *tempView = self.adView;
        if ([self.adView isKindOfClass:[ATNativeADView class]] == NO) {
            tempView = self.adView.subviews.firstObject;
        }
        NSLog(@"获取广告平台id：%ld",tempView.networkFirmID);
        
    }
}

- (void)removeAd
{
    if (self.adView && self.adView.superview) {
        [self.adView removeFromSuperview];
    }
}

- (void)showLog:(NSString *)logStr
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *logS = self.textView.text;
        NSString *log = nil;
        if (![logS isEqualToString:@""]) {
            log = [NSString stringWithFormat:@"%@\n%@", logS, logStr];
        } else {
            log = [NSString stringWithFormat:@"%@", logStr];
        }
        self.textView.text = log;
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
    });
}


#pragma mark - delegate with extra
- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--AD--开始--ATRewardVideoViewController::didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--AD--完成--ATRewardVideoViewController::didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--AD--失败--ATRewardVideoViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
    
//    [self showLog:[NSString stringWithFormat:@"didFailToLoadADSourceWithPlacementID:%@--%@", placementID],error];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--bid--开始--ATRewardVideoViewController::didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--bid--完成--ATRewardVideoViewController::didFinishBiddingADSourceWithPlacementID:%@--extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didFinishBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    
    NSLog(@"广告源--bid--失败--ATRewardVideoViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
    
//    [self showLog:[NSString stringWithFormat:@"didFailBiddingADSourceWithPlacementID:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"ATNativeViewController:: didFinishLoadingADWithPlacementID:%@", placementID);
    
    [self showLog:[NSString stringWithFormat:@"didFinishLoading:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"ATNativeViewController:: didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    
    [self showLog:[NSString stringWithFormat:@"didFailToLoad:%@ errorCode:%ld", placementID, (long)error.code]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

#pragma mark - delegate with extra
-(void) didStartPlayingVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didStartPlayingVideoInAdView:placementID:%@with extra: %@", placementID,extra);
    
    [self showLog:[NSString stringWithFormat:@"didStartPlayingVideoInAdView:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) didEndPlayingVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didEndPlayingVideoInAdView:placementID:%@ extra: %@", placementID,extra);
    
    [self showLog:[NSString stringWithFormat:@"didEndPlayingVideoInAdView:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) didClickNativeAdInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didClickNativeAdInAdView:placementID:%@ with extra: %@", placementID,extra);
    
    [self showLog:[NSString stringWithFormat:@"didClickNativeAdInAdView:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

- (void) didDeepLinkOrJumpInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATNativeViewController:: didDeepLinkOrJumpInAdView:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    
    [self showLog:[NSString stringWithFormat:@"ATNativeViewController:: didDeepLinkOrJumpInAdView:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) didShowNativeAdInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didShowNativeAdInAdView:placementID:%@ with extra: %@", placementID,extra);
    adView.mainImageView.hidden = [adView isVideoContents];
    
    [self showLog:[NSString stringWithFormat:@"didShowNativeAdInAdView:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) didEnterFullScreenVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didEnterFullScreenVideoInAdView:placementID:%@", placementID);
    
    [self showLog:[NSString stringWithFormat:@"didEnterFullScreenVideoInAdView:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) didExitFullScreenVideoInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATNativeViewController:: didExitFullScreenVideoInAdView:placementID:%@", placementID);
    
    [self showLog:[NSString stringWithFormat:@"didExitFullScreenVideoInAdView:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) didTapCloseButtonInAdView:(ATNativeADView*)adView placementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: didTapCloseButtonInAdView:placementID:%@ extra:%@", placementID, extra);
    
    [self.adView removeFromSuperview];
    self.adView = nil;
    adView = nil;
    [self showLog:[NSString stringWithFormat:@"didTapCloseButtonInAdView:placementID:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

- (void)didCloseDetailInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: didCloseDetailInAdView:placementID:%@ extra:%@", placementID, extra);

    [self showLog:[NSString stringWithFormat:@"didCloseDetailInAdView:placementID:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) nativeAdDidClickInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: nativeAdDidClickInAdViewForPlacementID:placementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"nativeAdDidClickInAdViewForPlacementID:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) nativeAdDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success {
    NSLog(@"ATNativeViewController:: nativeAdDeepLinkOrJumpForPlacementID:placementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"nativeAdDeepLinkOrJumpForPlacementID:placementID:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) nativeAdDidStartPlayingVideoInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: nativeAdDidStartPlayingVideoInAdViewForPlacementID:placementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"nativeAdDidStartPlayingVideoInAdViewForPlacementID:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) nativeAdDidEndPlayingVideoInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: nativeAdDidEndPlayingVideoInAdViewForPlacementID:placementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"nativeAdDidEndPlayingVideoInAdViewForPlacementID:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) nativeAdDidEnterFullScreenVideoInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: nativeAdDidEnterFullScreenVideoInAdViewForPlacementID:placementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"nativeAdDidEnterFullScreenVideoInAdViewForPlacementID:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) nativeAdDidExitFullScreenVideoInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"nativeAdDidExitFullScreenVideoInAdViewForPlacementID:%@", placementID);
    
    [self showLog:[NSString stringWithFormat:@"nativeAdDidExitFullScreenVideoInAdViewForPlacementID:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) nativeAdDidTapCloseButtonInAdViewForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATNativeViewController:: nativeAdDidTapCloseButtonInAdViewForPlacementID:placementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"nativeAdDidTapCloseButtonInAdViewForPlacementID:%@", placementID]];
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}


#pragma mark - lazy
- (ATADFootView *)footView
{
    if (!_footView) {
//        _footView = [[ATADFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(340))];
//
//        _footView.removeBtn.hidden = YES;
//        _footView.showBtn.frame = CGRectMake(kScaleW(26), kScaleW(230), (kScreenW - kScaleW(52)), kScaleW(90));
        _footView = [[ATADFootView alloc] init];

        __weak typeof(self) weakSelf = self;
        [_footView setClickLoadBlock:^{
            NSLog(@"点击加载");
            [weakSelf loadAd];
        }];
        [_footView setClickReadyBlock:^{
            NSLog(@"点击准备");
            [weakSelf checkAd];
        }];
        [_footView setClickShowBlock:^{
            NSLog(@"点击展示");
            [weakSelf showAd];
        }];
        
        if (![NSStringFromClass([self class]) containsString:@"Auto"]) {
            [_footView.loadBtn setTitle:@"Load Native AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is Native AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show Native AD" forState:UIControlStateNormal];
        }
        
    }
    return _footView;
}

- (ATModelButton *)nativeBtn
{
    if (!_nativeBtn) {
        _nativeBtn = [[ATModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _nativeBtn.tag = 0;
        _nativeBtn.backgroundColor = [UIColor whiteColor];
        _nativeBtn.layer.borderWidth = kScaleW(5);
        _nativeBtn.modelLabel.text = @"Native";
        _nativeBtn.image.image = [UIImage imageNamed:@"Native"];
        [_nativeBtn addTarget:self action:@selector(changeModel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nativeBtn;
}

- (ATModelButton *)drawBtn
{
    if (!_drawBtn) {
        _drawBtn = [[ATModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _drawBtn.tag = 1;
        _drawBtn.backgroundColor = [UIColor whiteColor];
        _drawBtn.layer.borderWidth = kScaleW(5);
        _drawBtn.modelLabel.text = @"Vertical-Draw Video";
        _drawBtn.image.image = [UIImage imageNamed:@"Vertical Draw video"];
        [_drawBtn addTarget:self action:@selector(changeModel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _drawBtn;
}

- (ATModelButton *)preRollBtn
{
    if (!_preRollBtn) {
        _preRollBtn = [[ATModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _preRollBtn.tag = 2;
        _preRollBtn.backgroundColor = [UIColor whiteColor];
        _preRollBtn.layer.borderWidth = kScaleW(5);
        _preRollBtn.modelLabel.text = @"Pre-Roll";
        _preRollBtn.image.image = [UIImage imageNamed:@"Pre-roll AD"];
        [_preRollBtn addTarget:self action:@selector(changeModel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _preRollBtn;
}

- (ATMenuView *)menuView
{
    if (!_menuView) {
        NSArray *list = @[@"Native", @"Native List"];
        _menuView = [[ATMenuView alloc] initWithMenuList:self.placementIDs.allKeys subMenuList:list];
        _menuView.layer.masksToBounds = YES;
        _menuView.layer.cornerRadius = 5;
        __weak typeof (self) weakSelf = self;
        [_menuView setSelectMenu:^(NSString * _Nonnull selectMenu) {
            weakSelf.placementID = weakSelf.placementIDs[selectMenu];
            NSLog(@"select placementId:%@", weakSelf.placementID);
        }];
        [_menuView setSelectSubMenu:^(NSString * _Nonnull selectSubMenu) {
            weakSelf.nativeStr = selectSubMenu;
            NSLog(@"%@", selectSubMenu);
        }];
    }
    return _menuView;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5;
        _textView.editable = NO;
        _textView.text = @"";
    }
    return _textView;
}

- (UIView *)showView
{
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
        _showView.backgroundColor = [UIColor whiteColor];
    }
    return _showView;
}

- (ATSuspendedButton *)suspendedBtn
{
    if (!_suspendedBtn) {
        _suspendedBtn = [[ATSuspendedButton alloc] initWithProtocolList:@[@"ATAdLoadingDelegate", @"ATNativeADDelegate"]];
        [_suspendedBtn setImage:[UIImage imageNamed:@"topon_logo"] forState:UIControlStateNormal];
        _suspendedBtn.layer.masksToBounds = YES;
        _suspendedBtn.layer.cornerRadius = kScaleW(50);
        _suspendedBtn.layer.borderWidth = kScaleW(1);
        _suspendedBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    return _suspendedBtn;
}

#endif
@end
