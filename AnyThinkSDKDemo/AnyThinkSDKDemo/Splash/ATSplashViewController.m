//
//  ATSplashViewController.m
//  AnyThinkSDKDemo
//
//  Created by Jason on 2020/12/3.
//  Copyright © 2020 AnyThink. All rights reserved.
//

#import "ATSplashViewController.h"
#import <AnyThinkSplash/AnyThinkSplash.h>
#import <AnyThinkNative/AnyThinkNative.h>
#import "ATADFootView.h"
#import "ATModelButton.h"
#import "ATMenuView.h"

@interface ATSplashViewController ()<ATSplashDelegate>

@property (nonatomic, strong) ATADFootView *footView;

@property (nonatomic, strong) UIView *modelBackView;

@property (nonatomic, strong) ATModelButton *modelButton;

@property (nonatomic, strong) ATMenuView *menuView;

@property (nonatomic, strong) UITextView *textView;

@property (copy, nonatomic) NSString *placementID;

@property(nonatomic, strong) UIButton *skipButton;

@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs;

@property(nonatomic, strong) NSString *defaultAdSourceConfigStr;


@end

@implementation ATSplashViewController

-(instancetype)init{
    self = [super init];
    
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Splash";
    self.view.backgroundColor = kRGB(245, 245, 245);
    
    [self setupData];
    [self setupUI];
}

- (NSDictionary<NSString *,NSString *> *)placementIDs{
    
    return @{
        @"快手":@"b62a6e4c8d027a",
        @"Mintegral":   @"b5ee89f9859d05", //b5ee89f9859d05 默认，b621dee44d9f60 原生开屏
        @"Sigmob":      @"b5d771f34bc73d", //b5d771f34bc73d 默认，b621dec2d592cf 原生开屏
        @"GDT":         @"b5c1b0470c7e4a", //b5c1b0470c7e4a 默认，b621dc9b3bbb57 原生开屏
//        @"GDT-(V+)":     @"b5fd75a304f0a4",
        @"Baidu":       @"b5c1b047a970fe", //b5c1b047a970fe 默认，b621de65cdfb85 原生开屏
        @"TT":          @"b5c1b048c498b9", //b5c1b048c498b9 默认，b621dec9a294b9 原生开屏
        @"Pangle":      @"b612f6ab63befe",
        @"AdMob":       @"b5f842af26114c",
        @"KS":          @"b5fb767e454cce", //b5fb767e454cce 默认，b621de76dd6d7f 原生开屏
        @"All":         @"b5c22f0e5cc7a0",
        @"Myoffer":     @"b5f33c33431ca0",
        @"ADX":         @"b5fa25036683d2",
        @"OnlineApi":   @"b5fa2509a93b71",
        @"Gromore":     @"b601a111ad6efa",
        @"Klevin":      @"b613aff35cd174",
        @"DirectOffer": @"b61bffcf212e16",
        @"Default":     @"b61cd193f0defd",       // 兜底广告位
        @"KS-splash-native": @"b62319f3a7fad6",
        @"GDT-splash-native": @"b62319f191fb45",
        @"TT-splash-native": @"b62319f0b030af",
        @"Sigmob-splash-native": @"b62319ee1228c3",
        @"Baidu-splash-native": @"b62319ec138619",
        @"MTG-splash-native":@"b62319f2d1b028",
        @"DSP": @"b62908bd8bdd3e"
    };
}

- (void)setupData
{
    self.placementID = self.placementIDs.allValues.firstObject;
}

- (void)setupUI {
  
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [clearBtn setTitle:@"clear log" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    [self.view addSubview:self.modelBackView];
    [self.modelBackView addSubview:self.modelButton];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.footView];
    
    [self.modelBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
    }];
    

    [self.modelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScaleW(340));
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.modelBackView.mas_top);
    }];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(242));
        make.top.equalTo(self.modelBackView.mas_bottom).offset(kScaleW(20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(20));
        make.bottom.equalTo(self.footView.mas_top).offset(kScaleW(-20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kScaleW(340));
    }];
    
   
}

- (void)clearLog
{
    self.textView.text = @"";
}


