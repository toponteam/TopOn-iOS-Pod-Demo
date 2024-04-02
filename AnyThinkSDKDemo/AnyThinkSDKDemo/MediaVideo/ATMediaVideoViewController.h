//
//  ATMediaVideoViewController.h
//  AnyThinkSDKDemo
//
//  Created by li zhixuan on 2024/3/26.
//  Copyright © 2024 抽筋的灯. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATADFootView.h"
#import "ATMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATMediaVideoViewController : UIViewController

@property (copy, nonatomic) NSString *placementID;
@property (copy, nonatomic) NSDictionary<NSString *, NSString *> *placementIDs;

@property (nonatomic, strong) ATMenuView *menuView;
@property (nonatomic, strong) ATADFootView *footView;

@end

NS_ASSUME_NONNULL_END
