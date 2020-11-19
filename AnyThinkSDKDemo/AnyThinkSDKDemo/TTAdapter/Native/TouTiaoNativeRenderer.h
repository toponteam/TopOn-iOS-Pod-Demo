//
//  TouTiaoNativeRenderer.h
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/22/20.
//  Copyright © 2020 抽筋的灯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouTiaoNativeCustomEvent.h"
#import <AnyThinkNative/AnyThinkNative.h>

NS_ASSUME_NONNULL_BEGIN

@interface TouTiaoNativeRenderer : ATNativeRenderer
@property(nonatomic, readonly) TouTiaoNativeCustomEvent *customEvent;
@end

NS_ASSUME_NONNULL_END
