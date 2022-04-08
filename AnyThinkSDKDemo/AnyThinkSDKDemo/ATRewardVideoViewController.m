//
//  ATReWardVideoViewController.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/6.
//

#import "ATRewardVideoViewController.h"
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
#import "ATModelButton.h"
#import "ATSuspendedButton.h"
#import "ATInterstitialViewController.h"
#import "ATSplashViewController.h"

@interface ATRewardVideoViewController () <ATAdLoadingDelegate, ATRewardedVideoDelegate>
@property (nonatomic, strong) ATModelButton *modelButton;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *modelBackView;
@property (nonatomic, strong) ATSuspendedButton *suspendedBtn;

@property(nonatomic, strong) ATInterstitialViewController *interstitialViewController;

@property(nonatomic, strong) NSString *selectMenuStr;
@property(nonatomic, strong) NSString *togetherLoadAdStr;
@property(nonatomic,assign) bool isAuto;

@end

@implementation ATRewardVideoViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kRGB(245, 245, 245);
    self.title = @"Reward Video";
    [self setupData];
    [self setupUI];
    [ATRewardedVideoAutoAdManager sharedInstance].delegate = self;

    self.interstitialViewController = [[ATInterstitialViewController alloc]init];
}


- (NSDictionary<NSString *,NSString *> *)placementIDs{
    
    return @{
//        @"GAM":         @"b5f23897bba4ca",
//        @"StartApp":    @"b5e7319f619931",
        @"Mintegral":   @"b5b44a07fc3bf6",
        @"GDT":         @"b5c0f7cd196a4c",
        @"Sigmob":      @"b5d771f5a3458f",
//        @"Myoffer":     @"b5db6c247dbb1e",
//        @"Ogury":       @"b5dde2379dc6ce",
        @"KS":          @"b5d807a31aa7dd",
        @"HeaderBidding":@"b5d13341598199",
        @"Nend":        @"b5cb96d6f68fdb",
        @"Maio":        @"b5cb96ce0b931e",
        @"Facebook":    @"b5b44a02112383",
        @"AdMob":       @"b5b44a02bf08c0",
        @"Inmobi":      @"b5b44a03522f92",
        @"Applovin":    @"b5b44a0646e64b",
   
        @"Mopub":       @"b5b44a088ba48d",
       
        @"Chartboost":  @"b5b44a09a5c912",
//        @"Tapjoy":      @"b5b44a0ac855ff",
        @"Ironsource":  @"b5b44a0bf09475",
        @"Vungle":      @"b5b44a0d05d707",
        @"Adcolony":    @"b5b44a0de295ad",
        @"Unity Ads":   @"b5b44a0c7b9b64",
        @"TT":          @"b5b72b21184aa8",
        @"Pangle":      @"b612f6a907a7d1",
        @"Appnext":     @"b5bc7fb4fd15e6",
        @"Baidu":       @"b5c04dd81c1af3",
        @"Fyber":       @"b5e96db106d8f2",
        @"Helium":      @"b5f583ea323756",
        @"ADX":         @"b5fa2500639c86",
        @"OnlineApi":   @"b5fa250b176abb",
        @"Kidoz":       @"b5feaa2c0a6191",
        @"MyTarget":    @"b5feaa2f32f161",
        @"All":         @"b5b44a0f115321",
        @"Gromore":     @"b601cac7bb1a21",
        @"Max":         @"b603ef4c3365d8",
        @"Klevin":      @"b613affe9af84c",
        @"DirectOffer": @"b61bffca756796",
    };
}

- (void)setupData
{
    self.placementID = self.placementIDs.allValues.firstObject;
}

- (void)setupUI
{
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
    [self.view addSubview:self.suspendedBtn];
    
    [self.modelBackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
    }];
    
    [self.modelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScaleW(340));
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.modelBackView.mas_top);
    }];

    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(242));
        make.top.equalTo(self.modelBackView.mas_bottom).offset(kScaleW(20));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(kScaleW(20));
        make.bottom.equalTo(self.footView.mas_top).offset(kScaleW(-20));
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.centerX.equalTo(self.view.mas_centerX);
    }];

    [self.footView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kScaleW(340));
    }];
    
    [self.suspendedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kScaleW(100));
        make.top.equalTo(self.view.mas_top).offset(kScaleW(200));
        make.right.equalTo(self.view.mas_right);
    }];
}

