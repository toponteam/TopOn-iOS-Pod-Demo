//
//  LaunchLoadingView.m
//  iOSDemo
//
//  Created by ltz on 2025/1/18.
//

#import "LaunchLoadingView.h"
#import "AdSDKManager.h"

@interface LaunchLoadingView()

@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger seconds;
  
// Custom timer timeout duration, typically greater than the SDK's kATSplashExtraTolerateTimeoutKey setting. Can be adjusted according to your specific requirements.
#define LaunchLoadingView_Timeout 10

@end

@implementation LaunchLoadingView

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static LaunchLoadingView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LaunchLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return instance;
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Set background color
        self.backgroundColor = [UIColor whiteColor];
        
        // Create and configure logo ImageView
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Add ImageView to custom view
        [self addSubview:imageView];
        
        // Create timer label
        self.timerLabel = [[UILabel alloc] init];
        self.timerLabel.textAlignment = NSTextAlignmentCenter;
        self.timerLabel.textColor = [UIColor blackColor];
        self.timerLabel.font = [UIFont systemFontOfSize:16];
        self.timerLabel.text = @"";
        self.timerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.timerLabel];
        
        // Center constraints
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        
        // Timer label constraints
        NSLayoutConstraint *labelCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *labelTopConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
        
        // Activate constraints
        [NSLayoutConstraint activateConstraints:@[centerXConstraint, centerYConstraint, labelCenterXConstraint, labelTopConstraint]];
    }
    return self;
}

#pragma mark - Public Methods

- (void)show {
    // If already added to the view hierarchy, return directly to avoid duplicate addition
    if (self.superview) {
        return;
    }
    
    // Please ensure UI operations are executed on the main thread
    UIWindow *keyWindow = nil;
    
    // Use new API for iOS 13 and above
    if (@available(iOS 13.0, *)) {
        NSArray<UIScene *> *windowScenes = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        for (UIWindowScene *scene in windowScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                NSArray<UIWindow *> *windows = scene.windows;
                for (UIWindow *window in windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
            if (keyWindow) break;
        }
    }
    
    // Fallback for iOS versions below 13 or if the above method didn't retrieve the window
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    // Last fallback: try to get the first window
    if (!keyWindow) {
        keyWindow = [[UIApplication sharedApplication].windows firstObject];
    }
    
    if (!keyWindow) {
        NSLog(@"LaunchLoadingView: Failed to get keyWindow");
        return;
    }
    
    @try {
        // Update frame to ensure it fills the entire screen
        self.frame = keyWindow.bounds;
        
        // Add to window to ensure it's on top
        [keyWindow addSubview:self];
        [keyWindow bringSubviewToFront:self];
         
        NSLog(@"LaunchLoadingView: Successfully added to window");
    } @catch (NSException *exception) {
        // Catch exception and log it
        NSLog(@"LaunchLoadingView show exception: %@", exception);
    }
    
    [self startTimer];
}

- (void)dismiss {
    // Stop the timer first to prevent further triggers
    [self stopTimer];
    
    // Please ensure UI operations are executed on the main thread
    if (!self.superview) {
        return;
    }
    
    @try {
        // Compatibility handling: remove from superview first
        [self removeFromSuperview];
        UIWindow *currentWindow = self.window;
        if (currentWindow && [currentWindow.subviews containsObject:self]) {
            [self removeFromSuperview];
        }
        
    } @catch (NSException *exception) {
        // Catch exception, log it but don't affect program execution
        NSLog(@"LaunchLoadingView dismiss exception: %@", exception);
    }
}

- (void)startTimer {
    // Stop the previous timer first
    [self stopTimer];
    
    // Reset timer
    self.seconds = 0;
    
    // Reset timeout flag
    self.localTimerTimeout = NO;
    
    // Update UI to display initial time
    self.timerLabel.text = [NSString stringWithFormat:@"%@ 00:00 ,%@:%d",
                            kLocalizeStr(@"当前"),
                            kLocalizeStr(@"总超时时间"),
                            FirstAppOpen_Timeout];
    
    // Create NSTimer and add it to the main thread's RunLoop
    // Use scheduledTimerWithTimeInterval to create timer on main thread
    // NSRunLoopCommonModes ensures it can trigger normally during scrolling and other operations
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 repeats:YES
                                                   block:^(NSTimer * _Nonnull timer) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf updateTimer];
        }
    }];
    
    // Add timer to NSRunLoopCommonModes to ensure it runs normally during UI operations
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - Private Methods

- (void)updateTimer {
    self.seconds++;
    
    // Check if timeout has been reached
    if (self.seconds >= LaunchLoadingView_Timeout) {
        // Timeout reached, automatically remove view
        NSLog(@"LaunchLoadingView timeout reached: %ld seconds", (long)self.seconds);
        [self dismiss];
        self.localTimerTimeout = YES;
        return;
    }
    
    NSInteger minutes = self.seconds / 60;
    NSInteger remainingSeconds = self.seconds % 60;
    
    // NSTimer is already running on main thread, update UI directly
    self.timerLabel.text = [NSString stringWithFormat:@"%@ %02ld:%02ld ,%@:%d",
                            kLocalizeStr(@"当前"),
                            (long)minutes,
                            (long)remainingSeconds,
                            kLocalizeStr(@"总超时时间"),
                            FirstAppOpen_Timeout];
}

- (void)stopTimer {
    if (self.timer) {
        // Ensure timer is stopped on main thread
        if ([NSThread isMainThread]) {
            [self.timer invalidate];
            self.timer = nil;
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.timer invalidate];
                self.timer = nil;
            });
        }
    }
}

#pragma mark - Lifecycle

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    // When the view is about to be removed from superview (newSuperview is nil), perform cleanup
    if (newSuperview == nil) {
        // Stop timer
        [self stopTimer];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    // When the view is added to a new superview, you can do some initialization here
    if (self.superview) {
        // Ensure frame is correct
        if (self.window) {
            self.frame = self.window.bounds;
        }
    }
}

- (void)dealloc {
    // Ensure timer is stopped and resources are cleaned up when the object is destroyed
    [self stopTimer];
    NSLog(@"LaunchLoadingView: dealloc called");
}

@end
