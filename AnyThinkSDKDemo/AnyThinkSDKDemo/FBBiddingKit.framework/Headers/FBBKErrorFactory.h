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

typedef NS_ENUM(NSInteger, FBBKErrorCode) {
    FBBKErrorCodeUnknown    = 1000,
    FBBKErrorCodeNoBid      = 1001,
    FBBKErrorCodeBadRequest = 1002,
    FBBKErrorCodeTimeout    = 1003,

    FBBKErrorCodeParsingFailed = 1100,
    FBBKErrorCodeRemoteAuctionFailure = 1101,
};

NS_ASSUME_NONNULL_BEGIN

@protocol FBBKErrorFactory <NSObject>

- (NSError *_Nullable)errorFromBidURLResponse:(NSURLResponse *)response;
- (NSError *_Nullable)errorFromBidParsingError:(NSError *_Nullable)error;
- (NSError *)errorForRemoteAuctionFailureWithDetails:(NSString *)details;

- (BOOL)isBiddingKitError:(NSError *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