#pragma mark - together load
- (void)togetherLoadAd:(NSString *)togetherLoadAdStr{
    self.togetherLoadAdStr = togetherLoadAdStr;
    NSLog(@"同时加载激励视频广告位---%@",self.placementID);

    if (self.placementID) {
        [self loadAd];
    }
}

- (NSString *)placementID{
    if (self.togetherLoadAdStr.length) {
        
        NSString *tempID = self.placementIDs[self.togetherLoadAdStr];
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
- (void)loadAd
{
    NSDictionary *dict = @{
        kATAdLoadingExtraMediaExtraKey:@"media_val", kATAdLoadingExtraUserIDKey:@"rv_test_user_id",kATAdLoadingExtraRewardNameKey:@"reward_Name",kATAdLoadingExtraRewardAmountKey:@(3),
        kATExtraInfoRootViewControllerKey:self,
//        kATRewardedVideoKlevinRewardTriggerKey : @1,
//        kATRewardedVideoKlevinRewardTimeKey : @3,
    };
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:dict delegate:self];
}



- (void)checkAd
{
    [[ATAdManager sharedManager] checkRewardedVideoLoadStatusForPlacementID:self.placementID];
    // list
    NSArray *array = [[ATAdManager sharedManager] getRewardedVideoValidAdsForPlacementID:self.placementID];
    
    NSLog(@"ValidAds.count:%ld--- ValidAds:%@",array.count,array);

    BOOL isready = [[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:self.placementID];
    
    if (self.isAuto) {
        isready   =   [[ATRewardedVideoAutoAdManager sharedInstance]autoLoadRewardedVideoReadyForPlacementID:self.placementID];
        
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:isready ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];

    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void)showAd
{
    
    if (self.isAuto) {
        [[ATRewardedVideoAutoAdManager sharedInstance]  showAutoLoadRewardedVideoWithPlacementID:self.placementID scene:@"f5e549727efc49" inViewController:self delegate:self];
    }else
    [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:self.placementID scene:@"f5e54970dc84e6" inViewController:self delegate:self];
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

- (void)clearLog
{
    self.textView.text = @"";
}

-(void)setToAutoLoadMode{
  
    self.textView.hidden = true;
    self.menuView.hidden = true;
    self.suspendedBtn.hidden = true;
    self.footView.loadBtn.hidden = true;
}

-(void)checkAutoLoad{
    
    Class class = NSClassFromString(@"ATRewardVideoAutoAdViewController");
    UIViewController *con = [class new];
    [con setValue:self.placementID forKey:@"placementID"];
    [self.navigationController pushViewController:con animated:YES];
    
}

#pragma mark - loading delegate
- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--AD--开始--ATRewardVideoViewController::didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
//    [self showLog:[NSString stringWithFormat:@"didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--AD--完成--ATRewardVideoViewController::didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
    
//    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    
}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--AD--失败--ATRewardVideoViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
    
//    [self showLog:[NSString stringWithFormat:@"didFailToLoadADSourceWithPlacementID:%@--%@", placementID],error];
    
}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--bid--开始--ATRewardVideoViewController::didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
    
//    [self showLog:[NSString stringWithFormat:@"didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--bid--完成--ATRewardVideoViewController::didFinishBiddingADSourceWithPlacementID:%@--extra:%@", placementID,extra);
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
    
//    [self showLog:[NSString stringWithFormat:@"didFinishBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    
    NSLog(@"广告源--bid--失败--ATRewardVideoViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
    
//    [self showLog:[NSString stringWithFormat:@"didFailBiddingADSourceWithPlacementID:%@", placementID]];
}


-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"ATRewardedVideoViewController::didFinishLoadingADWithPlacementID:%@", placementID);
    
    [self showLog:[NSString stringWithFormat:@"didFinishLoading:%@", placementID]];
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    
    NSLog(@"ATRewardedVideoViewController::didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    
    [self showLog:[NSString stringWithFormat:@"didFailToLoad:%@ errorCode:%ld", placementID, (long)error.code]];
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

#pragma mark - showing delegate
-(void) rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidRewardSuccessForPlacemenID:%@ extra:%@",placementID,extra);
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidRewardSuccess:%@", placementID]];
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidStartPlayingForPlacementID:%@ extra:%@", placementID, extra);
    UIViewController *vc = self.presentedViewController;
    vc = nil;
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidStartPlaying:%@", placementID]];
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}


-(void) rewardedVideoDidEndPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidEndPlaying:%@", placementID]];
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) rewardedVideoDidFailToPlayForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidFailToPlayForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidFailToPlay:%@ errorCode:%ld", placementID, (long)error.code]];
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

