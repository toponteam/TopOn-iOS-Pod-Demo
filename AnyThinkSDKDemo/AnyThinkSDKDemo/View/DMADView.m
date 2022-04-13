//
//  DMADView.m
//  AnyThingSDKDemo
//
//  Created by mac on 2021/12/8.
//

#import "DMADView.h"
#import "ATAutoLayout.h"
#import "MTAutolayoutCategories.h"

@implementation DMADView

-(void) initSubviews {
    [super initSubviews];
    
    _advertiserLabel = [UILabel autolayoutLabelFont:[UIFont boldSystemFontOfSize:15.0f] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self addSubview:_advertiserLabel];
    
    _titleLabel = [UILabel autolayoutLabelFont:[UIFont boldSystemFontOfSize:18.0f] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self addSubview:_titleLabel];
    
    _textLabel = [UILabel autolayoutLabelFont:[UIFont systemFontOfSize:15.0f] textColor:[UIColor blackColor]];
    [self addSubview:_textLabel];
    
    _ctaLabel = [UILabel autolayoutLabelFont:[UIFont systemFontOfSize:15.0f] textColor:[UIColor blackColor]];
    _ctaLabel.userInteractionEnabled = YES;
    [self addSubview:_ctaLabel];
    
    _ratingLabel = [UILabel autolayoutLabelFont:[UIFont systemFontOfSize:15.0f] textColor:[UIColor blackColor]];
    [self addSubview:_ratingLabel];
    
    _iconImageView = [UIImageView autolayoutView];
    _iconImageView.layer.cornerRadius = 4.0f;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.userInteractionEnabled = YES;
    [self addSubview:_iconImageView];
    
    _mainImageView = [UIImageView autolayoutView];
    _mainImageView.contentMode = UIViewContentModeScaleAspectFit;
    _mainImageView.userInteractionEnabled = YES;
    [self addSubview:_mainImageView];
    
    _logoImageView = [UIImageView autolayoutView];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_logoImageView];
    
    _sponsorImageView = [UIImageView autolayoutView];
    _sponsorImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    [self addSubview:_sponsorImageView];
    
    _dislikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dislikeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_dislikeButton];
}

-(NSArray<UIView*>*)clickableViews {
    NSMutableArray<UIView*> *clickableViews = [NSMutableArray<UIView*> arrayWithObjects:_iconImageView,_titleLabel,_textLabel, _ctaLabel, _mainImageView, nil];
    if (self.mediaView != nil) { [clickableViews addObject:self.mediaView]; }
    return clickableViews;
}

-(void) layoutMediaView {
    self.mediaView.frame = CGRectMake(0, 120.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 120.0f);
}

-(void) makeConstraintsForSubviews {
    [super makeConstraintsForSubviews];
    NSDictionary *viewsDict = nil;
    if (self.mediaView != nil) {
        viewsDict = @{@"titleLabel":self.titleLabel, @"textLabel":self.textLabel, @"ctaLabel":self.ctaLabel, @"ratingLabel":self.ratingLabel, @"iconImageView":self.iconImageView, @"mainImageView":self.mainImageView, @"logoImageView":self.logoImageView, @"mediaView":self.mediaView, @"advertiserLabel":self.advertiserLabel, @"sponsorImageView":self.sponsorImageView};
    } else {
        viewsDict = @{@"titleLabel":self.titleLabel, @"textLabel":self.textLabel, @"ctaLabel":self.ctaLabel, @"ratingLabel":self.ratingLabel, @"iconImageView":self.iconImageView, @"logoImageView":self.logoImageView, @"mainImageView":self.mainImageView, @"advertiserLabel":self.advertiserLabel, @"sponsorImageView":self.sponsorImageView};
    }
    [self addConstraintsWithVisualFormat:@"|[mainImageView]|" options:0 metrics:nil views:viewsDict];
    [self addConstraintsWithVisualFormat:@"[logoImageView(60)]-5-|" options:0 metrics:nil views:viewsDict];
    [self addConstraintsWithVisualFormat:@"V:[logoImageView(20)]-5-|" options:0 metrics:nil views:viewsDict];
    [self addConstraintsWithVisualFormat:@"V:[iconImageView]-20-[mainImageView]|" options:0 metrics:nil views:viewsDict];
    
    [self addConstraintWithItem:self.iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:.0f];
    
//    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [self addConstraintsWithVisualFormat:@"|-15-[iconImageView(90)]-8-[titleLabel]-8-[sponsorImageView]-15-|" options:NSLayoutFormatAlignAllTop metrics:nil views:viewsDict];
    [self addConstraintsWithVisualFormat:@"V:|-15-[titleLabel]-8-[textLabel]-8-[ctaLabel]-8-[ratingLabel]-8-[advertiserLabel]" options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing metrics:nil views:viewsDict];
    
    NSLayoutConstraint *btn_right = [NSLayoutConstraint constraintWithItem:self.dislikeButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:5];
    
    NSLayoutConstraint *btn_top = [NSLayoutConstraint constraintWithItem:self.dislikeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:50];
    
    NSLayoutConstraint *btn_width = [NSLayoutConstraint constraintWithItem:self.dislikeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
    
    NSLayoutConstraint *btn_height = [NSLayoutConstraint constraintWithItem:self.dislikeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
    
    [self addConstraints:@[btn_right,btn_top,btn_width,btn_height]];
    
    UIImage *closeImg = [UIImage imageNamed:@"icon_webview_close" inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AnyThinkSDK" ofType:@"bundle"]] compatibleWithTraitCollection:nil];
    [_dislikeButton setImage:closeImg forState:0];
    
}

-(void) makeConstraintsDrawVideoAssets {
    NSMutableDictionary<NSString*, UIView*> *viewsDict = [NSMutableDictionary<NSString*, UIView*> dictionary];
    if (self.dislikeButton != nil) { viewsDict[@"dislikeButton"] = self.dislikeButton; }
    if (self.adLabel != nil) { viewsDict[@"adLabel"] = self.adLabel; }
    if (self.logoImageView != nil) { viewsDict[@"logoImageView"] = self.logoImageView; }
    if (self.logoADImageView != nil) { viewsDict[@"logoAdImageView"] = self.logoADImageView; }
    if (self.videoAdView != nil) { viewsDict[@"videoView"] = self.videoAdView; }
    
    if ([viewsDict count] == 5) {
        self.dislikeButton.translatesAutoresizingMaskIntoConstraints = self.adLabel.translatesAutoresizingMaskIntoConstraints = self.logoImageView.translatesAutoresizingMaskIntoConstraints = self.logoADImageView.translatesAutoresizingMaskIntoConstraints = self.videoAdView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraintsWithVisualFormat:@"V:[logoAdImageView]-15-|" options:0 metrics:nil views:viewsDict];
        [self addConstraintsWithVisualFormat:@"|-15-[dislikeButton]-5-[adLabel]-5-[logoImageView]-5-[logoAdImageView]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:viewsDict];
        [self addConstraintsWithVisualFormat:@"|[videoView]|" options:0 metrics:nil views:viewsDict];
        [self addConstraintsWithVisualFormat:@"V:[videoView(height)]|" options:0 metrics:@{@"height":@(CGRectGetHeight(self.bounds) - 120.0f)} views:viewsDict];
    }
}

@end
