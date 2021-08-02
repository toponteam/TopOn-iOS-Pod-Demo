// Copyright 2004-present Facebook. All Rights Reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>

@class FBBKConfiguration;
@protocol FBBKAuctionRunner;
@protocol FBBKNotifier;
@protocol FBBKBidder;
@protocol FBBKNetworkingService;
@protocol FBBKContext;
@protocol FBBKErrorFactory;
@protocol FBBKLogger;
@protocol FBBKEventDispatcher;
@protocol FBBKAuctionInternal;
@protocol FBBKUserAgentProvider;

NS_ASSUME_NONNULL_BEGIN

@protocol FBBKAssembly <NSObject>

@property (nonatomic, readonly) FBBKConfiguration *configuration;
@property (nonatomic, readonly) dispatch_queue_t workingQueue;
@property (nonatomic, readonly) id<FBBKNetworkingService> networkingService;
@property (nonatomic, readonly) id<FBBKContext> context;
@property (nonatomic, readonly) id<FBBKErrorFactory> errorFactory;
@property (nonatomic, readonly) id<FBBKLogger> logger;
@property (nonatomic, readonly) id<FBBKEventDispatcher> eventDispatcher;
@property (nonatomic, readonly) id<FBBKUserAgentProvider> userAgentProvider;
@property (nonatomic, readonly) id<FBBKAuctionRunner> (^auctionRunnerFactory)(NSString *auctionId, NSURL *_Nullable serverAuctionURL);
@property (nonatomic, readonly) NSSet<id<FBBKNotifier>> *(^notifiersProvider)(NSSet<id<FBBKBidder>> *bidders,
                                                                              NSString *auctionId);
@property (nonatomic, readonly) id<FBBKAuctionInternal> (^auctionFactory)(NSSet<id<FBBKBidder>> *bidders);

@end

@interface NSObject (FBBKAssembly)
@property (nonatomic, readonly) id<FBBKAssembly> fbbk_assembly;
@end

NS_ASSUME_NONNULL_END
