//
//  ATSuspendedButton.h
//  TestHashMap
//
//  Created by mac on 2022/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATSuspendedButton : UIButton

- (instancetype)initWithProtocolList:(NSArray *)protocolList;

- (void)recordWithPlacementId:(NSString *)placementId protocol:(NSString *)protocolMethod;

@end

NS_ASSUME_NONNULL_END