// MARK:- data
- (NSDictionary *)getSplashInfo:(NSString *)name {
    NSDictionary *extra = nil;
    NSTimeInterval tolerateTimeout = 5.5f;
//    if ([name isEqualToString:kMintegralPlacement]) {
//        extra = @{kATSplashExtraNetworkFirmID:@6,
//                  kATSplashExtraAdSourceIDKey:@"72004",
//                  kATSplashExtraMintegralAppID:@"104036",
//                  kATSplashExtraMintegralAppKey:@"ef13ef712aeb0f6eb3d698c4c08add96",
//                  kATSplashExtraMintegralUnitID:@"275050",
//                  kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
//        };
//    } else if ([name isEqualToString:kSigmobPlacement]) {
//        extra = @{kATSplashExtraNetworkFirmID:@29,
//                  kATSplashExtraAdSourceIDKey:@"12302",
//                  kATSplashExtraSigmobAppKey:@"eccdcdbd9adbd4a7",
//                  kATSplashExtraSigmobAppID:@"6877",
//                  kATSplashExtraSigmobPlacementID:@"ea1f8f9bd12",
//                  kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
//        };
//    } else if ([name isEqualToString:kGDTPlacement]) {
//        extra = @{kATSplashExtraNetworkFirmID:@8,
//                  kATSplashExtraAdSourceIDKey:@"71998",
//                  kATSplashExtraGDTAppID:@"1105344611",
//                  kATSplashExtraGDTUnitID:@"9040714184494018",
//                  kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
//        };
//    } else if ([name isEqualToString:kBaiduPlacement]) {
//        extra = @{kATSplashExtraNetworkFirmID:@22,
//                  kATSplashExtraAdSourceIDKey:@"72010",
//                  kATSplashExtraBaiduAppID:@"ccb60059",
//                  kATSplashExtraBaiduAdPlaceID:@"2058492",
//                  kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
//        };
//    } else if ([name isEqualToString:kTTPlacementName]) {
//        extra = @{kATSplashExtraNetworkFirmID:@15,
//                  kATSplashExtraAdSourceIDKey:@"3628",
//                  kATSplashExtraAppID:@"5000546",
//                  kATSplashExtraSlotID:@"800546808",
//                  kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
//        };
//    } else if ([name isEqualToString:kAdMobPlacement]) {
//        extra = @{kATSplashExtraNetworkFirmID:@2,
//                  kATSplashExtraAdSourceIDKey:@"145203",
//                  kATSplashExtraAdmobAppID:@"ca-app-pub-9488501426181082~6772985580,",
//                  kATSplashExtraAdmobUnitID:@"ca-app-pub-3940256099942544/1033173712",
//                  kATSplashExtraAdmobOrientation:@(1),
//                  kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
//        };
//    } else if ([name isEqualToString:kKSPlacement]) {
//        extra = @{kATSplashExtraNetworkFirmID:@28,
//                  kATSplashExtraAdSourceIDKey:@"197933",
//                  kATSplashExtraKSAppID:@"501400011",
//                  kATSplashExtraKSPosID:@"5014000369",
//                  kATSplashExtraShowDirectionKey:@(0),
//                  kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
//        };
//    } else if ([name isEqualToString:kAllPlacementName]) {
//        extra = @{kATSplashExtraNetworkFirmID:@6,
//                  kATSplashExtraAdSourceIDKey:@"72004",
//                  kATSplashExtraMintegralAppID:@"104036",
//                  kATSplashExtraMintegralAppKey:@"ef13ef712aeb0f6eb3d698c4c08add96",
//                  kATSplashExtraMintegralUnitID:@"275050",
//                  kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
//        };
//    } else {
        extra = @{
            kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
       };
//    }
    
    return extra;
}



- (void)clearAdButtonTapped {
    
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


- (void)loadAd
{
    UIInterfaceOrientation deviceOrientaion = [self currentInterfaceOrientation];
    BOOL landscape = UIInterfaceOrientationIsLandscape(deviceOrientaion);
    
    UILabel *label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(.0f, .0f, landscape ? 120 : UIScreen.mainScreen.bounds.size.width, landscape ? UIScreen.mainScreen.bounds.size.height : 100.0f)];
    label.text = @"Container";
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self forKey:kATExtraInfoRootViewControllerKey];
    //    [mutableDict setValue:self forKey:kATSplashExtraRootViewControllerKey];
    [mutableDict setValue:@5.5 forKey:kATSplashExtraTolerateTimeoutKey];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID
                                                 extra:mutableDict
                                              delegate:self
                                         containerView:label
                                 defaultAdSourceConfig:self.modelButton.isSelected ? self.defaultAdSourceConfigStr : nil];
}
- (UIInterfaceOrientation)currentInterfaceOrientation
{
    if (@available(iOS 13.0, *)) {
        UIWindow *firstWindow = [[[UIApplication sharedApplication] windows] firstObject];
        if (firstWindow == nil) { return UIInterfaceOrientationUnknown; }
        
        UIWindowScene *windowScene = firstWindow.windowScene;
        if (windowScene == nil){ return UIInterfaceOrientationUnknown; }
        
        return windowScene.interfaceOrientation;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return UIApplication.sharedApplication.statusBarOrientation;
#pragma clang diagnostic pop
        
    }
}

