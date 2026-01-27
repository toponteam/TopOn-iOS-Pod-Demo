//
//  AppDelegate.m
//  iOSDemo
//
//  Created by ltz on 2025/1/5.
//

#import "AppDelegate.h"

#import <AnyThinkSDK/AnyThinkSDK.h>
#import "TestModeTool.h"
#import "BaseNavigationController.h"
#import "AdSDKManager.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Enable demo log output
    DemoLogAccess(1);
 
    // Set up demo UI; no integration required
    [self setupDemoUI];
    
 
    // Initialize SDK: for non-EU releases use this method; for EU use [[AdSDKManager sharedManager] initSDK_EU:] instead.
    [[AdSDKManager sharedManager] initSDK];
    // Start splash ad
    [[AdSDKManager sharedManager] startSplashAd];
  
    // EU-inclusive initialization flow
//    //EU region, replace with [[AdSDKManager sharedManager] initSDK_EU:];
//    [[AdSDKManager sharedManager] initSDK_EU:^{
//        // Start splash ad
//        [[AdSDKManager sharedManager] startSplashAd];
//    }];
       
    return YES;
}
 
#pragma mark - lifecycle
- (void)applicationDidBecomeActive:(UIApplication *)application {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 14, *)) {
            // Request ATT permission
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                
            }];
        } else {
            // Fallback on earlier versions
        }
    });
}
  
#pragma mark - Demo UI (can be ignored)
- (void)setupDemoUI {
    self.window = [UIWindow new];
    self.window.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]; // kHexColor(0xffffff)
    if (@available(iOS 13.0, *)) {
       self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    // Visit Apple's developer site to trigger the network permission prompt
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://developer.apple.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // No need to handle the response
    }] resume];
      
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:[HomeViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

@end
