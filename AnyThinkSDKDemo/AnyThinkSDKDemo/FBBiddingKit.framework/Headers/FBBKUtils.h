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

extern NSString *const kFBBKNoBidderName;
extern NSString *const kFBBKErrorDomain;

#ifndef FBBKBlockCallSafe
    #define FBBKBlockCallSafe(value, ...) ((value) ? (value)(__VA_ARGS__) : (void)0)
#endif

#ifndef FBBKTypedValue
    #define FBBKTypedValue(value, klass) ([(value) isKindOfClass:[klass class]] ? (klass *)(value) : nil)
#endif

#ifndef FBBKNonNullString
    #define FBBKNonNullString(value) ((value) ?: @"")
#endif

#ifdef __cplusplus
extern "C" {
#endif
    NSUInteger FBBKReplaceURLPlaceholders(NSMutableString *urlString);
    NSURL *FBBKProcessURLStringWithParameters(NSString *urlString, NSDictionary<NSString *, NSString *> *parameters);
    NSInteger FBBKCreateUniqueIdentifier(void);
    NSString *FBBKCreateUniqueStringIdentifier(void);
    NSDecimalNumber *FBBKPriceValue(double price);
    NSString *FBBKComputeExtId(NSString *appId, NSTimeInterval timestamp);
#ifdef __cplusplus
}   // Extern C
#endif
