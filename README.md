# iOS_Demo

Demo使用说明：
如您需要使用自己的配置，请调整一下内容：

1.podfile 调整更换Adapter适配器，调整为您自己需要的之后，重新执行pod install --repo-update

2.AdSDKManager.h 更换Appkey Appid

3.具体广告类型示例代码.m文件中，修改广告位ID

4.v6.4.93及其以前版本迁移至v6.5.xx,请查看迁移指南：https://help.toponad.net/cn/docs/iOS-v6-5-xx-SDK-qian-yi-zhi-nan
升级到iOS v6.5.xx 后，如果有自定义广告平台，必须按照以下文档完成新版本的适配，否则将无法请求自定义广告平台的广告。
- [自定义基础适配器](https://help.toponad.net/cn/docs/XZLXDakO)
- [自定义横幅广告适配器](https://help.toponad.net/cn/docs/biL6VSwk)
- [自定义插屏广告适配器](https://help.toponad.net/cn/docs/YPezC53M)
- [自定义激励视频广告适配器](https://help.toponad.net/cn/docs/QV9tdP5F)
- [自定义开屏广告适配器](https://help.toponad.net/cn/docs/f4ons3KV)
- [自定义原生广告适配器](https://help.toponad.net/cn/docs/zwDGAQ7R)
- [自定义客户端竞价（C2S）广告](https://help.toponad.net/cn/docs/Kdm8wryZ)
 
======================================================================

Demo Usage Instructions:
If you need to use your own configurations, please modify the following:

1.Podfile Adjustment

Replace the Adapter dependencies with those required for your own setup.

After modification, run:
pod install --repo-update
 
2.AdSDKManager.h

Replace the AppKey and AppId with your own credentials.

3.Ad Example Code (.m Files)

Modify the ad placement IDs in the sample ad implementation files.

4.For migration from v6.4.93 and earlier versions to v6.5.xx, please refer to the migration guide: https://help.toponad.net/docs/iOS-v6-5-xx-Migration-Guide
After upgrading to iOS v6.5.xx, if you have a custom ad platform, you must complete the adaptation for the new version according to the following documents. Otherwise, ads from the custom ad platform will not be available.  
- [Custom Base Adapter](https://help.toponad.net/docs/Custom-Base-Adapter)
- [Custom Banner Ad Adapter](https://help.toponad.net/docs/Custom-Banner-Ad-Adapter)
- [Custom Interstitial Ad Adapter](https://help.toponad.net/docs/Custom-Interstitial-Ad-Adapter)
- [Custom Rewarded Video Ad Adapter](https://help.toponad.net/docs/Custom-Rewarded-Video-Ad-Adapter)
- [Custom Splash Ad Adapter](https://help.toponad.net/docs/Custom-Splash-Ad-Adapter)
- [Custom Native Ad Adapter](https://help.toponad.net/docs/Custom-Native-Ad-Adapter)
- [Custom C2S Bidding Ads](https://help.toponad.net/docs/Custom-C2S-Bidding-Ads)

======================================================================

## Integration Instructions

https://help.toponad.net/docs/UC0qle
