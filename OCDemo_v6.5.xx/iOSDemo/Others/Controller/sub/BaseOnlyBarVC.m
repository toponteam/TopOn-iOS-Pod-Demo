//
//  BaseOnlyBarVC.m
//  AnyThinkSDKDemo
//
//  Created by TopOn技术支持 on 2025/7/3.
//

#import "BaseOnlyBarVC.h"

@interface BaseOnlyBarVC ()

@end

@implementation BaseOnlyBarVC

#pragma mark - Demo Needed (No need to integrate)
- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self setupDemoUI];
}

- (void)setupDemoUI {
    [self addNormalBarWithTitle:self.title];
}

@end
