//
//  ATInterstitialViewController.m
//  AnyThinkSDKDemo
//
//  Created by Martin Lau on 21/09/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import "ATInterstitialViewController.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>

#import "ATModelButton.h"
//#import "ATInterstitialAutoAdManager.h"
#import <AnyThinkInterstitial/ATInterstitialAutoAdManager.h>

#import "ATADFootView.h"
#import "ATMenuView.h"


@interface ATInterstitialViewController ()<ATInterstitialDelegate>
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, strong) NSDictionary<NSString*, NSString*>* placementIDs;
@property(nonatomic, readonly) UIActivityIndicatorView *loadingView;
@property (copy, nonatomic) NSString *placementID;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) ATADFootView *footView;
@property (nonatomic, strong) ATMenuView *menuView;
@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs_inter;
@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs_fullScreen;
@property (nonatomic, strong) ATModelButton *fullScreenBtn;
@property (nonatomic, strong) ATModelButton *interstitialBtn;
@property(nonatomic,assign) BOOL isAuto;


@end

@implementation ATInterstitialViewController

-(instancetype)init{
    self =[super init];
    return  self;
}

- (NSDictionary<NSString *,NSString *> *)placementIDs_fullScreen{
    
    return  @{
        @"GAM":@"b5f2389ab6ee63",
        @"StartApp":@"b5e731a0acabdf",
        @"StartApp-(Video)":@"b5e732a9577182",
        @"Sigmob-(RV)":@"b5d771f79e4a32",
        @"Sigmob":@"b5ed8ceb5a286d",
        @"Myoffer":@"b5db6c26999c31",
        @"Ogury":@"b5dde238f2d2ce",
        @"KS":@"b5d807a4846f50",
        @"HeaderBidding":@"b5d13340a1dd21",
        @"Nend":@"b5cb96db9b3b0f",
        @"Nend-(Video)":@"b5cb96dd930c57",
        @"Nend-(Full Screen)":@"b5cb96df0f1914",
        @"Maio":@"b5cb96cf795c4b",
        @"Unity Ads":@"b5c21a055a51ab",
        @"Facebook":@"b5baf4bf9829e4",
        @"AdMob":@"b5bacad6860972",
        @"Inmobi":@"b5baf524062aca",
        @"Applovin":@"b5bacad34e4294",
        @"Mintegral":@"b5bacad46a8bbb",
        @"Mintegral-(Video)":@"b5bacad5962e84",
        @"GDT":@"b5bacad8ea3036",
        @"Chartboost":@"b5baf5cd422553",
        @"Tapjoy":@"b5baf5ebe8df89",
        @"Ironsource":@"b5baf617891a2e",
        @"Vungle":@"b5baf61edafdbb",
        @"Adcolony":@"b5baf620280a65",
        @"TT":@"b5bacad7373b89",
        @"TT-(Video)":@"b5bacad80a0fb1",
        @"Pangle":@"b612f6aab20150",
        @"Appnext":@"b5bc7fb9cbfff1",
        @"Baidu":@"b5c04ddc6ba49e",
        @"Fyber":@"b5e96db2198474",
        @"Helium":@"b5f583ec12143f",
        @"OnlineApi":@"b5fa250771e076",
        @"Kidoz":@"b5feaa2df0e121",
        @"MyTarget":@"b5feaa306e483c",
        @"All":@"b5bacad26a752a",
        @"OFM":@"b6002860de4410",
        @"Gromore":@"b601cac971d07c",
        @"Max":@"b603efe75ae38d",
        @"Klevin":@"b613affb04196f",
    };
}

