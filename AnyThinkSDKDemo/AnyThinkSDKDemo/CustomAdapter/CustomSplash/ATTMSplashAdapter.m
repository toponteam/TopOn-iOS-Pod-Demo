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

- (void)loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    
    NSDictionary *extra = localInfo;
    NSTimeInterval tolerateTimeout = localInfo[kATSplashExtraTolerateTimeoutKey] ? [localInfo[kATSplashExtraTolerateTimeoutKey] doubleValue] : 5.0;
    if (tolerateTimeout > 0) {
        _customEvent = [[ATTMSplashCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
        _customEvent.requestCompletionBlock = completion;
        _customEvent.delegate = self.delegateToBePassed;
        
       
        NSString *bidId = serverInfo[kATAdapterCustomInfoBuyeruIdKey];
        if (bidId.length) {
            
            ATTMBiddingRequest *request = [[ATTMBiddingManager sharedInstance] getRequestItemWithUnitID:serverInfo[@"unitid"]];
            
            if (request.customObject!=nil) { // load secced
                self.splashView = request.customObject;
                self.splashView.delegate = _customEvent;
                [_customEvent trackSplashAdLoaded:self.splashView];
            } else { // fail
                NSError *error = [NSError errorWithDomain:ATADLoadingErrorDomain code:ATADLoadingErrorCodeThirdPartySDKNotImportedProperly userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long to load placement stragety."}];
                [_customEvent trackSplashAdLoadFailed:error];
            }
            [[ATTMBiddingManager sharedInstance] removeRequestItmeWithUnitID:serverInfo[@"unitid"]];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.splashView = [[TianmuSplashAd alloc] init];
                self.splashView.delegate = self.customEvent;
                self.splashView.posId = serverInfo[@"unitid"];
//                UIView *containerView = extra[kATSplashExtraContainerViewKey];
//                self.customEvent.containerView = containerView;
                if (extra[kATSplashExtraHideSkipButtonFlagKey]) { self.splashView.hiddenSkipView = [extra[kATSplashExtraHideSkipButtonFlagKey] boolValue];
                }
                [self.splashView loadAd];
                
            });
        }
    } else {
        completion(nil, [NSError errorWithDomain:ATADLoadingErrorDomain code:ATADLoadingErrorCodeThirdPartySDKNotImportedProperly userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long to load placement stragety."}]);
    }
}

//v 5.7.06 及以上版本中， splash 广告的 load 和 show 方法已经分开了
+ (void)showSplash:(ATSplash *)splash localInfo:(NSDictionary*)localInfo delegate:(id<ATSplashDelegate>)delegate {
    TianmuSplashAd *splashView = splash.customObject;
    if (splashView) {
        UIWindow *window = localInfo[kATSplashExtraWindowKey];
        [splashView showInWindow:window withBottomView:nil];
    }
}

+(BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary*)info{
    TianmuSplashAd *splashView = customObject;
    return splashView?YES:NO;
}

#pragma mark - Header bidding
#pragma mark - c2s
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
            [splash loadAd];
            
        }
    }];
}


+ (void)sendWinnerNotifyWithCustomObject:(id)customObject secondPrice:(NSString*)price{
    NSLog(@"%s", __FUNCTION__);
    TianmuSplashAd *splashAd = (TianmuSplashAd *)customObject;
    [splashAd sendWinNotificationWithPrice:[price integerValue]];
}

+ (void)sendLossNotifyWithCustomObject:(nonnull id)customObject lossType:(ATBiddingLossType)lossType winPrice:(nonnull NSString *)price{
    NSLog(@"%s", __FUNCTION__);
    TianmuSplashAd *splashAd = (TianmuSplashAd *)customObject;
    TianmuAdBiddingLossReason reason = TianmuAdBiddingLossReasonOther;
    if (lossType == ATBiddingLossWithLowPriceInNormal || lossType == ATBiddingLossWithLowPriceInHB) {
        reason = TianmuAdBiddingLossReasonLowPrice;
    }
    [splashAd sendWinFailNotificationReason:reason winnerPirce:[price integerValue]];
}

/*
 说明：
 将TianmuSDK 以自定义适配器方式接入topon
 平台已经配置了适配器和广告位。
 1.当广告位没有开启头部竞价功能，ESCAdmobileSplashAdapter 会走初始化方法-(instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo
 和 - (void)loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion 加载广告，三方广告回调也能正常加载展示。
 2.将topon 广告源开启head bidding 功能后 适配器触发+(void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion 方法。上面初始化和加载广告的就不走了。
 
3.自定义适配器的 head bidding 逻辑按文档描述大致对接如上，广告加载触发不了。因文档介绍不详，麻烦看下还有哪些需要补充的逻辑
 
 */

@end
