//
//  ViewController.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 6/2/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "ViewController.h"
#import "ATNativeViewController.h"
#import "ATRewardedVideoVideoViewController.h"
#import "ATBannerViewController.h"
#import "ATInterstitialViewController.h"
#import "ATNativeBannerViewController.h"
#import "ATDrawViewController.h"
#import <AnyThinkSplash/AnyThinkSplash.h>
#import <AnyThinkNative/AnyThinkNative.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, ATSplashDelegate, ATNativeSplashDelegate>
@property(nonatomic, readonly) UITableView *tableView;
@property(nonatomic, readonly) NSArray<NSArray<NSString*>*>* placementNames;
@property(nonatomic) NSInteger currentRow;
@end

static NSString *const kCellIdentifier = @"cell";
@implementation ViewController
-(void) enterNextBanner {
#ifdef BANNER_AUTO_TEST
    if (_currentRow < [_placementNames[1] count]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentRow++ inSection:1]];
        });
    } else {
        _currentRow = 0;
    }
#endif
}

-(void)getProxyStatus {
    NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:@"https://www.baidu.com/"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = proxies[0];
    if (![[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        //检测到连接代理
    }
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self enterNextBanner];
}

-(void) handlerBannerEvent:(NSNotification*)notification {
    [self enterNextBanner];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getProxyStatus];
    /*
     extern const CGFloat FBAdOptionsViewWidth;
     extern const CGFloat FBAdOptionsViewHeight;
     */
    _placementNames = @[@[kMintegralPlacement, kSigmobPlacement, kGDTPlacement, kBaiduPlacement, kTTPlacementName, kAdMobPlacement, kAllPlacementName, kMyOfferPlacement],
                        @[kGAMPlacement, kStartAppPlacement, kStartAppVideoPlacement, kMyOfferPlacement, kSigmobRVIntPlacement,kSigmobPlacement,kKSPlacement, kHeaderBiddingPlacement, kNendPlacement, kNendInterstitialVideoPlacement, kNendFullScreenInterstitialPlacement, kMaioPlacement, kUnityAdsPlacementName, kFacebookPlacement, kAdMobPlacement, kInmobiPlacement, kApplovinPlacement, kMintegralPlacement, kMintegralVideoPlacement, kGDTPlacement, kChartboostPlacementName, kTapjoyPlacementName, kIronsourcePlacementName, kVunglePlacementName, kAdcolonyPlacementName, kTTPlacementName, kTTVideoPlacement, kAppnextPlacement, kBaiduPlacement, kOguryPlacement,kFyberPlacement,kHeliumPlacement,kAllPlacementName],
                        @[kGAMPlacement,kChartboostPlacementName, kVunglePlacementName, kAdcolonyPlacementName, kStartAppPlacement, kHeaderBiddingPlacement,kNendPlacement, kFacebookPlacement, kMintegralPlacement, kAdMobPlacement, kInmobiPlacement, kApplovinPlacement, kGDTPlacement, kTTPlacementName, kAppnextPlacement, kBaiduPlacement, kFyberPlacement, kStartAppPlacement,kUnityAdsPlacementName, kAllPlacementName],
                        @[kGAMPlacement, kStartAppPlacement, kMyOfferPlacement, kSigmobPlacement,kKSPlacement, kHeaderBiddingPlacement, kNendPlacement, kMaioPlacement, kFacebookPlacement, kAdMobPlacement, kInmobiPlacement, kApplovinPlacement, kMintegralPlacement, kGDTPlacement, kChartboostPlacementName, kTapjoyPlacementName, kIronsourcePlacementName, kVunglePlacementName, kAdcolonyPlacementName, kUnityAdsPlacementName, kTTPlacementName, kAppnextPlacement, kBaiduPlacement, kOguryPlacement, kFyberPlacement,kHeliumPlacement, kAllPlacementName],
                        @[kMyOfferPlacement, kGAMPlacement, kHeaderBiddingPlacement, kNendPlacement, kNendVideoPlacement, kTTFeedPlacementName, kTTDrawPlacementName, kMPPlacement, kFacebookPlacement, kAdMobPlacement, kInmobiPlacement, kApplovinPlacement, kMintegralPlacement, kGDTPlacement, kGDTTemplatePlacement, kAppnextPlacement, kBaiduPlacement, kKSPlacement,kKSDrawPlacement, kAllPlacementName],
                        @[kNendPlacement, kTTFeedPlacementName, kTTDrawPlacementName, kMPPlacement, kFacebookPlacement, kAdMobPlacement, kInmobiPlacement, kApplovinPlacement, kMintegralPlacement, kGDTPlacement, kGDTTemplatePlacement, kAppnextPlacement, kAllPlacementName],
                        @[kTTFeedPlacementName, kMPPlacement, kFacebookPlacement, kAdMobPlacement, kApplovinPlacement, kMintegralPlacement, kGDTPlacement, kAppnextPlacement, kAllPlacementName]];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"GDPR" style:UIBarButtonItemStylePlain target:self action:@selector(policyButtonTapped)];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerBannerEvent:) name:kBannerShownNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlerBannerEvent:) name:kBannerLoadingFailedNotification object:nil];
}


