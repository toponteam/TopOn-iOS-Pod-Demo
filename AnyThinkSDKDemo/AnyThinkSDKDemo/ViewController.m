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
#import "ATSplashViewController.h"
#import "ATDrawViewController.h"
#import <AnyThinkSplash/AnyThinkSplash.h>
#import <AnyThinkNative/AnyThinkNative.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

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

- (void)viewDidAppear:(BOOL)animated{
    if (@available(iOS 14, *)) {
//         iOS 14
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
        }];
    } else {
        // Fallback on earlier versions
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getProxyStatus];
    /*
     extern const CGFloat FBAdOptionsViewWidth;
     extern const CGFloat FBAdOptionsViewHeight;
     */
    _placementNames = @[
        
                        // Splash
                        @[kMintegralPlacement, kSigmobPlacement, kGDTPlacement, kGDTZoomOutPlacement, kBaiduPlacement, kTTPlacementName, kAdMobPlacement, kKSPlacement, kAllPlacementName, kMyOfferPlacement,kKlevinPlacement,kDirectOfferPlacement],
                        
                        //Interstitial
                        @[kGAMPlacement,kStartAppPlacement, kStartAppVideoPlacement, kSigmobRVIntPlacement, kSigmobPlacement, kMyOfferPlacement, kOguryPlacement,kKSPlacement, kHeaderBiddingPlacement, kNendPlacement, kNendInterstitialVideoPlacement, kNendFullScreenInterstitialPlacement, kMaioPlacement, kUnityAdsPlacementName, kFacebookPlacement, kAdMobPlacement, kInmobiPlacement, kApplovinPlacement, kMintegralPlacement, kMintegralVideoPlacement, kMopubPlacementName, kGDTPlacement, kChartboostPlacementName, kTapjoyPlacementName, kIronsourcePlacementName, kVunglePlacementName, kAdcolonyPlacementName, kTTPlacementName, kTTVideoPlacement, kAppnextPlacement, kBaiduPlacement, kFyberPlacement, kHeliumPlacement, kKidozPlacement, kMyTargetPlacement,kAllPlacementName,kKlevinPlacement,kDirectOfferPlacement],
                        
                        // Banner
                        @[kGAMPlacement,kChartboostPlacementName, kVunglePlacementName, kAdcolonyPlacementName, kStartAppPlacement, kHeaderBiddingPlacement,kNendPlacement, kFacebookPlacement, kMintegralPlacement,kAdMobPlacement, kInmobiPlacement, kApplovinPlacement, kGDTPlacement, kMopubPlacementName, kTTPlacementName, kAppnextPlacement, kBaiduPlacement, kFyberPlacement, kUnityAdsPlacementName, kMyOfferPlacement,kKidozPlacement, kMyTargetPlacement, kAllPlacementName,kDirectOfferPlacement],
                        
                        // RV
                        @[kGAMPlacement,kStartAppPlacement, kSigmobPlacement, kMyOfferPlacement, kOguryPlacement,kKSPlacement, kHeaderBiddingPlacement, kNendPlacement, kMaioPlacement, kFacebookPlacement, kAdMobPlacement, kInmobiPlacement, kApplovinPlacement, kMintegralPlacement, kMopubPlacementName, kGDTPlacement, kChartboostPlacementName, kTapjoyPlacementName, kIronsourcePlacementName, kVunglePlacementName, kAdcolonyPlacementName, kUnityAdsPlacementName, kTTPlacementName, kAppnextPlacement, kBaiduPlacement, kFyberPlacement, kHeliumPlacement,kKidozPlacement, kMyTargetPlacement, kAllPlacementName,kKlevinPlacement,kDirectOfferPlacement],
                        
                        // Native
                        @[kMyOfferPlacement, kGAMPlacement,kMintegralAdvancedPlacement, kHeaderBiddingPlacement, kNendPlacement, kNendVideoPlacement, kTTFeedPlacementName, kTTDrawPlacementName, kMPPlacement, kFacebookPlacement, kAdMobPlacement, kInmobiPlacement, kApplovinPlacement, kMintegralPlacement, kMopubPlacementName, kGDTPlacement, kGDTTemplatePlacement, kAppnextPlacement, kBaiduPlacement,kKSPlacement,kKSDrawPlacement,kSigmobPlacement, kAllPlacementName,kDirectOfferPlacement],
                        
                        // Native Banner
                        @[kKSPlacement,kNendPlacement, kTTFeedPlacementName, kTTDrawPlacementName, kMPPlacement, kFacebookPlacement, kAdMobPlacement, kInmobiPlacement, kApplovinPlacement, kMintegralPlacement, kMopubPlacementName, kGDTPlacement, kGDTTemplatePlacement, kAppnextPlacement,kAllPlacementName],
                        
                        // Native Splash
                        @[kKSPlacement,kTTFeedPlacementName, kMPPlacement, kFacebookPlacement, kAdMobPlacement, kApplovinPlacement, kMintegralPlacement, kGDTPlacement, kAppnextPlacement, kAllPlacementName]];
    
    
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
    //        If the users are not in mainland China, you need to call the following codes. Before this, please make sure that the authorization pop-up window of AppTrackingTransparency has popped up correctly, refer to the link: https://docs.toponad.com/#/en-us/ios/ios_doc/ios_sdk_config_access?id=_24-ios-15-support
    [[ATAPI sharedInstance] presentDataConsentDialogInViewController:self dismissalCallback:^{
        
    }];
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
        [ATNativeSplashWrapper loadNativeSplashAdWithPlacementID:[ATNativeViewController nativePlacementIDs][_placementNames[[indexPath section]][[indexPath row]]] extra:@{kATExtraInfoNativeAdTypeKey:@(ATGDTNativeAdTypeSelfRendering), kATExtraInfoNativeAdSizeKey:[NSValue valueWithCGSize:CGSizeMake(CGRectGetWidth(self.view.bounds) - 30.0f, 400.0f)], kATExtraNativeImageSizeKey:kATExtraNativeImageSize690_388, kATNativeSplashShowingExtraCountdownIntervalKey:@3} customData:nil delegate:self];
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
            ATSplashViewController *tVC = [[ATSplashViewController alloc] initWithPlacementName:_placementNames[[indexPath section]][[indexPath row]]];
            [self.navigationController pushViewController:tVC animated:YES];
    }
}

@end
