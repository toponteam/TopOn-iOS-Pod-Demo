//
//  ATMediaVideoViewController.m
//  AnyThinkSDKDemo
//
//  Created by li zhixuan on 2024/3/26.
//  Copyright © 2024 抽筋的灯. All rights reserved.
//

#import "ATMediaVideoViewController.h"
#import "ATModelButton.h"
#import <AnyThinkMediaVideo/ATMediaVideoDelegate.h>
#import <AnyThinkMediaVideo/ATAdManager+ATMediaVideo.h>
#import <GoogleInteractiveMediaAds/GoogleInteractiveMediaAds.h>

// The content URL to play.
NSString *const kTestAppContentUrl_MP4 =
    @"https://storage.googleapis.com/gvabox/media/samples/stock.mp4";

typedef NS_ENUM(NSUInteger, ATMediaVideoViewControllerType) {
    ATMediaVideoViewControllerTypeVAST,
    ATMediaVideoViewControllerTypeVMAP,
};

@interface ATMediaVideoViewController ()<ATMediaVideoDelegate>

@property (nonatomic, strong) ATModelButton *modelButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView *modelBackView;
@property(nonatomic, strong) NSString *selectMenuStr;

@property(nonatomic, strong) IMAAVPlayerContentPlayhead *contentPlayhead;
@property(nonatomic, strong) AVPlayer *contentPlayer;
@property(nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) ATMediaVideoOffer *offer;
@property (nonatomic, assign) BOOL isContentPlayerPlaying;

@property (nonatomic, assign) ATMediaVideoViewControllerType type;

@end

@implementation ATMediaVideoViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.type = ATMediaVideoViewControllerTypeVMAP;
    self.title = @"Media Video";
    self.view.backgroundColor = kRGB(245, 245, 245);
    [self setupData];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)handleApplicationDidEnterBackgroundNotification:(NSNotification*)notification {

}

- (void)handleApplicationDidBecomeActiveNotification:(NSNotification*)notification {
    if (self.isContentPlayerPlaying) {
        [self.contentPlayer play];
    } else {
        [self.offer resume];
    }
}

- (NSDictionary<NSString *,NSString *> *)placementIDs {
    return @{
        @"AdMob":               @"b6600e90fd29a4",
    };
}

- (void)setupData {
    self.placementID = self.placementIDs.allValues.firstObject;
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

- (void)clearLog {
    self.textView.text = @"";
}


- (void)setUpContentPlayer {
  // Load AVPlayer with path to our content.
  NSURL *contentURL = [NSURL URLWithString:kTestAppContentUrl_MP4];
  self.contentPlayer = [AVPlayer playerWithURL:contentURL];

  // Create a player layer for the player.
  AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.contentPlayer];

  // Size, position, and display the AVPlayer.
  playerLayer.frame = self.videoView.layer.bounds;
  [self.videoView.layer addSublayer:playerLayer];

  // Set up our content playhead and contentComplete callback.
  self.contentPlayhead = [[IMAAVPlayerContentPlayhead alloc] initWithAVPlayer:self.contentPlayer];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(contentDidFinishPlaying:)
                                               name:AVPlayerItemDidPlayToEndTimeNotification
                                             object:self.contentPlayer.currentItem];
}

- (void)contentDidFinishPlaying:(NSNotification *)notification {
  // Make sure we don't call contentComplete as a result of an ad completing.
  if (notification.object == self.contentPlayer.currentItem) {
      [self.offer contentComplete];
  }
}

#pragma mark - Ad Action

- (void)loadAd {
    [_offer destory];
    _offer = nil;
    [self.videoView removeFromSuperview];
    self.videoView = nil;
    
    [[ATAPI sharedInstance] setCustomData:@{@"type": @"vmap"} forPlacementID:self.placementID];
//    [[ATAPI sharedInstance] setCustomData:@{@"type": @"vast"} forPlacementID:self.placementID];
    self.videoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    self.videoView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.videoView];
    
    [self setUpContentPlayer];
    
    NSMutableDictionary *extra = @{}.mutableCopy;
    //内部浏览器打开
    extra[kATAdMediaVideoExtraKeyInternalBrowser] = @YES;
    //隐藏倒计时
    extra[kATAdMediaVideoExtraKeyHideCountDown] = @NO;
    //加载视频广告超时时间
    extra[kATAdMediaVideoExtraKeyLoadVideoTimeout] = @8;
    //广告要不要自动播放，对VMAP才有效
    extra[kATAdMediaVideoExtraKeyAutoPlayAdBreaks] = @NO;
    //关闭当前播放信息
    extra[kATAdMediaVideoExtraKeyDisableNowPlayingInfo] = @YES;
    
    [[ATAdManager sharedManager] loadADWithPlacementID:self.placementID extra:extra controlDataParam:@{@"description_url":@"description_url"} delegate:self mediaVideoContainerView:self.videoView viewController:self];
}


