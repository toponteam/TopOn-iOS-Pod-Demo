//
//  ATNaviewListAdCell.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/6/30.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATNaviewListAdCell.h"

@interface ATNaviewListAdCell()

@end

@implementation ATNaviewListAdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    

}

- (void)setAdView:(ATNativeADView *)adView{
    
    if (_adView == adView) {
        return;
    }
    
    [_adView removeFromSuperview];

    [self.contentView addSubview:adView];
    
    [adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.width.equalTo(@kScreenW);
        make.height.equalTo(@350);
    }];
    
    _adView = adView;
    
}


@end
