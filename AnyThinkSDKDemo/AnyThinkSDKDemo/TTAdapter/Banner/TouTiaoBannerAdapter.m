//
//  TouTiaoBannerAdapter.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "TouTiaoBannerAdapter.h"
#import "TouTiaoBannerCustomEvent.h"
#import <AnyThinkBanner/AnyThinkBanner.h>

@import BUAdSDK;

@interface TouTiaoBannerAdapter()
@property(nonatomic, readonly) BUNativeExpressBannerView *bannerView;
@property(nonatomic, readonly) TouTiaoBannerCustomEvent *customEvent;
@end

@implementation TouTiaoBannerAdapter

-(instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
        [BUAdSDKManager setAppID:serverInfo[@"app_id"]];
    }
    return self;
}


-(void) loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    
    NSDictionary *extraInfo = localInfo;
    CGSize adSize = [extraInfo[kATAdLoadingExtraBannerAdSizeKey] respondsToSelector:@selector(CGSizeValue)] ? [extraInfo[kATAdLoadingExtraBannerAdSizeKey] CGSizeValue] : CGSizeMake(320.0f, 50.0f);

    _customEvent = [[TouTiaoBannerCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    _customEvent.requestCompletionBlock = completion;
    dispatch_async(dispatch_get_main_queue(), ^{
        BUSize *size = [BUSize sizeBy:[serverInfo[@"media_size"] integerValue]];
        
        self->_bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:serverInfo[@"slot_id"] rootViewController:[ATBannerCustomEvent rootViewControllerWithPlacementID:((ATPlacementModel*)serverInfo[kAdapterCustomInfoPlacementModelKey]).placementID requestID:serverInfo[kAdapterCustomInfoRequestIDKey]]
                             adSize:CGSizeMake(adSize.width, adSize.width * size.height / size.width) IsSupportDeepLink:YES ];
        self->_bannerView.frame = CGRectMake(.0f, .0f, adSize.width, adSize.width * size.height / size.width);
        self->_bannerView.delegate = self->_customEvent;
        [self->_bannerView loadAdData];
    });
}

@end
