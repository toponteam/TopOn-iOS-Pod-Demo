//
//  ATTMBiddingDelegate.m
//  HeadBiddingDemo
//
//  Created by lix on 2022/10/20.
//

#import "ATTMBiddingDelegate.h"
#import "ATTMBiddingManager.h"
#import "ATTMBiddingRequest.h"

#import <TianmuSDK/TianmuSDK.h>
#import <TianmuSDK/TianmuSplashAd.h>
#import <AnyThinkSplash/AnyThinkSplash.h>

@interface ATTMBiddingDelegate () <TianmuSplashAdDelegate>

@end

@implementation ATTMBiddingDelegate


- (void)tianmuSplashAdSuccessLoad:(TianmuSplashAd *)splashAd{
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  开屏广告素材加载成功
 */
- (void)tianmuSplashAdDidLoad:(TianmuSplashAd *)splashAd {
    
    
    NSLog(@"%s", __FUNCTION__);
    // 拿到unitID的 ATTMBiddingRequest 对象
    ATTMBiddingRequest *request = [[ATTMBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    
    if (request.bidCompletion) {
        // 通过该方法告诉 我们SDK C2S竞价为多少，price：元(CN) or 美元(USD)，currencyType：币种
        // request.unitGroup.bidTokenTime :广告竞价超时时间
        // request.unitGroup.adapterClassString 自定义广告平台的文件名
        ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:@(splashAd.bidPrice/100.0f).stringValue currencyType:ATBiddingCurrencyTypeCNY expirationInterval:request.unitGroup.bidTokenTime customObject:splashAd];
        // 绑定对应后台下发的 firm id
        bidInfo.networkFirmID = request.unitGroup.networkFirmID;
        request.bidCompletion(bidInfo, nil);
    }
    
    // 从biddingManager 移除bidding 代理。
    [[ATTMBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];
    
}

/**
 *  开屏广告请求失败
 */
- (void)tianmuSplashAdFailLoad:(TianmuSplashAd *)splashAd withError:(NSError *)error{
    NSLog(@"%s %@", __FUNCTION__ ,error);
    
    ATTMBiddingRequest *request = [[ATTMBiddingManager sharedInstance] getRequestItemWithUnitID:self.unitID];
    // 返回获取竞价广告失败
    if (request.bidCompletion) {
        request.bidCompletion(nil, error);
    }
    // 从biddingManager 移除bidding 代理。
    [[ATTMBiddingManager sharedInstance] removeBiddingDelegateWithUnitID:self.unitID];
}

@end
