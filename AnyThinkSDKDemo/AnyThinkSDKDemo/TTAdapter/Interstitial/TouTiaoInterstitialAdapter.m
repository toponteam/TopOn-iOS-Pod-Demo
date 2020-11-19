//
//  TouTiaoInterstitialAdapter.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "TouTiaoInterstitialAdapter.h"
#import "TouTiaoInterstitialCustomEvent.h"
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
//#import <BUAdSDK/BUAdSDK.h>
@import BUAdSDK;

@interface TouTiaoInterstitialAdapter()
@property(nonatomic, readonly) BUInterstitialAd *interstitial;
@property(nonatomic, readonly) TouTiaoInterstitialCustomEvent *customEvent;
@end

@implementation TouTiaoInterstitialAdapter

+(BOOL) adReadyWithCustomObject:(id)customObject info:(NSDictionary*)info {
    return ((BUNativeExpressInterstitialAd *)customObject).adValid;
}

+(void) showInterstitial:(ATInterstitial*)interstitial inViewController:(UIViewController*)viewController delegate:(id<ATInterstitialDelegate>)delegate {
    //Here for full screen video ad, we also use id<ATWMInterstitialAd>, for the presenting methods are the same.
    BUNativeExpressInterstitialAd *ttInterstitial = interstitial.customObject;
    interstitial.customEvent.delegate = delegate;
    [ttInterstitial showAdFromRootViewController:viewController];
}

-(instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
        [BUAdSDKManager setAppID:serverInfo[@"app_id"]];
    }
    return self;
}

-(void) loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    
    _customEvent = [[TouTiaoInterstitialCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    _customEvent.requestCompletionBlock = completion;
//    _customEvent.customEventMetaDataDidLoadedBlock = self.metaDataDidLoadedBlock;
    
    CGSize adSize = [serverInfo[@"size"] respondsToSelector:@selector(CGSizeValue)] ? [serverInfo[@"size"] CGSizeValue] : CGSizeMake(300.0f, 300.0f);
    _interstitial = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:serverInfo[@"slot_id"] adSize:adSize];
    _interstitial.delegate = _customEvent;
    [_interstitial loadAdData];
}

@end
