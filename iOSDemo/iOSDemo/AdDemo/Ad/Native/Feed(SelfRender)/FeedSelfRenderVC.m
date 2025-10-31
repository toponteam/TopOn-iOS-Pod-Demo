//
//  FeedSelfRenderVC.m
//  iOSDemo
//
//  Created by ltz on 2025/1/21.
//

#import "FeedSelfRenderVC.h"

#import <AnyThinkNative/AnyThinkNative.h>

#import <MJRefresh/MJRefresh.h>
#import "SelfRenderView.h"
#import "DemoOfferAdModel.h"
#import "AdCell.h"
#import "CustomCell.h"
#import "AdLoadConfigTool.h"

@interface FeedSelfRenderVC () <ATNativeADDelegate,UITableViewDelegate,UITableViewDataSource>
 
@property (nonatomic, strong) NSMutableArray <DemoOfferAdModel *> * dataSourceArray;
@property (nonatomic, strong) UITableView * feedTableView;

@end

@implementation FeedSelfRenderVC

// Placement ID
#define Feed_Native_SelfRender_PlacementID @"n67eceed5a282d"

// Scene ID, optional, can be generated in the backend. Pass empty string if not available
#define Feed_Native_SelfRender_SceneID @""
 
- (void)dealloc {
   NSLog(@"FeedSelfRenderVC dealloc");
   // Destroy unreleased ads
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSourceArray[indexPath.row].isNativeAd) {
        // Ad cell, dynamic height
        return UITableViewAutomaticDimension;
    }
    // Other cells, custom height
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DemoOfferAdModel *offerModel = self.dataSourceArray[indexPath.row];
    
    if (offerModel.isNativeAd) {
        // New ad available, can refresh
        ATNativeAdOffer *offer = [self getOfferAndLoadNext];
        if (offer) {
            offerModel.nativeADView = [self getNativeADViewWithOffer:offer];
            offerModel.offer = offer;
        }
        
        AdCell *cell = [[AdCell alloc] initWithStyle:0 reuseIdentifier:@"AdCell"];
        ATDemoLog(@"adView之前--%@",cell.adView);
        cell.adView = offerModel.nativeADView;
        ATDemoLog(@"adView之后--%@",cell.adView);
        return cell;
        
    }else{
        CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
        return cell;
    }
}
   
