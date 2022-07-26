//
//  ATVideoPlayerManager.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/26/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATVideoPlayerManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ATVideoPlayerManager ()

@property (nonatomic , strong) id playerObserver;
@property (nonatomic , strong) AVPlayer *player;
@property (nonatomic , strong) AVPlayerItem *playerItem;
@property (nonatomic , assign) CGFloat totalTime;

@end

@implementation ATVideoPlayerManager

+(instancetype) sharedManager {
    static ATVideoPlayerManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ATVideoPlayerManager alloc] init];
    });
    return sharedManager;
}

-(instancetype) init {
    self = [super init];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)refreshContanerView:(UIView *)contanerView withVideoUrlStr:(NSString *)drawVideoUrlStr {
    [self pauseVideo];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:drawVideoUrlStr ofType:@"mp4"];
    NSLog(@"url=%@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    self.totalTime = (asset.duration.value * 1.0 / asset.duration.timescale * 1.0);
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    if (self.player.currentItem != self.playerItem) {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
    
    AVPlayerLayer *playerlayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerlayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    CGRect playerFrame = CGRectMake(0, 0, kScreenW, kScreenH);
    playerlayer.frame = playerFrame;
    [contanerView.layer addSublayer:playerlayer];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    contanerView.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)playVideo {
    [self.player play];
    self.isPlaying = YES;
}

- (void)pauseVideo {
    [self.player pause];
    self.isPlaying = NO;
}

#pragma mark - notification
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if(object == self.playerItem){
        if([keyPath isEqualToString:@"status"]){
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            switch (status) {
                case AVPlayerStatusReadyToPlay:
                    {
                        [self.player setVolume:[AVAudioSession sharedInstance].outputVolume];
                        [self playVideo];
                        [self timeObserver];
                    }
                    break;
                case AVPlayerStatusUnknown:
                case AVPlayerStatusFailed:
                    break;
                default:
                    break;
            }
        }
    }
}

//监听视频播放进度
-(void)timeObserver {
    __weak typeof(self) weakself = self;
    _playerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(50, 1000) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentime = (time.value * 1.00) / (time.timescale * 1.00) ;
        if (currentime >= weakself.totalTime) {
            // 播放完成，重复播放
            [weakself.player seekToTime:CMTimeMake(0, 1)];
            [weakself.player play];
        }
    }];
}

-(void)tapVideo:(UITapGestureRecognizer *)gesture {
    NSLog(@"video is click");
    if (self.isPlaying) {
        [self pauseVideo];
    } else {
        [self playVideo];
    }
}

#pragma mark - dealloc
-(void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.player removeTimeObserver:_playerObserver];
    NSLog(@"ATVideoPlayerManager dealloc");
}

#pragma mark - application notification
-(void)applicationWillResignActive:(NSNotification *)notification {
    [self pauseVideo];
}

-(void)applicationWillBecomeActive:(NSNotification *)notification {
    [self playVideo];
}

- (AVPlayer *)player {
    if (!_player) {
        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
        _player = player;
    }
    return _player;
}

@end