- (NSDictionary<NSString *,NSString *> *)placementIDs_inter{
    return @{
        @"GAM":             @"b5f2389ab6ee63",
        @"StartApp":        @"b5e731a0acabdf",
        @"StartApp-(Video)": @"b5e732a9577182",
        @"Sigmob-(RV)":      @"b5d771f79e4a32",
        @"Sigmob":          @"b5ed8ceb5a286d",
        @"Myoffer":         @"b5db6c26999c31",
        @"Ogury":           @"b5dde238f2d2ce",
        @"KS":              @"b5d807a4846f50",
        @"HeaderBidding":   @"b5d13340a1dd21",
        @"Nend":            @"b5cb96db9b3b0f",
        @"Nend-(Video)":     @"b5cb96dd930c57",
        @"Nend-(Full Screen)":@"b5cb96df0f1914",
        @"Maio":            @"b5cb96cf795c4b",
        @"Unity Ads":       @"b5c21a055a51ab",
        @"Facebook":        @"b5baf4bf9829e4",
        @"AdMob":           @"b5bacad6860972",
        @"Inmobi":          @"b5baf524062aca",
        @"Applovin":        @"b5bacad34e4294",
        @"Mintegral":       @"b5bacad46a8bbb",
        @"Mintegral-(Video)":@"b5bacad5962e84",
        @"GDT":             @"b5bacad8ea3036",
        @"Chartboost":      @"b5baf5cd422553",
        @"Tapjoy":          @"b5baf5ebe8df89",
        @"Ironsource":      @"b5baf617891a2e",
        @"Vungle":          @"b5baf61edafdbb",
        @"Adcolony":        @"b5baf620280a65",
        @"TT":              @"b5bacad7373b89",
        @"TT-(Video)":      @"b5bacad80a0fb1",
        @"Pangle":          @"b612f6aab20150",
        @"Appnext":         @"b5bc7fb9cbfff1",
        @"Baidu":           @"b5c04ddc6ba49e",
        @"Fyber":           @"b5e96db2198474",
        @"Helium":          @"b5f583ec12143f",
        @"OnlineApi":       @"b5fa250771e076",
        @"Kidoz":           @"b5feaa2df0e121",
        @"MyTarget":        @"b5feaa306e483c",
        @"All":             @"b5bacad26a752a",
        @"Klevin":          @"b613affb04196f",
        @"DirectOffer":     @"b61bffcd9dda20",
    };
}


-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Intersitial";
    self.view.backgroundColor =  kRGB(245, 245, 245);
  
    [self setupUI];
    
    [ATInterstitialAutoAdManager sharedInstance].delegate = self;
}

- (void)setupUI
{
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    [clearBtn setTitle:@"clear log" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearLog) forControlEvents:UIControlEventTouchUpInside];
   
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    self.navigationItem.rightBarButtonItem = btnItem;
    
    
    [self.view addSubview:self.fullScreenBtn];
    [self.view addSubview:self.interstitialBtn];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.footView];
  
    [self.fullScreenBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 3) / 2);
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
        make.left.equalTo(self.view.mas_left).offset(kScaleW(26));
    }];

    [self.interstitialBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(kScaleW(-26));
        make.width.mas_equalTo((kScreenW - kScaleW(26) * 3) / 2);
        make.height.mas_equalTo(kScaleW(360));
        make.top.equalTo(self.view.mas_top).offset(kNavigationBarHeight + kScaleW(20));
    }];

    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - kScaleW(52));
        make.height.mas_equalTo(kScaleW(242));
        make.top.equalTo(self.fullScreenBtn.mas_bottom).offset(kScaleW(20));
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
    
    
    [self changeModel:self.fullScreenBtn];
}

#pragma mark - Action
- (void)changeModel:(UIButton *)sender
{
    if ((self.fullScreenBtn.isSelected && sender == self.fullScreenBtn) || (self.interstitialBtn.isSelected && sender == self.interstitialBtn)) {
        return;
    }
    
    self.fullScreenBtn.selected = sender == self.fullScreenBtn;
    self.interstitialBtn.selected = sender == self.interstitialBtn;
    
    if (![NSStringFromClass([self class]) containsString:@"Auto"]) {
        if (sender == self.fullScreenBtn) {
            
            [_footView.loadBtn setTitle:@"Load FullScreen AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is FullScreen AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show FullScreen AD" forState:UIControlStateNormal];
            
        }else{
            [_footView.loadBtn setTitle:@"Load Interstitial AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is Interstitial AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show Interstitial AD" forState:UIControlStateNormal];
        }
     
    }
    [self.fullScreenBtn setButtonIsSelectBoard];
    [self.interstitialBtn setButtonIsSelectBoard];
    self.placementIDs = sender.tag == 0 ? self.placementIDs_fullScreen : self.placementIDs_inter;
    
    [self resetPlacementID];
}

-(void)setToAutoLoadMode{
    self.interstitialBtn.hidden = true;
    self.fullScreenBtn.hidden = true;
    self.textView.hidden = true;
    self.menuView.hidden = true;

    self.footView.loadBtn.hidden = true;
    
}