- (void)checkAd
{
    // another method
    //    ATCheckLoadModel *checkLoadModel = [[ATAdManager sharedManager] checkSplashLoadStatusForPlacementID:self.placementID];
    
    // list
    NSArray *caches = [[ATAdManager sharedManager] getSplashValidAdsForPlacementID:self.placementID];
    NSLog(@"ValidAds.count:%ld--- ValidAds:%@",caches.count,caches);

    BOOL ready = [[ATAdManager sharedManager] splashReadyForPlacementID:self.placementID];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:ready ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void)showAd
{
    UIWindow *mainWindow = nil;
    if ( @available(iOS 13.0, *) ) {
        mainWindow = [UIApplication sharedApplication].windows.firstObject;
        [mainWindow makeKeyWindow];
    }else {
        mainWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.skipButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80 - 20, 50, 80, 21);
    self.skipButton.layer.cornerRadius = 10.5;
    self.skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:@50000 forKey:kATSplashExtraCountdownKey];
    [mutableDict setValue:self.skipButton forKey:kATSplashExtraCustomSkipButtonKey];
    [mutableDict setValue:@500 forKey:kATSplashExtraCountdownIntervalKey];
    
    [[ATAdManager sharedManager] showSplashWithPlacementID:self.placementID scene:@"f5e54970dc84e6"
                                                    window:mainWindow
                                                     extra:mutableDict
                                                  delegate:self];
}


// MARK:- splash delegate
#pragma mark - delegates

- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--AD--开始--ATSplashViewController::didStartLoadingADSourceWithPlacementID:%@", placementID);
    
    //    [self showLog:[NSString stringWithFormat:@"didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    
   
}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--AD--完成--ATSplashViewController::didFinishLoadingADSourceWithPlacementID:%@", placementID);
    
    //    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    
  
}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--AD--失败--ATSplashViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
    
    //    [self showLog:[NSString stringWithFormat:@"didFailToLoadADSourceWithPlacementID:%@--%@", placementID],error];
    

}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--bid--开始--ATSplashViewController::didStartBiddingADSourceWithPlacementID:%@", placementID);
    
    //    [self showLog:[NSString stringWithFormat:@"didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    
   
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--bid--完成--ATSplashViewController::didFinishBiddingADSourceWithPlacementID:%@", placementID);
    
    //    [self showLog:[NSString stringWithFormat:@"didFinishBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    
 
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    
    NSLog(@"广告源--bid--失败--ATSplashViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
    
    //    [self showLog:[NSString stringWithFormat:@"didFailBiddingADSourceWithPlacementID:%@", placementID]];
    
  
}

- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout
{
    NSLog(@"开屏成功:%@----是否超时:%d",placementID,isTimeout);
    NSLog(@"开屏didFinishLoadingSplashADWithPlacementID:");
    [self showLog:[NSString stringWithFormat:@"开屏成功:%@----是否超时:%d",placementID,isTimeout]];
    
    
}

- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID
{
    NSLog(@"开屏超时:%@",placementID);
    NSLog(@"开屏didTimeoutLoadingSplashADWithPlacementID:");
    
    [self showLog:[NSString stringWithFormat:@"开屏超时:%@",placementID]];
    
   
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    
    NSLog(@"开屏ATSplashViewController:: didFailToLoadADWithPlacementID");
    
    [self showLog:[NSString stringWithFormat:@"开屏加载失败:%@--%@",placementID,error]];
   
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    
    NSLog(@"开屏ATSplashViewController:: didFinishLoadingADWithPlacementID");
    
    [self showLog:[NSString stringWithFormat:@"开屏加载成功:%@",placementID]];
   
}

- (void)splashDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success
{
    NSLog(@"开屏ATSplashViewController:: splashDeepLinkOrJumpForPlacementID:placementID:%@", placementID);
    
    [self showLog:[NSString stringWithFormat:@"splashDeepLinkOrJumpForPlacementID:placementID:%@ ", placementID]];
    
}

