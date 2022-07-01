//
//  ATPerformanceViewController.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/21.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATPerformanceViewController.h"

#import "ATPerformanceViewController+Timer.h"

#import "ATPerformanceViewController+LoadShowRemove.h"

#import <AudioToolbox/AudioToolbox.h>


void AudioServicesPlaySystemSoundWithVibration(int, id, NSDictionary *);



#define CallPoliceValue 600000

@interface ATPerformanceViewController ()

- (IBAction)allReadyAction:(id)sender;
- (IBAction)timeSwitchAction:(id)sender;
- (IBAction)logALLCallStackAction:(id)sender;


@end

@implementation ATPerformanceViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setConfiguration];
    
    [self setUI];
    
    [self launchTimer];
    
    [self loadAllAd];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.timeOn = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.timeOn = NO;
}
- (void)dealloc{
    NSLog(@"🔥----ATPerformanceViewController------销毁");
}
#pragma mark - init

- (void)setConfiguration{

    self.perSplashPlacementID = self.splashIDArray.firstObject; // All
    
    self.perNativePlacementID = self.nativeIDArray.firstObject; // All
    
    self.perBannerPlacementID = self.bannerIDArray.firstObject; // All
    
    self.bannerAdSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 80.0f);
    
    self.nativeAdSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 320.0f);
}

- (void)setUI{
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Set
- (void)setTimeOn:(BOOL)timeOn{
    
    if (timeOn && _timeOn == NO) {
        NSLog(@"🔥定时器启动");
        [self.checkLoadStatusTimer fire];
    }
    
    if (timeOn == NO && _timeOn == YES) {
        NSLog(@"🔥定时器暂停");
        [self.checkLoadStatusTimer pause];
    }

    _timeOn = timeOn;
}

#pragma mark - action

- (IBAction)logALLCallStackAction:(id)sender {
}

- (IBAction)timeSwitchAction:(id)sender {
    self.timeOn = self.timeOn ? NO : YES;
    UIButton *btn = sender;
    [btn setTitle:self.timeOn ? @"ON" : @"OFF" forState:UIControlStateNormal];
}

- (IBAction)allReadyAction:(id)sender {
    
    [self.splashIDArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *splashArray = [[ATAdManager sharedManager] getSplashValidAdsForPlacementID:obj];
        NSLog(@"🔥--开屏缓存数量:%ld--- ValidAds:%@",splashArray.count,splashArray);
    }];
    
    [self.bannerIDArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray *bannerArray = [[ATAdManager sharedManager] getBannerValidAdsForPlacementID:obj];
        NSLog(@"🔥--横幅缓存数量:%ld--- ValidAds:%@",bannerArray.count,bannerArray);
    }];
    
    [self.nativeIDArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *nativeArray = [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:obj];
        NSLog(@"🔥--原生缓存数量:%ld--- ValidAds:%@",nativeArray.count,nativeArray);
    }];

 
    

}

#pragma mark - load delegates

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID{
    
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    
    if ([self.nativeIDArray containsObject:placementID]) {
        NSLog(@"🔥---原生加载成功");
        
        if ([placementID isEqualToString:@"b5bacac5f73476"]) {
            
            NSArray *array = [[ATAdManager sharedManager] getNativeValidAdsForPlacementID:placementID];
            
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:placementID];
            }];
        }
    }
    
    if ([self.splashIDArray containsObject:placementID]) {
        NSLog(@"🔥---开屏加载成功---耗时:%f",[self getGapDate:self.loadSplashDate]);
    }
    
    if ([self.bannerIDArray containsObject:placementID]) {
        NSLog(@"🔥---横幅加载成功");
        
    }

    [self printSaveLog:fStr placementID:placementID];
}

