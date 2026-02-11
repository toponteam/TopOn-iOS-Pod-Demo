//
//  LaunchLoadingView.h
//  iOSDemo
//
//  Created by ltz on 2025/1/18.
//

#import <UIKit/UIKit.h>
 
@interface LaunchLoadingView : UIView

/// Get singleton instance
+ (instancetype)sharedInstance;

/// Prohibit external calls to init methods
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/// Used to control whether to show the ad after the local custom timer expires. If you need to use the SDK's built-in timeout timer, please refer to SplashVC.m
@property (nonatomic, assign) BOOL localTimerTimeout;
 
/// Show loading view
- (void)show;

/// Hide and remove loading view
- (void)dismiss;

/// Start timer
- (void)startTimer;

@end