- (void)checkAd {
    NSArray *array = [[ATAdManager sharedManager] getAdValidAdsForPlacementID:self.placementID];
    
    BOOL isready = [[ATAdManager sharedManager] adReadyForPlacementID:self.placementID];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:isready ? @"Ready!" : @"Not Yet!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}


- (void)showAd {
    if (![[ATAdManager sharedManager] adReadyForPlacementID:self.placementID]) {
        return;
    }
    
    ATShowConfig *showConfig = [[ATShowConfig alloc] initWithScene:nil showCustomExt:@"testShowCustomExt"];
    self.offer = [[ATAdManager sharedManager] mediaVideoObjectWithPlacementID:self.placementID showConfig:showConfig delegate:self];
    
    [[ATAdManager sharedManager] entryMediaVideoScenarioWithPlacementID:self.placementID scene:@"11"];
    
    id customNetworkObj = [self.offer customNetworkObj];
    id adsManager = [self.offer adsManager];
    
    [self.contentPlayer seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];
    
    UIView *myTransparentTapOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 250)];
    myTransparentTapOverlay.backgroundColor = [UIColor yellowColor];
    UIButton *myPauseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
    // Substitute "myTransparentTapOverlay" and "myPauseButton" with the elements
    // you want to register as video controls overlays.
    // Make sure to register before ad playback starts.
    IMAFriendlyObstruction *overlayObstruction =
          [[IMAFriendlyObstruction alloc] initWithView:myTransparentTapOverlay
                                               purpose:IMAFriendlyObstructionPurposeNotVisible
                                        detailedReason:@"This overlay is transparent"];
    IMAFriendlyObstruction *pauseButtonObstruction =
          [[IMAFriendlyObstruction alloc] initWithView:myPauseButton
                                               purpose:IMAFriendlyObstructionPurposeMediaControls
                                        detailedReason:@"This is the video player pause button"];
    
    [self.offer registerFriendlyObstruction:overlayObstruction];
    [self.offer registerFriendlyObstruction:pauseButtonObstruction];
    [self.offer unregisterAllFriendlyObstructions];
    if (self.offer.type == ATMediaVideoOfferTypeVMAP) {
        [self.offer contentPlayhead:self.contentPlayhead];
    } else if (self.offer.type == ATMediaVideoOfferTypeVAST) {
        [self.offer start];
    }
}

#pragma mark - lazy
- (ATADFootView *)footView {
    if (!_footView) {
        _footView = [[ATADFootView alloc] init];
        if (![NSStringFromClass([self class]) containsString:@"Auto"]) {
            [_footView.loadBtn setTitle:@"Load Media Video AD" forState:UIControlStateNormal];
            [_footView.readyBtn setTitle:@"Is Media Video AD Ready" forState:UIControlStateNormal];
            [_footView.showBtn setTitle:@"Show Media Video AD" forState:UIControlStateNormal];
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
        _modelButton.modelLabel.text = @"Media Video";
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
        }];
        
    }
    return _menuView;
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


#pragma mark - ATAdLoadingDelegate
/// Callback when the successful loading of the ad
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL ready = [[ATAdManager sharedManager] adReadyForPlacementID:placementID];
    
    NSLog(@"ATMediaVideoMainViewController::didFinishLoadingADWithPlacementID:%@--是否准备好:%@", placementID, ready ? @"YES":@"NO");
    
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@--isReady:%@", placementID,ready ? @"YES":@"NO"]];
}

/// Callback of ad loading failure
- (void)didFailToLoadADWithPlacementID:(NSString*)placementID
                                 error:(NSError*)error {
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, (long)error.code]];
}

#pragma mark - ATMediaVideoDelegate

/// ad play starts
- (void)mediaVideoDidStartPlayingForPlacementID:(NSString *)placementID
                                          extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoDidStartPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoDidStartPlayingForPlacementID:%@", placementID]];
}