-(void) rewardedVideoDidCloseForPlacementID:(NSString*)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidCloseForPlacementID:%@, rewarded:%@ extra:%@", placementID, rewarded ? @"yes" : @"no", extra);
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidClose:%@, rewarded:%@", placementID, rewarded ? @"yes" : @"no"]];
}


-(void) rewardedVideoDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidClickForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidClick:%@", placementID]];
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

- (void)rewardedVideoDidDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATRewardedVideoViewController:: rewardedVideoDidDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidDeepLinkOrJump:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
    
    [self.suspendedBtn recordWithPlacementId:self.placementID protocol:NSStringFromSelector(_cmd)];
}

// rewarded video again
-(void) rewardedVideoAgainDidStartPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoAgainDidStartPlayingForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidStartPlaying:%@", placementID]];
}

-(void) rewardedVideoAgainDidEndPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoAgainDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidEndPlaying:%@", placementID]];
}

-(void) rewardedVideoAgainDidFailToPlayForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary*)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoAgainDidFailToPlayForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidFailToPlay:%@ errorCode:%ld", placementID, (long)error.code]];
}

-(void) rewardedVideoAgainDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary*)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoAgainDidClickForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidClick:%@", placementID]];
}

-(void) rewardedVideoAgainDidRewardSuccessForPlacemenID:(NSString*)placementID extra:(NSDictionary*)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoAgainDidRewardSuccessForPlacemenID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"rewardedVideoAgainDidRewardSuccess:%@", placementID]];
}

#pragma mark - lazy
- (ATADFootView *)footView
{
    if (!_footView) {
        _footView = [[ATADFootView alloc] init];
//        _footView = [[ATADFootView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(340))];
//        _footView.removeBtn.hidden = YES;
//
//        _footView.showBtn.frame = CGRectMake(kScaleW(26), kScaleW(230), (kScreenW - kScaleW(52)), kScaleW(90));

        if (![NSStringFromClass([self class]) containsString:@"Auto"]) {
            [_footView.loadBtn setTitle:@"Load Rewarded Video AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is Rewarded Video AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show Rewarded Video AD" forState:UIControlStateNormal];
        }
      
        
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
//        _modelButton = [[ATModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _modelButton = [[ATModelButton alloc] init];
        _modelButton.backgroundColor = [UIColor whiteColor];
        _modelButton.modelLabel.text = @"Reward Video";
        _modelButton.image.image = [UIImage imageNamed:@"rewarded video"];
    }
    return _modelButton;
}

- (ATMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[ATMenuView alloc] initWithMenuList:self.placementIDs.allKeys subMenuList:nil];
        _menuView.turnAuto = true;
        _menuView.layer.masksToBounds = YES;
        _menuView.layer.cornerRadius = 5;
        __weak typeof(self) weakSelf = self;
        [_menuView setSelectMenu:^(NSString * _Nonnull selectMenu) {
            
            
            weakSelf.placementID = weakSelf.placementIDs[selectMenu];
            NSLog(@"select placementId:%@", weakSelf.placementID);
            weakSelf.selectMenuStr = selectMenu;
            
            
            [weakSelf turnOnAuto:false];
            
      
        }];
        
        [_menuView setTurnOnAuto:^(Boolean isOn) {
            
            [weakSelf turnOnAuto:isOn];
            
            
        }];
        
    }
    return _menuView;
}

-(void)turnOnAuto:(Boolean)isOn {
    self.footView.loadBtn.hidden = isOn;
    if (isOn) {
       
        [[ATRewardedVideoAutoAdManager sharedInstance]addAutoLoadAdPlacementIDArray:@[self.placementID]];
    }
    else{
        [[ATRewardedVideoAutoAdManager sharedInstance]removeAutoLoadAdPlacementIDArray:@[self.placementID]];
    }
    self.isAuto = isOn;
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

- (ATSuspendedButton *)suspendedBtn
{
    if (!_suspendedBtn) {
        _suspendedBtn = [[ATSuspendedButton alloc] initWithProtocolList:@[@"ATAdLoadingDelegate", @"ATRewardedVideoDelegate"]];
        [_suspendedBtn setImage:[UIImage imageNamed:@"topon_logo"] forState:UIControlStateNormal];
        _suspendedBtn.layer.masksToBounds = YES;
        _suspendedBtn.layer.cornerRadius = kScaleW(50);
        _suspendedBtn.layer.borderWidth = kScaleW(1);
        _suspendedBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    return _suspendedBtn;
}


@end