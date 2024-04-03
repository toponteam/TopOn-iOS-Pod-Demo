//
//  ATTMSplashAdapter.m
//  eseecloud
//
//  Created by Yc on 2022/10/17.
//  Copyright © 2022 juanvision. All rights reserved.
//

#import "ATTMSplashAdapter.h"
#import "ATTMSplashCustomEvent.h"


#import "ATTMBiddingRequest.h"
#import "ATTMBiddingManager.h"



@interface ATTMSplashAdapter ()
@property (nonatomic, strong) ATTMSplashCustomEvent *customEvent;
@property (nonatomic, strong) TianmuSplashAd *splashView;
@end

@implementation ATTMSplashAdapter

// 注册三方广告平台的SDK
-(instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
        [TianmuSDK initWithAppId:serverInfo[@"appid"] completionBlock:^(NSError * _Nullable error) {
            if (error){
                NSLog(@"TianmuSDK 初始化失败%@",error);
            }
        }];
    }
    return self;
}

// 竞价完成并发送了ATBidInfo给SDK后，来到该方法，或普通广告源加载广告来到该方法
- (void)loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    
    NSDictionary *extra = localInfo;
    NSTimeInterval tolerateTimeout = localInfo[kATSplashExtraTolerateTimeoutKey] ? [localInfo[kATSplashExtraTolerateTimeoutKey] doubleValue] : 5.0;
    if (tolerateTimeout > 0) {
        _customEvent = [[ATTMSplashCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
        _customEvent.requestCompletionBlock = completion;
        _customEvent.delegate = self.delegateToBePassed;
        
        ATTMBiddingRequest *request = [[ATTMBiddingManager sharedInstance] getRequestItemWithUnitID:serverInfo[@"unitid"]];
        if (request) { //竞价失败不会进入该方法，所以处理竞价成功的逻辑
            
            if (request.customObject != nil) { // load secced 且 广告数据可用(原则上是检查广告是否可用的，TM并没有提供所以使用检查是否广告对象来替代)
                self.splashView = request.customObject;
                self.splashView.delegate = _customEvent;
                // 返回加载完成
                [_customEvent trackSplashAdLoaded:self.splashView];
            } else { // 广告数据不可用
                NSError *error = [NSError errorWithDomain:ATADLoadingErrorDomain code:ATADLoadingErrorCodeThirdPartySDKNotImportedProperly userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long to load placement stragety."}];
                // 返回加载失败
                [_customEvent trackSplashAdLoadFailed:error];
            }
            [[ATTMBiddingManager sharedInstance] removeRequestItmeWithUnitID:serverInfo[@"unitid"]];
        } else {
            // 普通瀑布流的广告配置，进行加载广告
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.splashView = [[TianmuSplashAd alloc] init];
                self.splashView.delegate = self.customEvent;
                self.splashView.posId = serverInfo[@"unitid"];
                if (extra[kATSplashExtraHideSkipButtonFlagKey]) { self.splashView.hiddenSkipView = [extra[kATSplashExtraHideSkipButtonFlagKey] boolValue];
                }
                [self.splashView loadAdWithBottomView:nil];
                
            });
        }
    } else {
        completion(nil, [NSError errorWithDomain:ATADLoadingErrorDomain code:ATADLoadingErrorCodeThirdPartySDKNotImportedProperly userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long to load placement stragety."}]);
    }
}

// 外部调用了show的API后，来到该方法。请实现三方平台的展示逻辑。
+ (void)showSplash:(ATSplash *)splash localInfo:(NSDictionary*)localInfo delegate:(id<ATSplashDelegate>)delegate {
    TianmuSplashAd *splashView = splash.customObject;
    if (splashView) {
        UIWindow *window = localInfo[kATSplashExtraWindowKey];
        [splashView showInWindow:window];
    }
}

// 返回三方广告平台的广告对象是否可使用，例如穿山甲的开屏广告的 adValid 属性
+(BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary*)info{
    TianmuSplashAd *splashView = customObject;
    return splashView?YES:NO;
}

#pragma mark - Header bidding
#pragma mark - c2s
// 后台配置了C2S的竞价广告会先来到这个方法，完成相应的竞价请求
+(void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {

    NSLog(@"%s", __FUNCTION__);
    if (NSClassFromString(@"TianmuSDK") == nil) {
        if (completion != nil) { completion( nil, [NSError errorWithDomain:@"com.ubix.mediation.ios" code:1 userInfo:@{NSLocalizedDescriptionKey:@"Bid request has failed", NSLocalizedFailureReasonErrorKey:@"TianmuSDK is not imported"}]); }
        return;
    }
    [TianmuSDK initWithAppId:info[@"appid"] completionBlock:^(NSError * _Nullable error) {
        if (error){
            NSLog(@"TianmuSDK 初始化失败%@",error);
        } else {
            
            ATTMBiddingManager *biddingManage = [ATTMBiddingManager sharedInstance];
            ATTMBiddingRequest *request = [ATTMBiddingRequest new];
            request.unitGroup = unitGroupModel;
            request.placementID = placementModel.placementID;
            request.bidCompletion = completion;
            request.unitID = info[@"unitid"];
            request.extraInfo = info;
            request.adType = ESCAdFormatSplash;
            
            TianmuSplashAd *splash = [[TianmuSplashAd alloc] init];
            request.customObject = splash;
            [biddingManage startWithRequestItem:request];
            splash.posId = info[@"unitid"];
            [splash loadAdWithBottomView:nil];
            
        }
    }];
}

// 返回广告位比价胜利时，第二的价格的回调，可在该回调中向三方平台返回竞胜价格  secondPrice：美元(USD)
+ (void) sendWinnerNotifyWithCustomObject:(id)customObject secondPrice:(NSString*)price userInfo:(NSDictionary<NSString *, NSString *> *)userInfo {
    NSLog(@"%s", __FUNCTION__);
    TianmuSplashAd *splashAd = (TianmuSplashAd *)customObject;
    // 向TM的发送竞胜时二价的价格
    [splashAd sendWinNotificationWithPrice:[price integerValue]];
}

// 返回广告位比价输了的回调，可在该回调中向三方平台返回竞败价格 winPrice：美元(USD)
+ (void)sendLossNotifyWithCustomObject:(nonnull id)customObject lossType:(ATBiddingLossType)lossType winPrice:(nonnull NSString *)price userInfo:(NSDictionary *)userInfo {
    NSLog(@"%s", __FUNCTION__);
    TianmuSplashAd *splashAd = (TianmuSplashAd *)customObject;
    TianmuAdBiddingLossReason reason = TianmuAdBiddingLossReasonOther;
    if (lossType == ATBiddingLossWithLowPriceInNormal || lossType == ATBiddingLossWithLowPriceInHB) {
        reason = TianmuAdBiddingLossReasonLowPrice;
    }
    // 向TM发送竞价失败时的价格
    [splashAd sendWinFailNotificationReason:reason winnerPirce:[price integerValue]];
}


@end
