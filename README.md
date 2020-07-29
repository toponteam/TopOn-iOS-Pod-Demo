## [IMPORTANT] DO NOT expose any of the frameworks to Windows operating system; Windows modifies frameworks, making them incomplete and resulting in compile errors.
## 【重要】请勿将iOS需要用到的SDK（包括.a、.framework及.embededframework格式的套件）下载或传送至Windows操作系统上，因为Windows文件系统会修改这些SDK，导致它们在Xcode中无法编译。
# AnythinkSDK_iOS_SDK_5.5.9
## Third-party SDK version for AnyThink_ios_sdk_5.5.9

<a href="https://docs.toponad.com/#/en-us/ios/ios_doc/ios_access_doc" target = "_blank"> Integrate Guide for AnyThinkSDK for iOS(English) </a> 

<a href="https://docs.toponad.com/#/en-us/ios/ios_doc/ios_errorcode" target = "_blank"> Error Code And FAQ(English) </a> 

<a href="https://docs.toponad.com/#/zh-cn/ios/ios_doc/ios_access_doc" target = "_blank"> AnyThinkSDK for iOS 中文集成文档 </a> 

<a href="https://docs.toponad.com/#/zh-cn/ios/ios_doc/ios_errorcode" target = "_blank"> Error Code And FAQ 中文版 </a> 

<br>
(建议从这里的链接下载,git的download zip会出现文件损坏的问题，导致无法编译)下载地址（download）：<br>

