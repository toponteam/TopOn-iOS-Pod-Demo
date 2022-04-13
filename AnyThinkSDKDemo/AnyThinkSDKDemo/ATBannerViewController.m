//
//  ATBannerViewController.m
//  AnyThinkSDKDemo
//
//  Created by Martin Lau on 19/09/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import "ATBannerViewController.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkBanner/AnyThinkBanner.h>

#import "ATADFootView.h"
#import "ATModelButton.h"
#import "ATMenuView.h"

//#import <GoogleMobileAds/GoogleMobileAds.h>

static NSString *const kGDTPlacementID = @"b5bacad0803fd1";
static NSString *const kTTPlacementID = @"b5bacacfc470c9";
static NSString *const kAdmobPlacementID = @"b5bacacef17717";
static NSString *const kApplovinPlacementID = @"b5bacace1549da";
static NSString *const kFacebookPlacementID = @"b5baf502bb23e3";

static NSString *const kInmobiPlacementID = @"b5baf522891992";
static NSString *const kAllPlacementID = @"b5bacaccb61c29";
static NSString *const kAppnextPlacementID = @"b5bc7fb78288e9";
static NSString *const kBaiduPlacementID = @"b5c04dda229f7e";
static NSString *const kUnityAdsPlacementID = @"b5c21a04406722";
static NSString *const kNendPlacementID = @"b5cb96d97400b3";
static NSString *const kMintegralPlacementID = @"b5dd363166a5ea";
static NSString *const kBannerHeaderBiddingPlacementID = @"b5d146f9483215";
static NSString *const kFyberPlacementID = @"b5e96db4cb0682";
static NSString *const kStartAppPlacementID = @"b5ed47a285a23a";
static NSString *const kChartboostPlacementID = @"b5ee89f1a7eaf2";
static NSString *const kVunglePlacementID = @"b5ee89f3e63d80";
static NSString *const kAdColonyPlacementID = @"b5ee89f4d1791e";
static NSString *const kGAMPlacementID = @"b5f2389932a2ec";
static NSString *const kMyofferPlacementID = @"b5f33c3231eb91";
static NSString *const kKidozPlacementID = @"b5feaa2cfe2959";
static NSString *const kMyTargetPlacementID = @"b5feaa31284737";
static NSString *const kDirectOfferPlacementID = @"b61bfff452d054";


NSString *const kBannerShownNotification = @"banner_shown";
NSString *const kBannerLoadingFailedNotification = @"banner_failed_to_load";
@interface ATBannerViewController ()<ATBannerDelegate>
@property (nonatomic, strong) ATADFootView *footView;

@property (nonatomic, strong) UIView *modelBackView;

@property (nonatomic, strong) ATModelButton *modelButton;

@property (nonatomic, strong) ATMenuView *menuView;

@property (nonatomic, strong) UITextView *textView;

@property (copy, nonatomic) NSString *placementID;

@property (nonatomic, strong) UIView *adView;


@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs;

@property(nonatomic, strong) NSString *togetherLoadAdStr;
@property(nonatomic, readonly) CGSize adSize;
@end

@implementation ATBannerViewController

-(instancetype)init{
    self = [super init];
    _placementIDs = @{
                      kGDTPlacement:kGDTPlacementID,
                      kTTPlacementName:kTTPlacementID,
                      kAdMobPlacement:kAdmobPlacementID,
                      kApplovinPlacement:kApplovinPlacementID,
                      kFacebookPlacement:kFacebookPlacementID,
                      kInmobiPlacement:kInmobiPlacementID,
                      kAllPlacementName:kAllPlacementID,
                      kAppnextPlacement:kAppnextPlacementID,
                      kBaiduPlacement:kBaiduPlacementID,
                      kUnityAdsPlacementName:kUnityAdsPlacementID,
                      kNendPlacement:kNendPlacementID,
                      kMintegralPlacement:kMintegralPlacementID,
                      kHeaderBiddingPlacement:kBannerHeaderBiddingPlacementID,
                      kFyberPlacement:kFyberPlacementID,
                      kStartAppPlacement:kStartAppPlacementID,
                      kVunglePlacementName:kVunglePlacementID,
                      kChartboostPlacementName:kChartboostPlacementID,
                      kAdcolonyPlacementName:kAdColonyPlacementID,
                      kGAMPlacement:kGAMPlacementID,
                      kMyOfferPlacement:kMyofferPlacementID,
                      kKidozPlacement:kKidozPlacementID,
                      kMyTargetPlacement:kMyTargetPlacementID,
                      kDirectOfferPlacement:kDirectOfferPlacementID

                      };
    
    _placementID = [[_placementIDs allValues]firstObject];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRGB(245, 245, 245);
  
    self.title = @"Banner";
    
  
    
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [clearBtn setTitle:@"clear log" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    [self.view addSubview:self.modelBackView];
    [self.view addSubview:self.modelButton];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.footView];

    
    _adSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 250.0f);
    
    [self.modelBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
    }];
    
    [self.modelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScaleW(340));
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.modelBackView.mas_top);
    }];

    [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(242));
        make.top.equalTo(self.modelBackView.mas_bottom).offset(kScaleW(20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(20));
        make.bottom.equalTo(self.footView.mas_top).offset(kScaleW(-20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.footView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kScaleW(340));
    }];
    
   
}