-(void)policyButtonTapped {
    [[ATAPI sharedInstance] presentDataConsentDialogInViewController:self dismissalCallback:^{
        
    }];
}

/**
 extern NSString *const kATSplashExtraGDTAppID;
 extern NSString *const kATSplashExtraGDTUnitID;
 #pragma mark - TT
 extern NSString *const kATSplashExtraAppID;
 extern NSString *const kATSplashExtraSlotID;
 extern NSString *const kATSplashExtraPersonalizedTemplateFlag;
 #pragma mark - Baidu
 extern NSString *const kATSplashExtraBaiduAppID;
 extern NSString *const kATSplashExtraBaiduAdPlaceID;
 #pragma mark - Sibmob
 extern NSString *const kATSplashExtraSigmobAppKey;
 extern NSString *const kATSplashExtraSigmobAppID;
 extern NSString *const kATSplashExtraSigmobPlacementID;
 */

NSDictionary *SplashInfo(NSInteger row) {
    NSTimeInterval tolerateTimeout = 5.0f;
    return @{
        //mintegral
        @0:@{kATSplashExtraNetworkFirmID:@6,
             kATSplashExtraAdSourceIDKey:@"72004",
             kATSplashExtraMintegralAppID:@"104036",
             kATSplashExtraMintegralAppKey:@"ef13ef712aeb0f6eb3d698c4c08add96",
             kATSplashExtraMintegralUnitID:@"275050",
             kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
        },
        //sigmob
        @1:@{kATSplashExtraNetworkFirmID:@29,
             kATSplashExtraAdSourceIDKey:@"72008",
             kATSplashExtraSigmobAppKey:@"c8bee8e83f296c2a",
             kATSplashExtraSigmobAppID:@"1830",
             kATSplashExtraSigmobPlacementID:@"e430bc36052",
             kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
        },
        //gdt
        @2:@{kATSplashExtraNetworkFirmID:@8,
             kATSplashExtraAdSourceIDKey:@"71998",
             kATSplashExtraGDTAppID:@"1105344611",
             kATSplashExtraGDTUnitID:@"9040714184494018",
             kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
        },
        //baidu
        @3:@{kATSplashExtraNetworkFirmID:@22,
             kATSplashExtraAdSourceIDKey:@"72010",
             kATSplashExtraBaiduAppID:@"ccb60059",
             kATSplashExtraBaiduAdPlaceID:@"2058492",
             kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
        },
        //tt
        @4:@{kATSplashExtraNetworkFirmID:@15,
             kATSplashExtraAdSourceIDKey:@"71991",
             kATSplashExtraAppID:@"5015421",
             kATSplashExtraSlotID:@"815421339",
             kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
        },
        @5:@{kATSplashExtraNetworkFirmID:@2,
             kATSplashExtraAdSourceIDKey:@"145203",
             kATSplashExtraAdmobAppID:@"ca-app-pub-9488501426181082~6772985580,",
             kATSplashExtraAdmobUnitID:@"ca-app-pub-3940256099942544/1033173712",
             kATSplashExtraAdmobOrientation:@(1),
             kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
        },//admob
        @6:@{kATSplashExtraNetworkFirmID:@6,
             kATSplashExtraAdSourceIDKey:@"72004",
             kATSplashExtraMintegralAppID:@"104036",
             kATSplashExtraMintegralAppKey:@"ef13ef712aeb0f6eb3d698c4c08add96",
             kATSplashExtraMintegralUnitID:@"275050",
             kATSplashExtraTolerateTimeoutKey:@(tolerateTimeout)
        }
    }[@(row)];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [_placementNames count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_placementNames[section] count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0f;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @[@"Splash", @"Interstitial", @"Banner", @"RV", @"Native", @"Native Banner", @"Native Splash"][section];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.text = _placementNames[[indexPath section]][[indexPath row]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([indexPath section] == 3) {
        ATRewardedVideoVideoViewController *tVC = [[ATRewardedVideoVideoViewController alloc] initWithPlacementName:_placementNames[[indexPath section]][[indexPath row]]];
        [self.navigationController pushViewController:tVC animated:YES];
    } else if ([indexPath section] == 6) {
        [ATNativeSplashWrapper loadNativeSplashAdWithPlacementID:[ATNativeViewController nativePlacementIDs][_placementNames[[indexPath section]][[indexPath row]]] extra:@{kExtraInfoNativeAdTypeKey:@(ATGDTNativeAdTypeSelfRendering), kExtraInfoNativeAdSizeKey:[NSValue valueWithCGSize:CGSizeMake(CGRectGetWidth(self.view.bounds) - 30.0f, 400.0f)], kATExtraNativeImageSizeKey:kATExtraNativeImageSize690_388, kATNativeSplashShowingExtraCountdownIntervalKey:@3} customData:nil delegate:self];
    } else if ([indexPath section] == 5) {
        ATNativeBannerViewController *tVC = [[ATNativeBannerViewController alloc] initWithPlacementName: _placementNames[[indexPath section]][[indexPath row]]];
        [self.navigationController pushViewController:tVC animated:YES];
    } else if ([indexPath section] == 4) {
        if (_placementNames[[indexPath section]][[indexPath row]] == kKSDrawPlacement || _placementNames[[indexPath section]][[indexPath row]] == kTTDrawPlacementName) {
            ATDrawViewController *drawVC = [[ATDrawViewController alloc] initWithPlacementName:_placementNames[[indexPath section]][[indexPath row]]];
            drawVC.modalPresentationStyle = 0;
            [self presentViewController:drawVC animated:YES completion:nil];
        } else {
            ATNativeViewController *tVC = [[ATNativeViewController alloc] initWithPlacementName: _placementNames[[indexPath section]][[indexPath row]]];
            [self.navigationController pushViewController:tVC animated:YES];
        }
    } else if ([indexPath section] == 2) {
        ATBannerViewController *tVC = [[ATBannerViewController alloc] initWithPlacementName:_placementNames[[indexPath section]][[indexPath row]]];
        [self.navigationController pushViewController:tVC animated:YES];
    } else if ([indexPath section] == 1) {
        ATInterstitialViewController *tVC = [[ATInterstitialViewController alloc] initWithPlacementName:_placementNames[[indexPath section]][[indexPath row]]];
        [self.navigationController pushViewController:tVC animated:YES];
    } else if ([indexPath section] == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(.0f, .0f, CGRectGetWidth([UIScreen mainScreen].bounds), 100.0f)];
        label.text = @"Splash Container View";
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;

        UILabel *skipBtn = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 80.0f, CGRectGetMidY(self.view.bounds) - 40.0f, 160.0f, 80.0f)];
        skipBtn.text = @"Skip Button";
        skipBtn.backgroundColor = [UIColor blueColor];
        skipBtn.textAlignment = NSTextAlignmentCenter;
        UIWindow *mainWindow = nil;
        if ( @available(iOS 13.0, *) ) {
           mainWindow = [UIApplication sharedApplication].windows.firstObject;
           [mainWindow makeKeyWindow];
           [[ATAdManager sharedManager] loadADWithPlacementID:@[@"b5ee89f9859d05", @"b5d771f34bc73d", @"b5c1b0470c7e4a", @"b5c1b047a970fe", @"b5c1b048c498b9", @"b5f842af26114c", @"b5c22f0e5cc7a0", @"b5f33c33431ca0"][[indexPath row]] extra:SplashInfo(indexPath.row) customData:nil delegate:self window:mainWindow windowScene:mainWindow.windowScene containerView:label];
        } else {
            mainWindow = [UIApplication sharedApplication].keyWindow;
            [[ATAdManager sharedManager] loadADWithPlacementID:@[@"b5ee89f9859d05", @"b5d771f34bc73d", @"b5c1b0470c7e4a", @"b5c1b047a970fe", @"b5c1b048c498b9", @"b5f842af26114c", @"b5c22f0e5cc7a0", @"b5f33c33431ca0"][[indexPath row]] extra:SplashInfo(indexPath.row) customData:nil delegate:self window:mainWindow containerView:label];
        }
    }
}

