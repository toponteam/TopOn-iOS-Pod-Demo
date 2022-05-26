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

NSString *const kGDTZoomOutPlacement = @"GDT(V+)";

static NSString *const kMintegralPlacementID = @"b5ee89f9859d05";
static NSString *const kSigmobPlacementID = @"b5d771f34bc73d";
static NSString *const kGDTPlacementID = @"b5c1b0470c7e4a";
static NSString *const kGDTZoomOutPlacementID = @"b5fd75a304f0a4";
static NSString *const kBaiduPlacementID = @"b5c1b047a970fe";
static NSString *const kTTPlacementID = @"b5c1b048c498b9";
static NSString *const kAdmobPlacementID = @"b5f842af26114c";
static NSString *const kKSPlacementID = @"b5fb767e454cce";
static NSString *const kAllPlacementID = @"b5c22f0e5cc7a0";
static NSString *const kMyofferPlacementID = @"b5f33c33431ca0";
static NSString *const kKlevinPlacementID = @"b613aff35cd174";
static NSString *const kDirectOfferPlacementID = @"b61bffcf212e16";


@interface ATSplashViewController ()<ATSplashDelegate,ATNativeSplashDelegate>

@property(nonatomic, readonly) UIActivityIndicatorView *loadingView;
@property(nonatomic, readonly) UIButton *reloadADButton;
@property(nonatomic, readonly) UIButton *clearAdButton;
@property(nonatomic, readonly) UIButton *showAdButton;
@property(nonatomic, readonly) UILabel *failureTipsLabel;
@property(nonatomic, readonly) UIButton *readyButton;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) NSDictionary *placementIDs;
@property(nonatomic, strong) UIButton *skipButton;

@end

@implementation ATSplashViewController

- (instancetype)initWithPlacementName:(NSString *)name {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        _name = name;
        _placementIDs = @{
            kMintegralPlacement:kMintegralPlacementID,
            kSigmobPlacement:kSigmobPlacementID,
            kGDTPlacement:kGDTPlacementID,
            kGDTZoomOutPlacement:kGDTZoomOutPlacementID,
            kBaiduPlacement:kBaiduPlacementID,
            kTTPlacementName:kTTPlacementID,
            kAdMobPlacement:kAdmobPlacementID,
            kKSPlacement:kKSPlacementID,
            kAllPlacementName:kAllPlacementID,
            kMyOfferPlacement:kMyofferPlacementID,
            kKlevinPlacement: kKlevinPlacementID,
            kDirectOfferPlacement:kDirectOfferPlacementID
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _name;
    
    [self setupSubviews];
}

- (void)setupSubviews {
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
    
    _readyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_readyButton addTarget:self action:@selector(readyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_readyButton setTitleColor:_readyButton.tintColor forState:UIControlStateNormal];
    [_readyButton setTitle:@"Ad Ready?" forState:UIControlStateNormal];
    _readyButton.frame = CGRectMake(CGRectGetMaxX(_clearAdButton.frame) + 40.0f, CGRectGetMinY(_clearAdButton.frame), (CGRectGetWidth(self.view.bounds) - 40) / 2.0f, 60.0f);
    [self.view addSubview:_readyButton];
    
    _failureTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(.0f, 64.0f, CGRectGetWidth(self.view.bounds), 400.0f)];
    _failureTipsLabel.text = @"Failed to load ad";
    _failureTipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_failureTipsLabel];
    _failureTipsLabel.hidden = YES;
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

