//
//  DataUploadTool.m
//  iOSDemo
//
//  Created by ltz on 2025/3/26.
//

#import "DataUploadTool.h"

//#import <AppsFlyerLib/AppsFlyerLib.h>
//
//#import <AdjustSdk/Adjust.h>
//#import <AdjustSdk/ADJAdRevenue.h>
//
//#import <FirebaseAnalytics/FirebaseAnalytics.h>
 
// Extra parameter examples and descriptions:
//{
//    id = 84c3c5940e4fab2d8712299d631e09b3; // Display ID generated for each impression
//    "publisher_revenue" = "0.0015"; //Revenue from each impression
//    "ad_source_id" = 9805; //Ad source ID, can query specific Network info via ad source ID in developer dashboard or SDK Open API
//    "network_firm_id" = 8;   //Refer to Network Firm Id Table
//    "adsource_isHeaderBidding" = 0;  //Whether it's Header Bidding ad source, 1 for Header Bidding ad source
//    "adsource_price" = 1.5;  // eCPM currency unit
//    precision = "publisher_defined"; // eCPM precision publisher_defined:developer-defined ecpm; exact:HB real-time bidding ecpm estimated: estimated ecpm
//    "adsource_index" = 0;  //Ad source priority, starting from 0 with highest priority
//    "ecpm_level" = 1; //Sorting by eCPM level
//    "segment_id" = 0; // Traffic group ID
//    "adunit_format" = Splash; //Ad type
//    "adunit_id" = b5e65ad3ab084b; // Ad placement ID (Placement ID)
//    country = CN; // Country
//    currency = USD; // Currency unit
//    "network_placement_id" = 887305510; // Third-party platform unit ID
//    "network_type" = Network; // network: third-party ads Cross_Promotion: cross promotion
//    "scenario_id" = f5e549727efc49;//Ad scenario ID
//    "scenario_reward_name" = rewardedSence; // Ad scenario reward name
//    "scenario_reward_number" = 0; // Ad scenario reward quantity
//    channel = "test_channel"; //Channel ID
//    "sub_channel" = "test_subchannel";//Sub-channel ID
//    "custom_rule" =     {
//        "custom_data_key" = "custom_data_val";
//    };//Custom rules
//    "ext_info" =     {
//        "creative_id" = "42-348448957";//Offer creative ID
//        "is_deeplink" = 0;//Whether it's Deeplink or JumpURL offer, 1 for Deeplink or JumpURL offer
//        "offer_id" = "GDTONLINE-348448957";//Offer ad ID
//        "currencyCode" = "USD", // AdMob impression revenue currency unit
//        "precision" = 0, // AdMob impression revenue precision, 0:unknown 1:estimated, 2:publisher provided 3:precise
//        "value" = 0.1, // AdMob impression revenue specific value
//        "en_p" = "5GWtXa-X-sazi-xluLlqMyBCGWIIAZQ_8p7bM2-LqeQ", //Baidu price encryption field, requires TopOnSDK>6.3.63, Baidu SDK≥=5.37
//    };//TopOn Adx & OnlineAPI Offer & AdMob extra information
//    "placement_type" = 1; // Placement type 1 for real placement, 2 for shared placement
//    "shared_placement_id" = p1en19jjiirsf3;// Shared placement ID
//    "user_load_extra_data" =     {// Custom parameter info passed before Load
//    "user_custom_data" = "media_val";
//    };
//}

@implementation DataUploadTool

/// Report information to app server, such as ad source load failure info for a specific placement
/// - Parameters:
///   - placementID: Placement ID
///   - info: Ad source information, refer to "Callback Information Description" documentation for detailed field meanings
+ (void)uploadAdSourceLoadFailed:(NSString *)placementID info:(NSMutableDictionary *)info {
    //In this method, you can collect ad source load failure information. For ad source loading implementation, refer to the above or documentation field descriptions
    //For example, in the methods below, call this method to collect failure information from error
    
//    /// Ad load fail
//    - (void)didFailToLoadADSourceWithPlacementID:(NSString*)placementID
//                                           extra:(NSDictionary*)extra
//                                           error:(NSError*)error;
//
//    /// Ad bidding fail
//    - (void)didFailBiddingADSourceWithPlacementID:(NSString*)placementID
//                                            extra:(NSDictionary*)extra
//                                            error:(NSError*)error;
    
    //Implement your reporting logic
}
 
//Before uncommenting, please install related SDKs using Cocoapods
//#Third-party data analytics SDKs
//#  pod 'AppsFlyerFramework'
//#  pod 'Adjust'
//#  pod 'FirebaseAnalytics'

/// Report impression revenue data to AppsFlyer
/// - Parameter extra: Extra parameter from delegate callback
+ (void)handleAppsFlyerRevenueReport:(NSDictionary *)extra {
    
//    NSString *unitId = extra[@"network_placement_id"];
//    // Developers with high precision requirements need to convert by themselves
//    double price = [extra[@"publisher_revenue"] doubleValue];
//    NSString *currency = extra[@"currency"];
//    NSString *country = extra[@"country"];
//    
//    // AppsFlyer provides multiple keys for developers to choose from, developers use according to their needs, this is an example.
//    [[AppsFlyerLib shared] logEvent: AFEventPurchase
//    withValues:@{
//        AFEventParamContentId:unitId,
//        AFEventParamRevenue: @(price),
//        AFEventParamCurrency:currency,
//        AFEventParamCountry:country
//    }];
}

/// Report impression revenue data to Adjust
/// - Parameter extra: Extra parameter from delegate callback
+ (void)handleAdjustRevenueReport:(NSDictionary *)extra {
    
//    // Developers with high precision requirements need to convert by themselves
//    double price = [extra[@"publisher_revenue"] doubleValue];
//    NSString *currency = extra[@"currency"];
//    
//    // Source: Revenue source (ADJAdRevenueSourceTopOn is only available in Adjust v4.37.1 and above)
//    ADJAdRevenue *adRevenue = [[ADJAdRevenue alloc] initWithSource:@"TopOn"];
//    // Pass revenue and currency values
//    [adRevenue setRevenue:price currency:currency];
//    
//    // Track ad revenue
//    [Adjust trackAdRevenue:adRevenue];
}

/// Report impression revenue data to Firebase
/// - Parameter extra: Extra parameter from delegate callback
+ (void)handleFirebaseRevenueReport:(NSDictionary *)extra {
 
//    // Developers with high precision requirements need to convert by yourselves
//    double price = [extra[@"publisher_revenue"] doubleValue];
//    NSString *currency = extra[@"currency"];
//    
//    // Create parameters
//    NSDictionary *params = @{
//        //Can add other key-value pairs
//        kFIRParameterValue: @(price),
//        kFIRParameterCurrency: currency
//    };
//    // Report revenue data
//    [FIRAnalytics logEventWithName:kFIREventAdImpression parameters:params];
}

@end