- (void)clearLog
{
    self.textView.text = @"";
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeAdButtonTapped];
}



-(void) removeAdButtonTapped {
    
//    UIViewController *tVC = [[UIViewController alloc] init];
//    tVC.title = @"New VC";
//    tVC.view.backgroundColor = [UIColor redColor];
//    [self.navigationController pushViewController:tVC animated:YES];
//    return;
    
    [[self.view viewWithTag:3333] removeFromSuperview];
    NSLog(@"banner removed");
}

-(void) clearAdButtonTapped {
    ATBannerViewController *tVC = [[ATBannerViewController alloc]init];
    
    [self.navigationController pushViewController:tVC animated:YES];
}

-(void) dealloc {
    NSLog(@"ATBannerViewController::dealloc");
}

#pragma mark - Action
- (void)loadAd
{
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:@{kATAdLoadingExtraBannerAdSizeKey:[NSValue valueWithCGSize:_adSize], kATAdLoadingExtraBannerSizeAdjustKey:@NO} delegate:self];
}

- (void)checkAd
{
    // list
    NSArray *array = [[ATAdManager sharedManager] getBannerValidAdsForPlacementID:self.placementID];
    NSLog(@"ValidAds.count:%ld--- ValidAds:%@",array.count,array);

//    ATCheckLoadModel *model = [[ATAdManager sharedManager] checkBannerLoadStatusForPlacementID:self.placementID];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[ATAdManager sharedManager] bannerAdReadyForPlacementID:self.placementID] ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void)showAd
{
    if ([[ATAdManager sharedManager] bannerAdReadyForPlacementID:self.placementID]) {
        NSInteger tag = 3333;
        [[self.view viewWithTag:tag] removeFromSuperview];
        ATBannerView *bannerView = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:self.placementID scene:@"f600938d045dd3"];
        if (bannerView != nil) {
            bannerView.delegate = self;
            bannerView.presentingViewController = self;
            bannerView.translatesAutoresizingMaskIntoConstraints = NO;
            bannerView.tag = tag;
          
           
            self.adView = [[UIView alloc]init];// bannerView;
            self.adView.backgroundColor =  [UIColor colorWithRed:73/255.f green:109/255.f blue:255/255.f alpha:0.8f];
            [self.adView addSubview:bannerView];
            
            [self.view insertSubview:self.adView belowSubview:self.footView];
           
            
            [self.adView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(self.view);
                make.centerX.equalTo(self.view.mas_centerX);
                make.top.equalTo(self.view);
                make.bottom.equalTo(self.view);
                
            }];
            
            [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.adView).offset(100);
            }];
            
            
            
        }else {
            NSLog(@"BannerView is nil for placementID:%@", self.placementID);
        }
    } else {
        NSLog(@"Banner ad's not ready for placementID:%@", self.placementID);
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


#pragma mark - delegate method(s)
- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--AD--开始--ATBannerViewController::didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];

}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--AD--完成--ATBannerViewController::didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];

}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--AD--失败--ATBannerViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
    
//    [self showLog:[NSString stringWithFormat:@"didFailToLoadADSourceWithPlacementID:%@--%@", placementID],error];

}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--bid--开始--ATBannerViewController::didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
  
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--bid--完成--ATBannerViewController::didFinishBiddingADSourceWithPlacementID:%@--extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didFinishBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
 
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    
    NSLog(@"广告源--bid--失败--ATBannerViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
    
//    [self showLog:[NSString stringWithFormat:@"didFailBiddingADSourceWithPlacementID:%@", placementID]];
  
}