- (void)resetPlacementID {
    [self.menuView resetMenuList:self.placementIDs.allKeys];
    self.placementID = self.placementIDs.allValues.firstObject;
}


- (void)loadAd
{
    CGSize size = CGSizeMake(CGRectGetWidth(self.view.bounds) - 30.0f, 300.0f);
    NSDictionary *extraDic = @{
        kATInterstitialExtraAdSizeKey:[NSValue valueWithCGSize:size],
    };

    if (_isAuto) {
        
        [[ATInterstitialAutoAdManager sharedInstance] showAutoLoadInterstitialWithPlacementID:self.placementID scene:@"f5e549727efc49" inViewController:self delegate:self];
        
    }else
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:
     extraDic delegate:self];
}

- (void)checkAd
{
    
    ATCheckLoadModel *checkLoadModel = [[ATAdManager sharedManager] checkInterstitialLoadStatusForPlacementID:self.placementID];
    
    NSArray *checkArray = [[ATAdManager sharedManager] getInterstitialValidAdsForPlacementID:self.placementID];
    
    NSLog(@"ATInterstitialViewController--checkLoadModel--%ld----:%@---checkLoadModel:%@",checkArray.count,checkArray,checkLoadModel);
    
    
    BOOL isReady = [[ATAdManager sharedManager] interstitialReadyForPlacementID:self.placementID];
    
    if (_isAuto) {
        isReady =  [[ATInterstitialAutoAdManager sharedInstance] autoLoadInterstitialReadyForPlacementID:self.placementID];
        
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:isReady ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
    
}

- (void)showAd
{
    
   if (self.isAuto) {
       [ [ATInterstitialAutoAdManager sharedInstance] showAutoLoadInterstitialWithPlacementID:self.placementID scene:@"f5e549727efc49" inViewController:self delegate:self];
   }else {
       [[ATAdManager sharedManager] showInterstitialWithPlacementID:self.placementID scene:@"f5e549727efc49" inViewController:self delegate:self];
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

-(void)checkAutoLoad{
    Class class = NSClassFromString(@"ATInterstitialAutoAdViewController");
    UIViewController *con = [class new];
    [con setValue:self.placementID forKey:@"placementID"];
    [self.navigationController pushViewController:con animated:YES];
    
}

- (void)clearLog
{
    self.textView.text = @"";
}

#pragma mark - ATInterstitialDelegate

- (void)didStartLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--AD--开始--ATInterstitialViewController::didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didStartLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];

}

- (void)didFinishLoadingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--AD--完成--ATInterstitialViewController::didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    
}

- (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    NSLog(@"广告源--AD--失败--ATInterstitialViewController::didFailToLoadADSourceWithPlacementID:%@---error:%@", placementID,error);
    
//    [self showLog:[NSString stringWithFormat:@"didFailToLoadADSourceWithPlacementID:%@--%@", placementID],error];
 
}

// bidding
- (void)didStartBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--bid--开始--ATInterstitialViewController::didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didStartBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
    
}

- (void)didFinishBiddingADSourceWithPlacementID:(NSString *)placementID extra:(NSDictionary*)extra{
    
    NSLog(@"广告源--bid--完成--ATInterstitialViewController::didFinishBiddingADSourceWithPlacementID:%@--extra:%@", placementID,extra);
    
//    [self showLog:[NSString stringWithFormat:@"didFinishBiddingADSourceWithPlacementID:%@---extra:%@", placementID,extra]];
 
}

- (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID extra:(NSDictionary*)extra error:(NSError*)error{
    
    NSLog(@"广告源--bid--失败--ATInterstitialViewController::didFailBiddingADSourceWithPlacementID:%@--error:%@", placementID,error);
    
//    [self showLog:[NSString stringWithFormat:@"didFailBiddingADSourceWithPlacementID:%@", placementID]];
   
}

-(void) didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"ATInterstitialViewController::didFinishLoadingADWithPlacementID:%@", placementID);
    
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@", placementID]];
    

}

-(void) didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error {
    NSLog(@"ATInterstitialViewController::didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
    
}

-(void) interstitialDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidShowForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialDidShowForPlacementID:%@", placementID]];
    
  
}

