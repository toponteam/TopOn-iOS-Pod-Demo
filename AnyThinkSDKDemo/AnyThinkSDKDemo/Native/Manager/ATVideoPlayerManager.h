//
//  ATVideoPlayerManager.h
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/26/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATVideoPlayerManager : NSObject
+(instancetype) sharedManager;
@property (nonatomic , assign) BOOL isPlaying;

- (void)refreshContanerView:(UIView *)contanerView withVideoUrlStr:(NSString *)drawVideoUrlStr;

- (void)playVideo;
- (void)pauseVideo;
@end

NS_ASSUME_NONNULL_END
