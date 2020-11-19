//
//  TouTiaoNativeAdapter.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "TouTiaoNativeAdapter.h"
#import "TouTiaoNativeCustomEvent.h"
#import "TouTiaoNativeRenderer.h"
#import <AnyThinkNative/AnyThinkNative.h>
#import <BUAdSDK/BUAdSDK.h>

@interface TouTiaoNativeAdapter()
@property(nonatomic, readonly) BUNativeExpressAdManager *adMgr;
@property(nonatomic, readonly) TouTiaoNativeCustomEvent *customEvent;
@end

@implementation TouTiaoNativeAdapter

+(Class) rendererClass {
    return [TouTiaoNativeRenderer class];
}

-(instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
        [BUAdSDKManager setAppID:serverInfo[@"app_id"]];
    }
    return self;
}

-(void) loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    _customEvent = [TouTiaoNativeCustomEvent new];
//    _customEvent.unitID = serverInfo[@"unit_id"];
    _customEvent.isVideo = [serverInfo[@"is_video"] integerValue] == 1;
    _customEvent.requestCompletionBlock = completion;
    
    NSDictionary *extraInfo = localInfo;
    _customEvent.requestExtra = extraInfo;
    NSString *sizeKey = [serverInfo[@"media_size"] integerValue] > 0 ? @{@2:kATExtraNativeImageSize228_150, @1:kATExtraNativeImageSize690_388}[serverInfo[@"media_size"]] : extraInfo[kATExtraNativeImageSizeKey];
    NSInteger imgSize = [@{kATExtraNativeImageSize228_150:@9, kATExtraNativeImageSize690_388:@10}[sizeKey] integerValue];
    
    BUAdSlot *slot = [[NSClassFromString(@"BUAdSlot") alloc] init];
    slot.ID = serverInfo[@"slot_id"];
    slot.AdType = [@{@0:@(BUAdSlotAdTypeFeed), @1:@(BUAdSlotAdTypeDrawVideo), @2:@(BUAdSlotAdTypeBanner), @3:@(BUAdSlotAdTypeInterstitial)}[@([serverInfo[@"is_video"] integerValue])] integerValue];
    slot.isOriginAd = YES;
    slot.position = 1;
    slot.imgSize = [NSClassFromString(@"BUSize") sizeBy:imgSize];
    slot.isSupportDeepLink = YES;
    
    CGSize size = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 30.0f, 200.0f);
    if ([extraInfo[kExtraInfoNativeAdSizeKey] respondsToSelector:@selector(CGSizeValue)]) { size = [extraInfo[kExtraInfoNativeAdSizeKey] CGSizeValue]; }
    
    _adMgr = [[BUNativeExpressAdManager alloc] initWithSlot:slot adSize:size];
    _adMgr.delegate = _customEvent;
    _adMgr.adslot = slot;
    [_adMgr loadAd:[serverInfo[@"request_num"] integerValue]];
}

@end