// MARK:- actions
-(void) readyButtonTapped {
    // another method
//    ATCheckLoadModel *checkLoadModel = [[ATAdManager sharedManager] checkSplashLoadStatusForPlacementID:_placementIDs[_name]];
//    NSMutableDictionary *info = [NSMutableDictionary dictionary];
//    info[@"result"] = @{@"isLoading":checkLoadModel.isLoading ? @"YES" : @"NO", @"isReady":checkLoadModel.isReady ? @"YES" : @"NO", @"adOfferInfo":checkLoadModel.adOfferInfo};
//    NSLog(@"%@",[NSString stringWithFormat:@"\nAPI invocation info:\n*****************************\n%@ \n*****************************", info]);
//    5.7.53
    NSArray *caches = [[ATAdManager sharedManager] getSplashValidAdsForPlacementID: _placementIDs[_name]];
    NSLog(@"ValidAds -- %@",caches);
    
    BOOL ready = [[ATAdManager sharedManager] splashReadyForPlacementID:_placementIDs[_name]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:ready ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clearAdButtonTapped {
    
}

- (void)reloadADButtonTapped {
    UILabel *label = nil;
    label = [[UILabel alloc] initWithFrame:CGRectMake(.0f, .0f, CGRectGetWidth([UIScreen mainScreen].bounds), 100.0f)];
    label.text = @"Container";
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;

    [[ATAdManager sharedManager] loadADWithPlacementID:_placementIDs[_name] extra:[self getSplashInfo:_name] delegate:self containerView:nil];
}

- (void)showAD {
    UIWindow *mainWindow = nil;
    if ( @available(iOS 13.0, *) ) {
        mainWindow = [UIApplication sharedApplication].windows.firstObject;
        [mainWindow makeKeyWindow];
    }else {
        mainWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.skipButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 90 - 30, 50, 90, 28);
    self.skipButton.layer.cornerRadius = 14;
    self.skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:@5000 forKey:kATSplashExtraCountdownKey];
    [mutableDict setValue:self.skipButton forKey:kATSplashExtraCustomSkipButtonKey];
    [mutableDict setValue:@500 forKey:kATSplashExtraCountdownIntervalKey];
    
    [[ATAdManager sharedManager] showSplashWithPlacementID:_placementIDs[_name] scene:nil window:mainWindow extra:mutableDict delegate:self];
    
}

- (void)splashCountdownTime:(NSInteger)countdown forPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATSplashViewController::splashCountdownTime:%ld forPlacementID:%@",countdown,placementID);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = [NSString stringWithFormat:@"%lds | 自定义Skip",countdown/1000];
        if (countdown/1000) {
            [self.skipButton setTitle:title forState:UIControlStateNormal];
        }
    });
    
}
// MARK:- splash delegate

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"ATSplashViewController::didFailToLoadADWithPlacementID:%@ error:%@",placementID,error);
}

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"ATSplashViewController::didFinishLoadingADWithPlacementID:%@",placementID);
}

- (void)splashDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATSplashViewController:: splashDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
}

- (void)splashDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATSplashViewController::splashDidClickForPlacementID:%@ extra:%@",placementID,extra);

}

- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATSplashViewController::splashDidCloseForPlacementID:%@ extra:%@",placementID,extra);

}

- (void)splashDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATSplashViewController::splashDidShowForPlacementID:%@ extra:%@",placementID,extra);
}

-(void)splashZoomOutViewDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra {
    NSLog(@"ATSplashViewController::splashZoomOutViewDidClickForPlacementID:%@ extra:%@",placementID,extra);
}

-(void)splashZoomOutViewDidCloseForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra {
    NSLog(@"ATSplashViewController::splashZoomOutViewDidCloseForPlacementID:%@ extra:%@",placementID,extra);
}

- (void)splashDetailDidClosedForPlacementID:(NSString*)placementID extra:(NSDictionary *) extra {
    NSLog(@"ATSplashViewController::splashDetailDidClosedForPlacementID:%@ extra:%@",placementID,extra);
}

- (void)splashDidShowFailedForPlacementID:(NSString*)placementID error:(NSError *)error extra:(NSDictionary *) extra {
    NSLog(@"ATSplashViewController::splashDidShowFailedForPlacementID:%@ error:%@ extra:%@",placementID,error,extra);
}

- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout{
    NSLog(@"ATSplashViewController::didFinishLoadingSplashADWithPlacementID:%@ isTimeout:%d",placementID,isTimeout);
//    NSLog(@"开屏成功:%@----是否超时:%d",placementID,isTimeout);
}

- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID{
    
    NSLog(@"ATSplashViewController::didTimeoutLoadingSplashADWithPlacementID:%@",placementID);

//    NSLog(@"开屏超时:%@",placementID);
}


// MARK:- ATNativeSplashDelegate
- (void)didClickNaitveSplashAdForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATSplashViewController::didClickNaitveSplashAdForPlacementID:%@ extra:%@",placementID,extra);
}

- (void)didCloseNativeSplashAdForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATSplashViewController::didCloseNativeSplashAdForPlacementID:%@ extra:%@",placementID,extra);
}

- (void)didNativeSplashDeeplinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATSplashViewController::didCloseNativeSplashAdForPlacementID:%@ extra:%@, result:%@",placementID,extra, success ? @"YES" : @"NO");
}

- (void)didShowNativeSplashAdForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATSplashViewController::didShowNativeSplashAdForPlacementID:%@ extra:%@",placementID,extra);
}

- (void)failedToLoadNativeSplashAdForPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"ATSplashViewController::didShowNativeSplashAdForPlacementID:%@ error:%@",placementID,error);
}

- (void)finishLoadingNativeSplashAdForPlacementID:(NSString *)placementID {
    NSLog(@"ATSplashViewController::finishLoadingNativeSplashAdForPlacementID:%@",placementID);
}


@end
