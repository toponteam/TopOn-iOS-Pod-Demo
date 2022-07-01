//
//  ATTestListViewController.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/4/20.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATTestListViewController.h"
#import "ATHomeTableViewCell.h"
#import <Masonry/Masonry.h>

@interface ATTestListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ATTestListViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - set ui
- (void)setupUI{
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kScaleW(238 + 10);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ATHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ATHomeTableViewCell idString]];
    cell.backgroundColor = kRGB(245, 245, 245);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", dic[@"title"]];
    cell.subTitleLabel.text = [NSString stringWithFormat:@"%@", dic[@"des"]];
    cell.logoImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", dic[@"image"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    if (indexPath.row == 0) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Performance" bundle:[NSBundle mainBundle]];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    if (indexPath.row == 1) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BannerShow" bundle:[NSBundle mainBundle]];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"NativeShow" bundle:[NSBundle mainBundle]];
        UIViewController *vc = [storyboard instantiateInitialViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - lazy
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[ATHomeTableViewCell class] forCellReuseIdentifier:[ATHomeTableViewCell idString]];
    }
    return _tableView;
}

- (NSArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = @[
            @{
                @"image":@"interstitial",
                @"title":@"Performance",
                @"des":@"性能测试",
            },
    
            @{
                @"image":@"interstitial",
                @"title":@"Banner show",
                @"des":@"同广告位 多横幅广告展示",
            },
            @{
                @"image":@"interstitial",
                @"title":@"Nanner show",
                @"des":@"同广告位 多原生广告展示",
            }
        ];
    }
    return _dataSource;
}
@end
