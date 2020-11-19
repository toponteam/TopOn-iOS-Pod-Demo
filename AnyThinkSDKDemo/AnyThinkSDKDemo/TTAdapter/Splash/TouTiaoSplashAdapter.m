//
//  TouTiaoSplashAdapter.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/21/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import "TouTiaoSplashAdapter.h"
#import "TouTiaoSplashCustomEvent.h"
#import <AnyThinkSplash/AnyThinkSplash.h>
#import <AnyThinkSDK/ATAdManager+Internal.h>


@interface TouTiaoSplashAdapter()
@property(nonatomic, readonly) TouTiaoSplashCustomEvent *customEvent;
@property(nonatomic, readonly) BUSplashAdView *splashView;
@end

@implementation TouTiaoSplashAdapter

-(instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
        [BUAdSDKManager setAppID:serverInfo[@"app_id"]];
    }
    return self;
}

-(void) loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    NSDictionary *extra = localInfo;
    
    NSTimeInterval tolerateTimeout = localInfo[kATSplashExtraTolerateTimeoutKey] ? [localInfo[kATSplashExtraTolerateTimeoutKey] doubleValue] : 5.0;
    NSDate *curDate = [NSDate date];
    if (tolerateTimeout > 0) {
        _customEvent = [[TouTiaoSplashCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
        _customEvent.requestCompletionBlock = completion;
        _customEvent.delegate = self.delegateToBePassed;
        _customEvent.expireDate = [curDate dateByAddingTimeInterval:tolerateTimeout];;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_splashView = [[BUSplashAdView alloc] initWithSlotID:serverInfo[@"slot_id"] frame:CGRectMake(.0f, .0f, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
            self->_splashView.tolerateTimeout = tolerateTimeout;
            if (extra[kATSplashExtraHideSkipButtonFlagKey]) { self->_splashView.hideSkipButton = [extra[kATSplashExtraHideSkipButtonFlagKey] boolValue]; }
            self->_splashView.delegate = self->_customEvent;
            self->_customEvent.ttSplashView = (UIView*)self->_splashView;
            self->_customEvent.window = [UIApplication sharedApplication].keyWindow;
            [self->_splashView loadAdData];
        });
    } else {
        completion(nil, [NSError errorWithDomain:ATADLoadingErrorDomain code:ATADLoadingErrorCodeThirdPartySDKNotImportedProperly userInfo:@{NSLocalizedDescriptionKey:@"AT has failed to load splash.", NSLocalizedFailureReasonErrorKey:@"It took too long to load placement stragety."}]);
    }
}

@end