<a href="https://docs.toponad.com/#/zh-cn/ios/download/package" target="_blank">TopOn iOS SDK(中文）</a>

<a href="https://docs.toponad.com/#/en-us/ios/download/package" target="_blank">TopOn iOS SDK(English）</a>

## How To Get Stared
+ Run the following command:<br>
```
$ pod install
```
+ 请先运行pod install才能保证demo正常运行。
+ 可根据接入的广告平台自行修改Podfile

```
#AnyThinkiOS
pod 'AnyThinkiOS','5.5.9'

#FaceBook
pod 'AnyThinkiOS/AnyThinkFacebookAdapter','5.5.9'
pod 'FBAudienceNetwork' , '5.10.1'

#Admob
pod 'AnyThinkiOS/AnyThinkAdmobAdapter','5.5.9'
pod 'Google-Mobile-Ads-SDK','7.60.0'
pod 'PersonalizedAdConsent'

#TouTiao
pod 'AnyThinkiOS/AnyThinkTouTiaoAdapter','5.5.9'
#  pod 'Bytedance-UnionAD' , '3.1.0.0'

#Applovin
pod 'AnyThinkiOS/AnyThinkApplovinAdapter','5.5.9'
pod 'AppLovinSDK', '6.12.6'

#Mintegral
pod 'AnyThinkiOS/AnyThinkMintegralAdapter','5.5.9'
pod 'MintegralAdSDK' ,'6.3.2'
pod 'MintegralAdSDK/RewardVideoAd','6.3.2'
pod 'MintegralAdSDK/BidRewardVideoAd','6.3.2'
pod 'MintegralAdSDK/BidInterstitialVideoAd','6.3.2'
pod 'MintegralAdSDK/InterstitialVideoAd','6.3.2'
pod 'MintegralAdSDK/InterstitialAd','6.3.2'
pod 'MintegralAdSDK/BannerAd' ,'6.3.2'
pod 'MintegralAdSDK/BidBannerAd','6.3.2'
pod 'MintegralAdSDK/SplashAd','6.3.2'
pod 'MintegralAdSDK/NativeAdvancedAd','6.3.2'

#GDT
pod 'AnyThinkiOS/AnyThinkGDTAdapter','5.5.9'
pod 'GDTMobSDK', '4.11.8'

#Unity Ads
pod 'AnyThinkiOS/AnyThinkUnityAdsAdapter','5.5.9'
pod 'UnityAds' , '3.4.2'

#Chartboost
pod 'AnyThinkiOS/AnyThinkChartboostAdapter','5.5.9'
pod 'ChartboostSDK','8.1.0'

#Tapjoy
pod 'AnyThinkiOS/AnyThinkTapjoyAdapter','5.5.9'
pod 'TapjoySDK','12.4.2'

#Nend
pod 'AnyThinkiOS/AnyThinkNendAdapter','5.5.9'
pod 'NendSDK_iOS','5.3.1'

#IronSource
pod 'AnyThinkiOS/AnyThinkIronSourceAdapter','5.5.9'
pod 'IronSourceSDK','6.16.1'

#Inmobi
pod 'AnyThinkiOS/AnyThinkInmobiAdapter','5.5.9'
pod 'InMobiSDK' ,'9.0.7'

#Appnext
pod 'AnyThinkiOS/AnyThinkAppnextAdapter','5.5.9'
#第三方不支持pod,请另行下载

#Adcolony
pod 'AnyThinkiOS/AnyThinkAdcolonyAdapter','5.5.9'
pod 'AdColony','4.1.4.0'

#Vungle
pod 'AnyThinkiOS/AnyThinkVungleAdapter','5.5.9'
#  pod 'VungleSDK-iOS', '6.5.4'

#Maio
pod 'AnyThinkiOS/AnyThinkMaioAdapter','5.5.9'
pod 'MaioSDK','1.5.0'

#KuaiShou
pod 'AnyThinkiOS/AnyThinkKSAdapter','5.5.9'
pod 'KSAdSDK', '2.7.0'
pod 'SDWebImage'

#Baidu
pod 'AnyThinkiOS/AnyThinkBaiduAdapter','5.5.9'
#第三方不支持pod,请另行下载

#Ogury
pod 'AnyThinkiOS/AnyThinkOguryAdapter','5.5.9'
#第三方不支持pod,请另行下载

#Oneway
pod 'AnyThinkiOS/AnyThinkOnewayAdapter','5.5.9'
#第三方不支持pod,请另行下载

#Sigmob
pod 'AnyThinkiOS/AnyThinkSigmobAdapter','5.5.9'
pod 'SigmobAd-iOS', '2.18.0'

#StartApp
pod 'AnyThinkiOS/AnyThinkStartAppAdapter','5.5.9'
pod 'StartAppSDK', '4.5.0'

#Fyber
pod 'AnyThinkiOS/AnyThinkFyberAdapter','5.5.9'
pod 'Fyber_Marketplace_SDK', '7.5.4'

```

## AnyThink Network_name、 Network_Version and Network_firm_id mapping

| Network | SDK Version | Network firm ID| note |
|---|---|---|---|
| Facebook | 5.10.1 |1|FBAudienceNetwork.framework版本为5.9.0<br>FBSDKCoewKit.framework版本为6.0.0|
| Admob | 7.60.0 |2||
| Inmobi | 9.0.7 |3||
| Applovin | 6.12.6 |5||
| Mintegral | 6.2.0 |6||
| GDT | 4.11.8 |8|广点通/Tencent/腾讯广告|
| Appnext | 1.9.3 |21||
| Chartboost | 8.1.0 |9||
| Ironsource | 6.16.1 |11||
| Vungle | 6.5.4 |13||
| Adcolony | 4.1.4.0 |14||
| UnityAds | 3.4.2 |12||
| TiTok | 3.1.0.0 |15|头条/穿山甲/TiTok|
| Tapjoy | 12.4.2 |10||
| Oneway | 2.3.0 |17||
| Baidu | 4.69 |22||
| Nend | 5.3.1 |23||
| Maio | 1.5.0 |24||
| startApp | 4.5.0 |25||
| KuaiShou | 2.7.0 |28|需要额外导入第三方依赖：<br> AFNetworking/Godzippa/MJExtension/SDWebImage|
| sigmob | 2.18.0 |29|sdk：WindSDK.framework <br>sigmob.bundle|
| Ogury | 1.0.10 |36|OguryOED_1.0.10 包含以下sdk<br>OMSDK_Oguryco.framework<br>OguryAds.framework<br>OguryConsentManager.framework|
| Fyber | 7.5.4 |37||