#pragma mark - native splash delegate(s)
#define PORTRAIT 1
-(void) finishLoadingNativeSplashAdForPlacementID:(NSString*)placementID {
    NSLog(@"AppDelegate::finishLoadingNativeSplashAdForPlacementID:%@", placementID);
#ifdef PORTRAIT
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(.0f, .0f, width, 79.0f)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"Joypac";
    [ATNativeSplashWrapper showNativeSplashAdWithPlacementID:placementID extra:@{kATNatievSplashShowingExtraStyleKey:kATNativeSplashShowingExtraStylePortrait, kATNativeSplashShowingExtraCountdownIntervalKey:@3, kATNativeSplashShowingExtraContainerViewKey:label} delegate:self];
#else
    CGFloat width = 100.0f;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - width, .0f, width, CGRectGetHeight([UIScreen mainScreen].bounds))];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"Joypac";
    [ATNativeSplashWrapper showNativeSplashAdWithPlacementID:placementID extra:@{kATNatievSplashShowingExtraStyleKey:kATNativeSplashShowingExtraStyleLandscape, kATNativeSplashShowingExtraCountdownIntervalKey:@3, kATNativeSplashShowingExtraContainerViewKey:label} delegate:self];
#endif
    
}

-(void) failedToLoadNativeSplashAdForPlacementID:(NSString*)placementID error:(NSError*)error {
    NSLog(@"AppDelegate::failedToLoadNativeSplashAdForPlacementID:%@ error:%@", placementID, error);
}

#pragma mark - splash delegate with networkID and adsourceID
-(void)didShowNativeSplashAdForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"AppDelegate::splashDidShowForPlacementID:%@ with extra: %@", placementID,extra);
}

-(void)didClickNaitveSplashAdForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"AppDelegate::splashDidClickForPlacementID:%@ with extra: %@", placementID,extra);
}

-(void)didCloseNativeSplashAdForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"AppDelegate::splashDidCloseForPlacementID:%@ with extra: %@", placementID,extra);
}



#pragma mark - AT Splash Delegate method(s)
-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"AppDelegate::didFinishLoadingADWithPlacementID:%@", placementID);
}

-(void) didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    NSLog(@"AppDelegate::didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
}
-(void)splashDidShowForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"AppDelegate::splashDidShowForPlacementID:%@ with extra: %@", placementID,extra);
    
}

-(void)splashDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"AppDelegate::splashDidClickForPlacementID:%@ with extra: %@", placementID,extra);
    
}

-(void)splashDidCloseForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"AppDelegate::splashDidCloseForPlacementID:%@ with extra: %@", placementID,extra);
}

@end
