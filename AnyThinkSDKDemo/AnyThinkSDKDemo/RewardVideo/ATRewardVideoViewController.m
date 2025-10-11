//
//  ATReWardVideoViewController.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/6.
//

#import "ATRewardVideoViewController.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import "ATModelButton.h"
#import "SDWebImage/SDWebImage.h"

@interface ATRewardVideoViewController () <ATRewardedVideoDelegate>
@property (nonatomic, strong) ATModelButton *modelButton;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *modelBackView;

@property(nonatomic, strong) NSString *selectMenuStr;

@property(nonatomic,assign) bool isAuto;

@end

@implementation ATRewardVideoViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Reward Video";
    self.view.backgroundColor = kRGB(245, 245, 245);
    
    [self setupData];
    [self setupUI];
    
    [ATRewardedVideoAutoAdManager sharedInstance].delegate = self;
}

- (NSDictionary<NSString *,NSString *> *)placementIDs {
    
    return @{
        @"Gromore":             @"b601cac7bb1a21",
        @"Sigmob":              @"b5d771f5a3458f",
        @"qumeng":              @"b66e2908738c11",
        @"ms":                  @"b681b03d05256e",
        @"ADX":                 @"b5fa2500639c86",
        @"Tanx":                @"b670641e772c5b",
        @"Baidu":               @"b5c04dd81c1af3",
        @"CSJ":                 @"b5b72b21184aa8",
        @"AdMob":               @"b5b44a02bf08c0",
        @"Inmobi":              @"b5b44a03522f92",
        @"Ironsource":          @"b5b44a0bf09475",
        @"Unity":               @"b5b44a0c7b9b64",
        @"Vungle":              @"b5b44a0d05d707",
        @"Mintegral":           @"b5b44a07fc3bf6",
        @"GDT":                 @"b5c0f7cd196a4c",
        @"Baidu_Native":        @"b68b7fe263956e",
        @"Gromore_Native":      @"b68b7fe23aea59",
        @"TT_Native":           @"b68b7fe2108c83",
        @"Sigmob_Native":       @"b68b7fe1eef564",
        @"KS_Native":           @"b68b7fe1c4e774",
        @"GDT_Native":          @"b68b7fe198907f",
        @"Kwai":                @"b65fd1ca2ac2c6", //TPN
        @"Bidmachine":          @"n67bbe78cc0e8b", //TPN
        @"Yandex":              @"b62d8baa342db2", //TPN
        @"Verve":               @"b635a45779fa24", //TPN
        @"Bigo":                @"b63802eb792ff4", //TPN
    };
}

- (void)setupData {
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
    [self.view addSubview:self.modelButton];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.footView];
    
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
}

#pragma mark - Action
// 加载广告
- (void)loadAd {
    NSDictionary *extra = @{
        /// 以下几个key参数适用于广告平台的服务端激励验证，将被透传
        kATAdLoadingExtraMediaExtraKey:@"media_val",
        kATAdLoadingExtraUserIDKey:@"rv_test_user_id",
        kATAdLoadingExtraRewardNameKey:@"reward_Name",
        kATAdLoadingExtraRewardAmountKey:@(3),
        
        /// 仅游可赢平台可用，当前准备展示广告的rootVC
//        kATExtraInfoRootViewControllerKey:self,
        /// 仅游可赢平台可用， 触发的激励类型，1：复活；2：签到；3：道具；4：虚拟货币；5：其他；不设置，则默认为5
//        kATRewardedVideoKlevinRewardTriggerKey : @1,
        /// 仅游可赢平台可用， 激励卡秒时长
//        kATRewardedVideoKlevinRewardTimeKey : @3,
    };
    
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:extra delegate:self];
}