/// Get ATNativeADView object through ad offer
/// - Parameter offer: The obtained ad offer
- (ATNativeADView *)getNativeADViewWithOffer:(ATNativeAdOffer *)offer {
   
    // Initialize config configuration
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    // Pre-layout for native ad
    config.ADFrame = CGRectMake(0, 0, SelfRenderViewWidth, SelfRenderViewHeight);
    // Pre-layout for video player, recommend to layout again after adding to custom view
    config.mediaViewFrame = CGRectMake(0, 0, SelfRenderViewMediaViewWidth, SelfRenderViewMediaViewHeight);
    config.delegate = self;
    config.rootViewController = self;
    // Set auto-play only in WiFi mode, effective for some ad platforms
    config.videoPlayType = ATNativeADConfigVideoPlayOnlyWiFiAutoPlayType;
    
    // [Manual Layout] Precisely set logo size and position, choose one implementation with [Masonry Method] below
//    config.logoViewFrame = CGRectMake(kScreenW-40-10-15, SelfRenderViewHeight-50-10, 40, 40);
    
    // Set ad platform logo position preference (some ad platforms cannot be precisely set, use the code below, Demo examples all show bottom-right corner)
    // Only when logoUrl or logo has value in material offer, can be set through SelfRenderView layout, otherwise use examples in this method for precise control or preference position setting.
    [ATAPI sharedInstance].preferredAdLogoPosition = ATAdLogoPositionBottomRightCorner;
    
    // Set ad identifier coordinates x and y, effective for some ad platforms
    // config.adChoicesViewOrigin = CGPointMake(10, 10);
     
    // Print material components
    NSDictionary *offerInfoDict = [Tools getOfferInfo:offer];
    ATDemoLog(@"🔥🔥🔥--自渲染广告素材，展示前：%@",offerInfoDict);
    
    // Create self-render view and assign values based on offer information
    SelfRenderView *selfRenderView = [[SelfRenderView alloc] initWithOffer:offer];
    
    // Create ad nativeADView
    // Get native ad display container view
    ATNativeADView *nativeADView = [[ATNativeADView alloc] initWithConfiguration:config currentOffer:offer placementID:Feed_Native_SelfRender_PlacementID];
    
    // Create container array for clickable components
    NSMutableArray *clickableViewArray = [NSMutableArray array];
    
    // Get mediaView, need to add to self-render view manually, must call
    UIView *mediaView = [nativeADView getMediaView];
    if (mediaView) {
        // Assign and layout
        selfRenderView.mediaView = mediaView;
    }
    
    // Set UI controls that need to register click events, better not to add the entire parent view of the feed to click events, otherwise clicking the close button may still trigger the feed click event.
    [clickableViewArray addObjectsFromArray:@[selfRenderView.iconImageView,
                                              selfRenderView.titleLabel,
                                              selfRenderView.textLabel,
                                              selfRenderView.ctaLabel,
                                              selfRenderView.mainImageView]];
    
    // Register click events for UI controls
    [nativeADView registerClickableViewArray:clickableViewArray];
    
    // Bind components
    [self prepareWithNativePrepareInfo:selfRenderView nativeADView:nativeADView];
    
    // Render ad
    [offer rendererWithConfiguration:config selfRenderView:selfRenderView nativeADView:nativeADView];
    
    // [Masonry Method] Precisely set logo size and position, choose one implementation with [Manual Layout] above, call after rendering ad, operate based on nativeADView
    [nativeADView.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(nativeADView).mas_offset(-25);
        make.width.height.mas_equalTo(15);
    }];
 
    // Hide logo, use with caution, please read documentation: Self-render Ad Considerations
    //nativeADView.logoImageView.hidden = YES;
  
    return nativeADView;
}

#pragma mark - Bind Components
- (void)prepareWithNativePrepareInfo:(SelfRenderView *)selfRenderView nativeADView:(ATNativeADView *)nativeADView {
    // Which components need binding and which don't, please refer to documentation: Native Ad Considerations
    ATNativePrepareInfo *info = [ATNativePrepareInfo loadPrepareInfo:^(ATNativePrepareInfo * prepareInfo) {
        prepareInfo.textLabel = selfRenderView.textLabel;
        prepareInfo.advertiserLabel = selfRenderView.advertiserLabel;
        prepareInfo.titleLabel = selfRenderView.titleLabel;
        prepareInfo.ratingLabel = selfRenderView.ratingLabel;
        prepareInfo.iconImageView = selfRenderView.iconImageView;
        prepareInfo.mainImageView = selfRenderView.mainImageView;
        prepareInfo.ctaLabel = selfRenderView.ctaLabel;
        prepareInfo.dislikeButton = selfRenderView.dislikeButton;
        prepareInfo.mediaView = selfRenderView.mediaView;
    }];
    [nativeADView prepareWithNativePrepareInfo:info];
}

#pragma mark - Data Processing

/// Add data source
/// - Parameter isSuccess: Whether ad loading is successful
- (void)setDataWithRequest:(BOOL)isSuccess {
    if (isSuccess) {
        // Ad loading successful, get offer and add data model
        ATNativeAdOffer *offer = [self getOfferAndLoadNext];
        if (offer) {
            DemoOfferAdModel *offerModel = [[DemoOfferAdModel alloc] init];
            offerModel.nativeADView = [self getNativeADViewWithOffer:offer];
            offerModel.offer = offer;
            // Mark as ad
            offerModel.isNativeAd = YES;
            [self.dataSourceArray addObject:offerModel];
        }
    }
    
    // Add non-ad models, simulate developer's own business cells
    for (int i = 0; i < 3; i ++) {
        DemoOfferAdModel *offerModel1 = [[DemoOfferAdModel alloc] init];
        offerModel1.isNativeAd = NO;
        [self.dataSourceArray addObject:offerModel1];
    }
    [self.feedTableView reloadData];
}