- (void)didFailToLoadADWithPlacementID:(NSString*)placementID error:(NSError*)error{
    
    if ([self.nativeIDArray containsObject:placementID]) {
        NSLog(@"🔥---原生加载失败---placementID:%@--error:%@",placementID,error);
        if ([self.perNativePlacementID isEqualToString:placementID]) {
            self.perNativePlacementID = [self getRandomID:self.nativeIDArray placementID:self.perNativePlacementID];
            NSLog(@"🔥--切换原生:%@",self.perNativePlacementID);
        }
    }
    
    if ([self.splashIDArray containsObject:placementID]) {
        NSLog(@"🔥---开屏加载失败---placementID:%@--error:%@---耗时:%f",placementID,error,[self getGapDate:self.loadSplashDate]);
        if ([self.perSplashPlacementID isEqualToString:placementID]) {
            self.perSplashPlacementID = [self getRandomID:self.splashIDArray placementID:self.perSplashPlacementID];
            NSLog(@"🔥--切换开屏:%@",self.perSplashPlacementID);

        }
    }
    
    if ([self.bannerIDArray containsObject:placementID]) {
        NSLog(@"🔥---横幅加载失败---placementID:%@--error:%@",placementID,error);
        if ([self.perBannerPlacementID isEqualToString:placementID]) {
            self.perBannerPlacementID = [self getRandomID:self.bannerIDArray placementID:self.perBannerPlacementID];
            NSLog(@"🔥--切换横幅:%@",self.perBannerPlacementID);
        }

    }

    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];

    [self printSaveLog:fStr placementID:placementID];
}

- (void)didFinishLoadingSplashADWithPlacementID:(NSString *)placementID isTimeout:(BOOL)isTimeout {

    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];

    [self printSaveLog:fStr placementID:placementID];
}


- (void)didTimeoutLoadingSplashADWithPlacementID:(NSString *)placementID {
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];

    [self printSaveLog:fStr placementID:placementID];
    
}


#pragma mark - Splash delegates
- (void)splashDidShowForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];

    NSLog(@"🔥---开屏展示成功---耗时:%f",[self getGapDate:self.showSplashDate]);

    [self printSaveLog:fStr placementID:placementID];
    self.isSplashShow = YES;
    
    BOOL splashReady = [[ATAdManager sharedManager] splashReadyForPlacementID:self.perSplashPlacementID];
    if (splashReady == NO) {
        [self loadAllSplashAd];
    }
}


- (void)splashDidShowFailedForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---开屏展示失败");

    [self printSaveLog:fStr placementID:placementID];
}


- (void)splashDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---开屏点击");

    [self printSaveLog:fStr placementID:placementID];
}

- (void)splashDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    self.isSplashShow = NO;
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---开屏关闭");

    [self printSaveLog:fStr placementID:placementID];
}


- (void)splashDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---开屏--DeepLink");

    [self printSaveLog:fStr placementID:placementID];
}

- (void)splashDetailDidClosedForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---开屏--关闭详情");

    [self printSaveLog:fStr placementID:placementID];
}


- (void)splashZoomOutViewDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---开屏--ZoomOut");

    [self printSaveLog:fStr placementID:placementID];
}

- (void)splashZoomOutViewDidCloseForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];

    [self printSaveLog:fStr placementID:placementID];
}

- (void)splashCountdownTime:(NSInteger)countdown forPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];

    [self printSaveLog:fStr placementID:placementID];
    
}

#pragma mark - Banner delegates

- (void)bannerView:(ATBannerView *)bannerView failedToAutoRefreshWithPlacementID:(NSString *)placementID error:(NSError *)error{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---横幅加载失败");

    [self printSaveLog:fStr placementID:placementID];
}

- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];

    NSLog(@"🔥---横幅展示成功");

    [self printSaveLog:fStr placementID:placementID];
    BOOL bannerReady = [[ATAdManager sharedManager] bannerAdReadyForPlacementID:self.perBannerPlacementID];
    if (bannerReady == NO) {
        [self loadAllBannerAd];
    }
    
}

- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---横幅点击");

    [self printSaveLog:fStr placementID:placementID];
}

- (void)bannerView:(ATBannerView *)bannerView didAutoRefreshWithPlacement:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---横幅自动刷新");

    [self printSaveLog:fStr placementID:placementID];
}

- (void)bannerView:(ATBannerView *)bannerView didTapCloseButtonWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---横幅关闭按钮");
    [self printSaveLog:fStr placementID:placementID];
    
}


- (void)bannerView:(ATBannerView *)bannerView didDeepLinkOrJumpForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---横幅--DeepLink");

    [self printSaveLog:fStr placementID:placementID];
    
}

- (void)bannerView:(ATBannerView *)bannerView didCloseWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---横幅--didCloseWithPlacementID");
    [self printSaveLog:fStr placementID:placementID];
}

