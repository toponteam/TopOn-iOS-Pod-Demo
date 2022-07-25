//
//  ATNativeSelfRenderView.m
//  AnyThinkSDKDemo
//
//  Created by GUO PENG on 2022/5/7.
//  Copyright © 2022 AnyThink. All rights reserved.
//

#import "ATNativeSelfRenderView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface ATNativeSelfRenderView()

@property(nonatomic, strong) ATNativeAdOffer *nativeAdOffer;

@end


@implementation ATNativeSelfRenderView

- (void)dealloc{
    NSLog(@"🔥---ATNativeSelfRenderView--销毁");
}

- (instancetype) initWithOffer:(ATNativeAdOffer *)offer{

    if (self = [super init]) {
        
        _nativeAdOffer = offer;
        
        [self addView];
        [self makeConstraintsForSubviews];
        
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self addView];
        [self makeConstraintsForSubviews];
    }
    return self;
}

- (void)updateUIWithoffer:(ATNativeAdOffer *)offer{
    
    self.nativeAdOffer = offer;
    
    [self setupUI];


}
- (void)addView{
    
    self.advertiserLabel = [[UILabel alloc]init];
    self.advertiserLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.advertiserLabel.textColor = [UIColor blackColor];
    self.advertiserLabel.textAlignment = NSTextAlignmentLeft;
    self.advertiserLabel.userInteractionEnabled = YES;
    [self addSubview:self.advertiserLabel];
        
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.userInteractionEnabled = YES;

    [self addSubview:self.titleLabel];
    
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.font = [UIFont systemFontOfSize:15.0f];
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.userInteractionEnabled = YES;

    [self addSubview:self.textLabel];
    
    self.ctaLabel = [[UILabel alloc]init];
    self.ctaLabel.font = [UIFont systemFontOfSize:15.0f];
    self.ctaLabel.textColor = [UIColor blackColor];
    self.ctaLabel.userInteractionEnabled = YES;

    [self addSubview:self.ctaLabel];

    self.ratingLabel = [[UILabel alloc]init];
    self.ratingLabel.font = [UIFont systemFontOfSize:15.0f];
    self.ratingLabel.textColor = [UIColor blackColor];
    self.ratingLabel.userInteractionEnabled = YES;

    [self addSubview:self.ratingLabel];
    
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.layer.cornerRadius = 4.0f;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconImageView.userInteractionEnabled = YES;
    [self addSubview:self.iconImageView];
    
    
    self.mainImageView = [[UIImageView alloc]init];
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.mainImageView.userInteractionEnabled = YES;
    [self addSubview:self.mainImageView];
    
    self.logoImageView = [[UIImageView alloc]init];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.userInteractionEnabled = YES;

    [self addSubview:self.logoImageView];
    
    self.sponsorImageView = [[UIImageView alloc]init];
    self.sponsorImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.sponsorImageView.userInteractionEnabled = YES;

    [self addSubview:self.sponsorImageView];
    
    self.dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *closeImg = [UIImage imageNamed:@"icon_webview_close" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AnyThinkSDK" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
    
    self.dislikeButton.backgroundColor = randomColor;
    
    [self.dislikeButton setImage:closeImg forState:0];
    [self addSubview:self.dislikeButton];
}


- (void)setupUI{
    

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.nativeAdOffer.nativeAd.iconUrl]];
    
    
    NSLog(@"🔥----iconUrl:%@",self.nativeAdOffer.nativeAd.iconUrl);


    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.nativeAdOffer.nativeAd.imageUrl]];
   
    
    NSLog(@"🔥----imageUrl:%@",self.nativeAdOffer.nativeAd.imageUrl);
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.nativeAdOffer.nativeAd.logoUrl]];
   
    
    NSLog(@"🔥----logoUrl:%@",self.nativeAdOffer.nativeAd.logoUrl);
    
    self.sponsorImageView.image = self.nativeAdOffer.nativeAd.sponsorImage;
    
    self.advertiserLabel.text = self.nativeAdOffer.nativeAd.advertiser;

    
    self.titleLabel.text = self.nativeAdOffer.nativeAd.title;
  
    self.textLabel.text = self.nativeAdOffer.nativeAd.mainText;
     
    self.ctaLabel.text = self.nativeAdOffer.nativeAd.ctaText;
  
    self.ratingLabel.text = [NSString stringWithFormat:@"%@", self.nativeAdOffer.nativeAd.rating ? self.nativeAdOffer.nativeAd.rating : @""];
}

-(void) makeConstraintsForSubviews {
    
    self.backgroundColor = randomColor;

    self.titleLabel.backgroundColor = randomColor;
    
    self.textLabel.backgroundColor = randomColor;
    
    [self.sponsorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@25);
        make.bottom.equalTo(self).equalTo(@-5);
        make.right.equalTo(self.logoImageView.mas_left).equalTo(@-5);
    }];
    
  
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@25);
        make.bottom.equalTo(self).equalTo(@-5);
        make.left.equalTo(self).equalTo(@5);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-40);
        make.height.equalTo(@20);
        make.top.equalTo(self).offset(20);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(100);
        make.right.equalTo(self).offset(-40);
        make.height.equalTo(@20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.ctaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).equalTo(@5);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.left.equalTo(self.textLabel.mas_left);
    }];
    
    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ctaLabel.mas_right).offset(20);
        make.height.equalTo(@40);
        make.top.equalTo(self.ctaLabel.mas_top).offset(0);
        make.width.equalTo(@20);
    }];
    
    [self.advertiserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@30);
        make.right.equalTo(self).equalTo(@-5);
        make.left.equalTo(self.ctaLabel.mas_right).offset(50);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.height.width.equalTo(@75);
        make.top.equalTo(self).offset(20);
    }];
    
    [self.mainImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(25);
        make.bottom.equalTo(self).offset(-5);
    }];


    [self.dislikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@30);
        make.top.equalTo(self).equalTo(@5);
        make.right.equalTo(self.mas_right).equalTo(@-5);
    }];
    
}

@end