/// Get offer and initiate next load
- (ATNativeAdOffer *)getOfferAndLoadNext {
    
    // Scene statistics feature, optional integration
    [[ATAdManager sharedManager] entryNativeScenarioWithPlacementID:Feed_Native_SelfRender_PlacementID scene:Feed_Native_SelfRender_SceneID];
    
    ATNativeAdOffer *offer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:Feed_Native_SelfRender_PlacementID];
    // Load next
    [self loadNativeAd];
    
    return offer;
}

/// User clicks close, remove ad from list
/// - Parameter nativeADView: Ad adView
- (void)removeAd:(ATNativeADView *)nativeADView {
    for (int i=0; i<self.dataSourceArray.count; i++) {
        DemoOfferAdModel *offerModel = self.dataSourceArray[i];
        if (offerModel.isNativeAd && offerModel.nativeADView == nativeADView) {
            
            if (nativeADView && nativeADView.superview) {
                [nativeADView removeFromSuperview];
            }
            // Destroy ad view
            [nativeADView destroyNative];
            // Destroy offer
            offerModel.offer = nil;
            offerModel.nativeADView = nil;
            
            [self.dataSourceArray removeObject:offerModel];
            [self.feedTableView reloadData];
             
            break;
        }
    }
}
  
/// Print related information for testing
/// - Parameters:
///   - offer: Ad material
///   - nativeADView: Ad object view
- (void)printNativeAdInfoAfterRendererWithOffer:(ATNativeAdOffer *)offer nativeADView:(ATNativeADView *)nativeADView {
    ATNativeAdRenderType nativeAdRenderType = [nativeADView getCurrentNativeAdRenderType];
    if (nativeAdRenderType == ATNativeAdRenderExpress) {
        ATDemoLog(@"⚠️⚠️⚠️--这是原生模板了");
    } else {
        ATDemoLog(@"✅✅✅--这是原生自渲染");
    }
    BOOL isVideoContents = [nativeADView isVideoContents];
    
    // Print all material content
    [Tools printNativeAdOffer:offer];
    ATDemoLog(@"🔥--是否为原生视频广告：%d",isVideoContents);
}

#pragma mark - Placement Delegate Callbacks
/// Placement loading completed
/// - Parameter placementID: Placement ID
- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    BOOL isReady = [[ATAdManager sharedManager] nativeAdReadyForPlacementID:placementID];
    [self showLog:[NSString stringWithFormat:@"didFinishLoadingADWithPlacementID:%@ SelfRender 是否准备好:%@", placementID,isReady ? @"YES":@"NO"]];
    
    if (self.feedTableView.mj_footer.refreshing == YES) {
        [self.feedTableView.mj_footer endRefreshing];
        // Request successful, pass YES to get ad data
        [self setDataWithRequest:YES];
    }
}
 
/// Placement loading failed
/// - Parameters:
///   - placementID: Placement ID
///   - error: Error information
- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    ATDemoLog(@"didFailToLoadADWithPlacementID:%@ error:%@", placementID, error);
    [self showLog:[NSString stringWithFormat:@"didFailToLoadADWithPlacementID:%@ errorCode:%ld", placementID, error.code]];
    
    if (self.feedTableView.mj_footer.refreshing == YES) {
        [self.feedTableView.mj_footer endRefreshing];
        // Request failed
        [self setDataWithRequest:NO];
    }
}

/// Received display revenue
/// - Parameters:
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)didRevenueForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didRevenueForPlacementID:%@ with extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didRevenueForPlacementID:%@", placementID]];
}

#pragma mark - Native Ad Event Callbacks

/// Native ad displayed
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
- (void)didShowNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didShowNativeAdInAdView:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didShowNativeAdInAdView:%@", placementID]];
    
    
}

/// Native ad close button clicked
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
- (void)didTapCloseButtonInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didTapCloseButtonInAdView:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"didTapCloseButtonInAdView:%@", placementID]];
    
    // Remove from list
    [self removeAd:adView];
}

/// Native ad started playing video
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)didStartPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didStartPlayingVideoInAdView:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didStartPlayingVideoInAdView:%@", placementID]];
}

