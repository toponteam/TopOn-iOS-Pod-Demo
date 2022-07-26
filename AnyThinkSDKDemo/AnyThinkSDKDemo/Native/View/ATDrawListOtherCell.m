//
//  ATDrawListOtherCell.m
//  AnyThinkSDKDemo
//
//  Created by Topon on 7/26/22.
//  Copyright © 2022 抽筋的灯. All rights reserved.
//

#import "ATDrawListOtherCell.h"
#import <AVFoundation/AVFoundation.h>
#import "ATDemoOfferAdMode.h"
#import "ATVideoPlayerManager.h"

@interface ATDrawListOtherCell ()
@property (weak, nonatomic) IBOutlet UIView *contanerView;
@end

@implementation ATDrawListOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor blackColor];
    
    [self layoutTopView];
}

- (void)setCellData:(ATDemoOfferAdMode *)cellData {
    _cellData = cellData;
    [[ATVideoPlayerManager sharedManager] refreshContanerView:self withVideoUrlStr:_cellData.drawVideoUrlStr];
}

#pragma mark - layout
-(void)layoutTopView {
    UITapGestureRecognizer *tapsVideo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapVideo:)];
    tapsVideo.numberOfTapsRequired = 1;
    [self.contentView addGestureRecognizer:tapsVideo];
}

-(void)tapVideo:(UITapGestureRecognizer *)gesture {
    NSLog(@"video is click");
    if ([ATVideoPlayerManager sharedManager].isPlaying) {
        [[ATVideoPlayerManager sharedManager] pauseVideo];
    } else {
        [[ATVideoPlayerManager sharedManager] playVideo];
    }
}


#pragma mark - dealloc
-(void)dealloc {
    NSLog(@"ATDrawListOtherCell dealloc");
}

@end