#pragma mark - Native delegates
- (void)didShowNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---原生展示成功");
    [self printSaveLog:fStr placementID:placementID];
    
    BOOL nativeReady = [[ATAdManager sharedManager] nativeAdReadyForPlacementID:self.perNativePlacementID];
    if (nativeReady == NO) {
        [self loadAllNativeAd];
    }
}

- (void)didClickNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---原生点击");

    [self printSaveLog:fStr placementID:placementID];
}

- (void)didStartPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---原生开始播放");

    [self printSaveLog:fStr placementID:placementID];
}

- (void)didEndPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---原生结束播放");

    [self printSaveLog:fStr placementID:placementID];
}

- (void)didEnterFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---原生EnterFullScreen");

    [self printSaveLog:fStr placementID:placementID];
}


- (void)didExitFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---原生ExitFullScreen");

    [self printSaveLog:fStr placementID:placementID];
}

- (void)didTapCloseButtonInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---原生点击关闭");

    [self printSaveLog:fStr placementID:placementID];
    
}


- (void)didLoadSuccessDrawWith:(NSArray*)views placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---原生didLoadSuccessDrawWith");

    [self printSaveLog:fStr placementID:placementID];
}


- (void)didDeepLinkOrJumpInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary*)extra result:(BOOL)success{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---原生DeepLinkOrJu");

    [self printSaveLog:fStr placementID:placementID];
}

- (void)didCloseDetailInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    NSString *fStr = [NSString stringWithFormat:@"%s",__FUNCTION__];
    NSLog(@"🔥---原生关闭详情");

    [self printSaveLog:fStr placementID:placementID];
    
}

#pragma mark - private

- (void)printSaveLog:(NSString *)messageStr placementID:(NSString *)placementID{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"AT_SaveLogType_Test"] = @(3);
    dic[@"action"] = messageStr;
    dic[@"placementID"] = placementID;

    NSString *logString = [NSString stringWithFormat:@"⚽️⚽️%@⚽️", [self jsonString_anythink:dic]];
    NSLog(@"%@",logString);
}

-(NSString*) jsonString_anythink:(NSDictionary *)dic {
    NSError *error;
    NSData *jsonData;
    
    if (![NSJSONSerialization isValidJSONObject:dic]) {
      
        return @"{}";
    }
    
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:kNilOptions
                                                             error:&error];
    } @catch (NSException *exception) {
        
     
        return @"{}";
    } @finally {}
    
    if (!jsonData) {
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
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


- (void)CallPolice:(NSDate*)lastDate{
    
    if (lastDate == nil) {
        return;
    }
    
    double date = [self getGapDate:lastDate];
    
    if (date > CallPoliceValue) {
    }
}

- (double)getGapDate:(NSDate *)loadDate{
    
    double date1 = [loadDate timeIntervalSince1970] * 1000;
    double date2 = [[NSDate date] timeIntervalSince1970] * 1000;
    double date = date2 - date1;
    
    return date * 0.001;
}

#pragma mark - lazy
- (NSArray *)bannerIDArray{
    if (_bannerIDArray == nil) {
        _bannerIDArray = @[@"b5c04dda229f7e",@"b5fa24ff8a7446",@"b5bacad0803fd1",@"b5bacacfc470c9",@"b5bacaccb61c29"];
    }
    return _bannerIDArray;
}

- (NSArray *)nativeIDArray{
    if (_nativeIDArray == nil) {
        _nativeIDArray = @[@"b5c2c6d50e7f44",@"b5bacac5f73476",@"b5e4613e50cbf2",@"b5fa25023d0767",@"b5b0f5663c6e4a"];
    }
    return _nativeIDArray;
}

- (NSArray *)splashIDArray{
    if (_splashIDArray == nil) {
        _splashIDArray = @[@"b5c1b0470c7e4a",@"b5c1b048c498b9",@"b5fb767e454cce",@"b613aff35cd174",@"b5c22f0e5cc7a0"];
    }
    return _splashIDArray;
}

    
#pragma mark - private
- (NSString *)getRandomID:(NSArray *)idArray placementID:(NSString *)placementID{
    
    NSMutableArray *tempArray = [idArray mutableCopy];

    if (tempArray.count > 1) {
        [tempArray removeObject:placementID];
    }
    
    int r = arc4random() % [tempArray count];

    return [tempArray objectAtIndex:r];
}

@end