-(void) interstitialFailedToShowForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialFailedToShowForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialFailedToShowForPlacementID:%@ error:%@", placementID, error]];
    
  
}

-(void) interstitialDidFailToPlayVideoForPlacementID:(NSString*)placementID error:(NSError*)error extra:(NSDictionary*)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidFailToPlayVideoForPlacementID:%@ error:%@ extra:%@", placementID, error, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialDidFailToPlayVideoForPlacementID:%@ errorCode:%ld", placementID, error.code]];
    

}

-(void) interstitialDidStartPlayingVideoForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidStartPlayingVideoForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"ATInterstitialViewController::interstitialDidStartPlayingVideoForPlacementID:%@", placementID]];
    
 
}

-(void) interstitialDidEndPlayingVideoForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidEndPlayingVideoForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialDidEndPlayingVideoForPlacementID:%@", placementID]];

}

-(void) interstitialDidCloseForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidCloseForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialDidCloseForPlacementID:%@", placementID]];
    
  
}

-(void) interstitialDidClickForPlacementID:(NSString*)placementID extra:(NSDictionary *)extra {
    NSLog(@"ATInterstitialViewController::interstitialDidClickForPlacementID:%@ extra:%@", placementID, extra);
    
    [self showLog:[NSString stringWithFormat:@"interstitialDidClickForPlacementID:%@", placementID]];
    
  
}

- (void)interstitialDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    NSLog(@"ATInterstitialViewController:: interstitialDeepLinkOrJumpForPlacementID:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    
    [self showLog:[NSString stringWithFormat:@"interstitialDeepLinkOrJumpForPlacementID:placementID:%@, success:%@", placementID, success ? @"YES" : @"NO"]];

}


#pragma mark - lazy
- (ATADFootView *)footView
{
    if (!_footView) {
        _footView = [[ATADFootView alloc] init];
    
        if (![NSStringFromClass([self class]) containsString:@"Auto"]) {
            [_footView.loadBtn setTitle:@"Load FullScreen AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is FullScreen AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show FullScreen AD" forState:UIControlStateNormal];
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

- (ATModelButton *)fullScreenBtn
{
    if (!_fullScreenBtn) {
        _fullScreenBtn = [[ATModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _fullScreenBtn.tag = 0;
        _fullScreenBtn.backgroundColor = [UIColor whiteColor];
        _fullScreenBtn.layer.borderWidth = kScaleW(5);
        _fullScreenBtn.modelLabel.text = @"FullScreen";
        _fullScreenBtn.image.image = [UIImage imageNamed:@"Interstitial-fullscreen"];
        [_fullScreenBtn addTarget:self action:@selector(changeModel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

- (ATModelButton *)interstitialBtn
{
    if (!_interstitialBtn) {
        _interstitialBtn = [[ATModelButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScaleW(532))];
        _interstitialBtn.tag = 1;
        _interstitialBtn.backgroundColor = [UIColor whiteColor];
        _interstitialBtn.layer.borderWidth = kScaleW(5);
        _interstitialBtn.modelLabel.text = @"Interstitial";
        _interstitialBtn.image.image = [UIImage imageNamed:@"Interstitial"];
        [_interstitialBtn addTarget:self action:@selector(changeModel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _interstitialBtn;
}

- (ATMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[ATMenuView alloc] initWithMenuList:self.placementIDs.allKeys subMenuList:nil];
        _menuView.turnAuto = true;
        _menuView.layer.masksToBounds = YES;
        _menuView.layer.cornerRadius = 5;
        __weak typeof (self) weakSelf = self;
        [_menuView setSelectMenu:^(NSString * _Nonnull selectMenu) {
            weakSelf.placementID = weakSelf.placementIDs[selectMenu];
            NSLog(@"select placementId:%@", weakSelf.placementID);
            
            if (weakSelf.isAuto) {
                [[ATInterstitialAutoAdManager sharedInstance]addAutoLoadAdPlacementIDArray:@[weakSelf.placementID]];
            }
     
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
       
        [[ATInterstitialAutoAdManager sharedInstance]addAutoLoadAdPlacementIDArray:@[self.placementID]];
    }
    else{
        [[ATInterstitialAutoAdManager sharedInstance]removeAutoLoadAdPlacementIDArray:@[self.placementID]];
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
        _textView.text = @"";
    }
    return _textView;
}




@end