- (void)splashDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra
{
    NSLog(@"开屏ATSplashViewController::splashDidClickForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidClickForPlacementID:%@",placementID]];
  
}

- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra
{
    NSLog(@"开屏ATSplashViewController::splashDidCloseForPlacementID:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"splashDidCloseForPlacementID:%@ ",placementID]];
    
}

- (void)splashDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra
{
    NSLog(@"开屏ATSplashViewController::splashDidShowForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidShowForPlacementID:%@ ",placementID]];
    
}

-(void)splashZoomOutViewDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra
{
    NSLog(@"开屏ATSplashViewController::splashZoomOutViewDidClickForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashZoomOutViewDidClickForPlacementID:%@ ",placementID]];

}

-(void)splashZoomOutViewDidCloseForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra
{
    NSLog(@"开屏ATSplashViewController::splashZoomOutViewDidCloseForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashZoomOutViewDidCloseForPlacementID:%@ ",placementID]];
    
}

- (void)splashDetailDidClosedForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra
{
    NSLog(@"ATSplashViewController::splashDetailDidClosedForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDetailDidClosedForPlacementID:%@ ",placementID]];

}

- (void)splashDidShowFailedForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *) extra
{
    NSLog(@"开屏ATSplashViewController::splashDidShowFailedForPlacementID:%@",placementID);
    [self showLog:[NSString stringWithFormat:@"splashDidShowFailedForPlacementID:%@ error:%@ ",placementID,error]];
    
}

- (void)splashCountdownTime:(NSInteger)countdown forPlacementID:(NSString *)placementID extra:(NSDictionary *)extra
{
    NSLog(@"开屏ATSplashViewController::splashCountdownTime:%ld forPlacementID:%@",countdown,placementID);
    [self showLog:[NSString stringWithFormat:@"splashCountdownTime:%ld forPlacementID:%@",countdown,placementID]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = [NSString stringWithFormat:@"%lds | Skip",countdown/1000];
        if (countdown/1000) {
            [self.skipButton setTitle:title forState:UIControlStateNormal];
        }
    });
    
}
- (void)defaultAction{
    
    self.modelButton.selected = !self.modelButton.isSelected;
    self.modelButton.modelLabel.text = self.modelButton.isSelected ? @"Default Splash" : @"Splash";
}

#pragma mark - lazy

- (NSString *)defaultAdSourceConfigStr{
    
    NSString *str = @"{\"unit_id\":1331013,\"nw_firm_id\":22,\"adapter_class\":\"ATBaiduSplashAdapter\",\"content\":\"{\\\"button_type\\\":\\\"0\\\",\\\"ad_place_id\\\":\\\"7852632\\\",\\\"app_id\\\":\\\"e232e8e6\\\"}\"}";
    
    return str;
}

- (ATADFootView *)footView
{
    if (!_footView) {
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
            [_footView.loadBtn setTitle:@"Load Splash AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is Splash AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show Splash AD" forState:UIControlStateNormal];
        }
    }
    return _footView;
}

- (UIView *)modelBackView
{
    if (!_modelBackView) {
        _modelBackView = [[UIView alloc] init];
        _modelBackView.backgroundColor = [UIColor whiteColor];
        _modelBackView.layer.masksToBounds = YES;
        _modelBackView.layer.cornerRadius = 5;
    }
    return _modelBackView;
}

- (ATModelButton *)modelButton
{
    if (!_modelButton) {
        _modelButton = [[ATModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _modelButton.backgroundColor = [UIColor whiteColor];
        _modelButton.modelLabel.text = @"Default Splash";
        _modelButton.image.image = [UIImage imageNamed:@"splash"];
        _modelButton.selected = YES;
        [_modelButton addTarget:self action:@selector(defaultAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modelButton;
}

- (ATMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[ATMenuView alloc] initWithMenuList:self.placementIDs.allKeys subMenuList:nil];
        _menuView.layer.masksToBounds = YES;
        _menuView.layer.cornerRadius = 5;
        
        __weak typeof (self) weakSelf = self;
        [_menuView setSelectMenu:^(NSString * _Nonnull selectMenu) {
            weakSelf.placementID = weakSelf.placementIDs[selectMenu];
            NSLog(@"select placementId:%@", weakSelf.placementID);
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
        _textView.text = nil;
    }
    return _textView;
}



@end