// 检查广告缓存，是否iReady
- (void)checkAd {
    // 获取广告位的状态对象
    ATCheckLoadModel *checkLoadModel = [[ATAdManager sharedManager] checkRewardedVideoLoadStatusForPlacementID:self.placementID];
    NSLog(@"CheckLoadModel.isLoading:%d--- isReady:%d",checkLoadModel.isLoading,checkLoadModel.isReady);

    // 查询该广告位的所有缓存信息
    NSArray *array = [[ATAdManager sharedManager] getRewardedVideoValidAdsForPlacementID:self.placementID];
    NSLog(@"ValidAds.count:%ld--- ValidAds:%@",array.count,array);

    // 判断当前是否存在可展示的广告
    BOOL isready = [[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:self.placementID];
    if (self.isAuto) {
        isready = [[ATRewardedVideoAutoAdManager sharedInstance] autoLoadRewardedVideoReadyForPlacementID:self.placementID];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:isready ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

// 统计到达场景
- (void)entryAdScenario {
    /* 为了统计场景到达率，相关信息可查阅 iOS高级设置说明 -> 广告场景 在满足广告触发条件时调用“进入广告场景”方法，https://docs.toponad.com/#/zh-cn/ios/NetworkAccess/scenario/scenario
    比如： ** 广告场景是在清理结束后弹出广告，则在清理结束时调用；
    * 1、先调用 entryxxx
    * 2、在判断 Ready的状态是否可展示
    * 3、最后调用 show 展示 */
    if (self.isAuto) { //Auto loading mode
        [[ATRewardedVideoAutoAdManager sharedInstance] entryAdScenarioWithPlacementID:self.placementID scenarioID:KTopOnRewardedVideoSceneID];
    }else { //Manual loading mode
        [[ATAdManager sharedManager] entryRewardedVideoScenarioWithPlacementID:self.placementID scene:KTopOnRewardedVideoSceneID];
    }
}

// 展示广告
- (void)showRewardVideoAd {
    // 到达场景
    [self entryAdScenario];
    
    if (self.isAuto) { //Auto loading mode
        if ([[ATRewardedVideoAutoAdManager sharedInstance] autoLoadRewardedVideoReadyForPlacementID:self.placementID]) {
            
            [[ATRewardedVideoAutoAdManager sharedInstance] showAutoLoadRewardedVideoWithPlacementID:self.placementID scene:KTopOnRewardedVideoSceneID inViewController:self delegate:self];
        }
    }else { //Manual loading mode
        if ([[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:self.placementID]) {
            
            __weak __typeof(self)weakSelf = self;
            ATShowConfig *config = [[ATShowConfig alloc] initWithScene:KTopOnRewardedVideoSceneID showCustomExt:@"testShowCustomExt"];            
            [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:self.placementID scene:KTopOnRewardedVideoSceneID inViewController:self delegate:self];
        } else {
//            reload Ads
//            [self loadAd];
        }
    }
}
- (void)showLog:(NSString *)logStr {
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

- (void)clearLog {
    self.textView.text = @"";
}


#pragma mark - loading delegate
- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra {
    NSLog(@"广告源--AD--开始--ATRewardVideoViewController::didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra {
    NSLog(@"广告源--AD--完成--ATRewardVideoViewController::didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error {
    NSLog(@"广告源--AD--失败--ATRewardVideoViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra {
    NSLog(@"广告源--bid--开始--ATRewardVideoViewController::didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra {
    NSLog(@"广告源--bid--完成--ATRewardVideoViewController::didFinishBiddingADSourceWithPlacementID:%@--extra:%@", placementID,extra);
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error {
    NSLog(@"广告源--bid--失败--ATRewardVideoViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
}

-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"ATRewardedVideoViewController::didFinishLoadingADWithPlacementID:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didFinishLoading:%@", placementID]];
}

-(void) didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    NSLog(@"ATRewardedVideoViewController::didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoad:%@ errorCode:%ld", placementID, (long)error.code]];
}

#pragma mark - showing delegate
-(void) rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidRewardSuccessForPlacemenID:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidRewardSuccess:%@", placementID]];
}

-(void) rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidStartPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidStartPlaying:%@", placementID]];
}

-(void) rewardedVideoDidEndPlayingForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidEndPlaying:%@", placementID]];
}

-(void) rewardedVideoDidFailToPlayForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidFailToPlayForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidFailToPlay:%@ errorCode:%ld", placementID, (long)error.code]];
}

-(void) rewardedVideoDidCloseForPlacementID:(NSString*)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidCloseForPlacementID:%@, rewarded:%@ extra:%@", placementID, rewarded ? @"yes" : @"no", extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidClose:%@, rewarded:%@", placementID, rewarded ? @"yes" : @"no"]];
}

-(void) rewardedVideoDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATRewardedVideoViewController::rewardedVideoDidClickForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidClick:%@", placementID]];
}

- (void)rewardedVideoDidDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATRewardedVideoViewController:: rewardedVideoDidDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidDeepLinkOrJump:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
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
- (ATADFootView *)footView {
    if (!_footView) {
        _footView = [[ATADFootView alloc] init];
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
            [weakSelf showRewardVideoAd];
        }];
    }
    return _footView;
}

- (UIView *)modelBackView {
    if (!_modelBackView) {
        _modelBackView = [[UIView alloc] init];
        _modelBackView.backgroundColor = [UIColor whiteColor];
        _modelBackView.layer.masksToBounds = YES;
        _modelBackView.layer.cornerRadius = 5;
    }
    return _modelBackView;
}

- (ATModelButton *)modelButton {
    if (!_modelButton) {
        _modelButton = [[ATModelButton alloc] init];
        _modelButton.backgroundColor = [UIColor whiteColor];
        _modelButton.modelLabel.text = @"Reward Video";
        _modelButton.image.image = [UIImage imageNamed:@"rewarded video"];
    }
    return _modelButton;
}

- (ATMenuView *)menuView {
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

- (void)turnOnAuto:(Boolean)isOn {
    self.footView.loadBtn.hidden = isOn;
    if (isOn) {
        [[ATRewardedVideoAutoAdManager sharedInstance] addAutoLoadAdPlacementIDArray:@[self.placementID]];
    }
    else{
        [[ATRewardedVideoAutoAdManager sharedInstance] removeAutoLoadAdPlacementIDArray:@[self.placementID]];
    }
    self.isAuto = isOn;
}

- (UITextView *)textView {
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