-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"ATBannerViewController::didFinishLoadingADWithPlacementID:%@", placementID);
    
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@", placementID]];
  
}

-(void) didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    NSLog(@"ATBannerViewController::didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    
    [self showLog:[NSString stringWithFormat:@"ATBannerViewController::didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];

}

-(void) bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSLog(@"ATBannerViewController::bannerView:failedToAutoRefreshWithPlacementID:%@ error:%@", placementID, error);
    
    [self showLog:[NSString stringWithFormat:@"bannerView:failedToAutoRefreshWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
    
}

#pragma mark - add networkID and adsourceID delegate
- (void)bannerView:(ATBannerView *)bannerView didDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATBannerViewController:: didDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    
    [self showLog:[NSString stringWithFormat:@"didDeepLinkOrJumpForPlacementID:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
 
}

-(void) bannerView:(ATBannerView*)bannerView didShowAdWithPlacementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATBannerViewController::bannerView:didShowAdWithPlacementID:%@ with extra: %@", placementID,extra);
    
    [self showLog:[NSString stringWithFormat:@"bannerView:didShowAdWithPlacementID:%@", placementID]];
    
}

-(void) bannerView:(ATBannerView*)bannerView didClickWithPlacementID:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATBannerViewController::bannerView:didClickWithPlacementID:%@ with extra: %@", placementID,extra);
    
    [self showLog:[NSString stringWithFormat:@"bannerView:didClickWithPlacementID:%@", placementID]];
   
}

-(void) bannerView:(ATBannerView*)bannerView didAutoRefreshWithPlacement:(NSString*)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATBannerViewController::bannerView:didAutoRefreshWithPlacement:%@ with extra: %@", placementID,extra);
    
    [self showLog:[NSString stringWithFormat:@"bannerView:didAutoRefreshWithPlacement:%@", placementID]];
  
}

-(void) bannerView:(ATBannerView*)bannerView didTapCloseButtonWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    NSLog(@"ATBannerViewController::bannerView:didTapCloseButtonWithPlacementID:%@ extra: %@", placementID,extra);
    
    [self.adView removeFromSuperview];
    self.adView = nil;
    
    [self showLog:[NSString stringWithFormat:@"bannerView:didTapCloseButtonWithPlacementID:%@", placementID]];

}

-(void) bannerDidShowForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    NSLog(@"ATBannerViewController::bannerDidShowForPlacementID:%@ with extra: %@", placementID,extra);
    
    [self showLog:[NSString stringWithFormat:@"bannerDidShowForPlacementID:%@", placementID]];
 
}

-(void) bannerDidCloseForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    NSLog(@"ATBannerViewController::bannerView:bannerDidCloseForPlacementID:%@ extra: %@", placementID,extra);
    
    [self showLog:[NSString stringWithFormat:@"bannerView:bannerDidCloseForPlacementID:%@", placementID]];
 
}

-(void) bannerDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    NSLog(@"ATBannerViewController::bannerDidClickForPlacementID:%@ with extra: %@", placementID,extra);
    
    [self showLog:[NSString stringWithFormat:@"bannerDidClickForPlacementID:%@", placementID]];
    
}

-(void) bannerDeepLinkOrJumpForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra result:(BOOL)success {
    NSLog(@"ATBannerViewController:: bannerDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    
    [self showLog:[NSString stringWithFormat:@"bannerDeepLinkOrJumpForPlacementID:placementID:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
 
}

#pragma mark - lazy
- (ATADFootView *)footView
{
    if (!_footView) {
//        _footView = [[ATADFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(340))];
        _footView = [[ATADFootView alloc] initWithRemoveBtn];
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
        [_footView setClickRemoveBlock:^{
            NSLog(@"点击移除");
            [weakSelf removeAd];
        }];
        
        if (![NSStringFromClass([self class]) containsString:@"Auto"]) {
            [_footView.loadBtn setTitle:@"Load Banner AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is Banner AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show Banner AD" forState:UIControlStateNormal];
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
        _modelButton.modelLabel.text = @"Banner";
        _modelButton.image.image = [UIImage imageNamed:@"banner"];
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
        _textView.text = @"";
    }
    return _textView;
}


@end