/// Native ad video playback ended
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)didEndPlayingVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didEndPlayingVideoInAdView:%@ extra: %@", placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didEndPlayingVideoInAdView:%@", placementID]];
}

/// Native ad user clicked
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information dictionary
- (void)didClickNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didClickNativeAdInAdView:%@ extra:%@",placementID,extra);
    [self showLog:[NSString stringWithFormat:@"didClickNativeAdInAdView:%@", placementID]];
}
 
/// Native ad opened or jumped to deep link page
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
///   - success: Whether successful
- (void)didDeepLinkOrJumpInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra result:(BOOL)success {
    ATDemoLog(@"didDeepLinkOrJumpInAdView:placementID:%@ with extra: %@, success:%@", placementID,extra, success ? @"YES" : @"NO");
    [self showLog:[NSString stringWithFormat:@"didDeepLinkOrJumpInAdView:%@, success:%@", placementID, success ? @"YES" : @"NO"]];
}
 
/// Native ad entered full-screen video playback, usually auto-jumps to a playback landing page after clicking video mediaView
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
- (void)didEnterFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra{
    ATDemoLog(@"didEnterFullScreenVideoInAdView:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didEnterFullScreenVideoInAdView:%@", placementID]];
}

/// Native ad exited full-screen video playback
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
- (void)didExitFullScreenVideoInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didExitFullScreenVideoInAdView:%@", placementID);
    [self showLog:[NSString stringWithFormat:@"didExitFullScreenVideoInAdView:%@", placementID]];
}
 
/// Native ad exited detail page
/// - Parameters:
///   - adView: Ad view object
///   - placementID: Placement ID
///   - extra: Extra information
- (void)didCloseDetailInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    ATDemoLog(@"didCloseDetailInAdView:%@ extra:%@", placementID, extra);
    [self showLog:[NSString stringWithFormat:@"didCloseDetailInAdView:%@", placementID]];
}

#pragma mark - TableView Data Refresh
- (void)footerRefresh {
    self.feedTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upFreshLoadMoreData)];
    [self.feedTableView.mj_footer beginRefreshing];
}

/// Load more
- (void)upFreshLoadMoreData {
    [self loadNativeAd];
}
 
/// Load ad
- (void)loadNativeAd {
    NSMutableDictionary * loadConfigDict = [NSMutableDictionary dictionary];
    
    // Set ad request size
    [loadConfigDict setValue:[NSValue valueWithCGSize:CGSizeMake(SelfRenderViewWidth, SelfRenderViewHeight)] forKey:kATExtraInfoNativeAdSizeKey];
    // Request adaptive size native ad (available for some ad platforms) (optional integration)
    [AdLoadConfigTool native_loadExtraConfigAppend_SizeToFit:loadConfigDict];
    
    // KuaiShou native ad swipe and click control
//    [AdLoadConfigTool native_loadExtraConfigAppend_KuaiShou_SlideOrClickAble:loadConfigDict];
    
    [[ATAdManager sharedManager] loadADWithPlacementID:Feed_Native_SelfRender_PlacementID extra:loadConfigDict delegate:self];
}
 
#pragma mark - getter
- (UITableView *)feedTableView {
    if (!_feedTableView) {
        _feedTableView = [[UITableView alloc] init];
        _feedTableView.delegate = self;
        _feedTableView.dataSource = self;
        _feedTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        // Bind cells
        [_feedTableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
        [_feedTableView registerClass:[AdCell class] forCellReuseIdentifier:@"AdCell"];
        
        // Set a reasonable estimated height
        _feedTableView.estimatedRowHeight = SelfRenderViewHeight; // Set a reasonable estimated value
        _feedTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _feedTableView;
}

- (NSMutableArray *)dataSourceArray {
    if (_dataSourceArray) return _dataSourceArray;
    NSMutableArray *dataSourceArray = [NSMutableArray array];
    return _dataSourceArray = dataSourceArray;
}
 
#pragma mark - Demo UI
- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self.view addSubview:self.feedTableView];
    [self.feedTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nbar.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self footerRefresh];
}
 
@end
