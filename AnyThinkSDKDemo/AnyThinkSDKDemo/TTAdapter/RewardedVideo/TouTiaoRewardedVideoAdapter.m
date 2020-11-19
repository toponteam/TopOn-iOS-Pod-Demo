//
//  TouTiaoRewardedVideoAdapter.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "TouTiaoRewardedVideoAdapter.h"
#import "TouTiaoRewardedVideoCustomEvent.h"
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>

@interface TouTiaoRewardedVideoAdapter()
@property(nonatomic, readonly) TouTiaoRewardedVideoCustomEvent *customEvent;
@property(nonatomic, readonly) BUNativeExpressRewardedVideoAd *expressRvAd;
@end

@implementation TouTiaoRewardedVideoAdapter

+(BOOL) adReadyWithCustomObject:(id)customObject info:(NSDictionary*)info {
    return ((BUNativeExpressRewardedVideoAd *)customObject).adValid;
}

+(void) showRewardedVideo:(ATRewardedVideo*)rewardedVideo inViewController:(UIViewController*)viewController delegate:(id<ATRewardedVideoDelegate>)delegate {
    TouTiaoRewardedVideoCustomEvent *customEvent = (TouTiaoRewardedVideoCustomEvent*)rewardedVideo.customEvent;
    customEvent.delegate = delegate;
    [((BUNativeExpressRewardedVideoAd *)rewardedVideo.customObject) showAdFromRootViewController:viewController];
}

-(instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
        [BUAdSDKManager setAppID:serverInfo[@"app_id"]];
    }
    return self;
}

-(void) loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    _customEvent = [[TouTiaoRewardedVideoCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    _customEvent.requestCompletionBlock = completion;
//    _customEvent.customEventMetaDataDidLoadedBlock = self.metaDataDidLoadedBlock;
    
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    NSDictionary *extra = localInfo;
    if (extra[kATAdLoadingExtraUserIDKey] != nil) {
        model.userId = extra[kATAdLoadingExtraUserIDKey];
    }
    if (extra[kATAdLoadingExtraMediaExtraKey] != nil) {
        model.extra = extra[kATAdLoadingExtraMediaExtraKey];
    }
    
    _expressRvAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:serverInfo[@"slot_id"] rewardedVideoModel:model];
    _expressRvAd.rewardedVideoModel = model;
    _expressRvAd.delegate = _customEvent;
    [_expressRvAd loadAdData];
}

@end