/// ad play ends
- (void)mediaVideoDidEndPlayingForPlacementID:(NSString *)placementID
                                        extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoDidEndPlayingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoDidEndPlayingForPlacementID:%@", placementID]];
}

- (void)mediaVideoDidFailToPlayForPlacementID:(NSString *)placementID
                                           error:(NSError *)error
                                        extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoDidFailToPlayForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoDidFailToPlayForPlacementID:%@", placementID]];
}

- (void)mediaVideoAdResumeForPlacementID:(NSString *)placementID
                                   extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdResumeForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdResumeForPlacementID:%@", placementID]];
}

/// ad play fail
- (void)rewardedVideoDidFailToPlayForPlacementID:(NSString *)placementID
                                           error:(NSError *)error
                                           extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::rewardedVideoDidFailToPlayForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"rewardedVideoDidFailToPlayForPlacementID:%@", placementID]];
}

/// ad clicks
- (void)mediaVideoDidClickForPlacementID:(NSString *)placementID
                                   extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoDidClickForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoDidClickForPlacementID:%@", placementID]];
}

/// ad pause
- (void)mediaVideoAdPauseForPlacementID:(NSString *)placementID
                                  extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdPauseForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdPauseForPlacementID:%@", placementID]];
}

/// ad skiped
- (void)mediaVideoAdSkipedForPlacementID:(NSString *)placementID
                                   extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdSkipedForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdSkipedForPlacementID:%@", placementID]];
}

/// IMA callback
- (void)mediaVideoAdForPlacementID:(NSString *)placementID
                             extra:(NSDictionary *)extra event:(id)event {
    IMAAdEventType type = kIMAAdEvent_AD_BREAK_READY;
    IMAAdEvent *adEvent = event;
    if([adEvent isKindOfClass:[IMAAdEvent class]]) {
        type = adEvent.type;
    }
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdForPlacementID:%@ event:%ld extra:%@", placementID, type, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdForPlacementID:%@ event:%ld", placementID, type]];
}

/// video area tap
- (void)mediaVideoAdTappedForPlacementID:(NSString *)placementID
                                   extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdTappedForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdTappedForPlacementID:%@", placementID]];
}

/// video progress
- (void)mediaVideoAdDidProgressForPlacementID:(NSString *)placementID
                                        extra:(NSDictionary *)extra mediaTime:(NSTimeInterval)mediaTime totalTime:(NSTimeInterval)totalTime {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdDidProgressForPlacementID:%@ extra:%@", placementID, extra);
//    [self showLog:[NSString stringWithFormat:@"mediaVideoAdDidProgressForPlacementID:%@", placementID]];
}

/// video start buffering
- (void)mediaVideoAdDidStartBufferingForPlacementID:(NSString *)placementID
                                              extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdDidStartBufferingForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdDidStartBufferingForPlacementID:%@", placementID]];
}

/// video did Buffer
- (void)mediaVideoAdDidBufferToMediaTimeForPlacementID:(NSString *)placementID
                                                 extra:(NSDictionary *)extra mediaTime:(NSTimeInterval)mediaTime {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdDidBufferToMediaTimeForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdDidBufferToMediaTimeForPlacementID:%@", placementID]];
}

/// video ready
- (void)mediaVideoAdPlaybackReadyForPlacementID:(NSString *)placementID
                                          extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdPlaybackReadyForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdPlaybackReadyForPlacementID:%@", placementID]];
}

- (void)mediaVideoAdRequestContentPauseForPlacementID:(NSString *)placementID
                                                extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdRequestContentPauseForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdRequestContentPauseForPlacementID:%@", placementID]];
    
    
    [self.contentPlayer pause];
    self.isContentPlayerPlaying = NO;
}

- (void)mediaVideoAdRequestContentResumeForPlacementID:(NSString *)placementID
                                                 extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdRequestContentResumeForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdRequestContentResumeForPlacementID:%@", placementID]];
    
    
    [self.contentPlayer play];
    self.isContentPlayerPlaying = YES;
}

/// return IMA kIMAAdEvent_AD_BREAK_READY event
- (void)mediaVideoAdBreakReadyForPlacementID:(NSString *)placementID
                                       extra:(NSDictionary *)extra {
    NSLog(@"ATMediaVideoMainViewController::mediaVideoAdBreakReadyForPlacementID:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"mediaVideoAdBreakReadyForPlacementID:%@", placementID]];
    
    [self.offer start];
}


@end
