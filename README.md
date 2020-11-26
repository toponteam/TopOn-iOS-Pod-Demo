# TopOn-iOS-Pod-Demo SDK for iOS
[![CocoaPods Compatible](http://img.shields.io/badge/pod-v1.9.3-blue.svg)](https://github.com/toponteam/TopOn-iOS-Pod-Demo)
[![Platform](https://img.shields.io/badge/platform-iOS%209%2B-brightgreen.svg?style=flat)](https://github.com/toponteam/TopOn-iOS-Pod-Demo)
[![License](https://github.com/toponteam/TopOn-iOS-Pod-Demo/blob/master/LICENSE)](https://github.com/toponteam/TopOn-iOS-Pod-Demo/blob/master/LICENSE)


<!-- todo -->
Thanks for taking a look at AnyThinkiOS! We offers diversified and competitive monetization solution and supports a variety of Ad formats including Native Ad, Interstitial Ad, Banner Ad, and Rewarded Video Ad. The AnyThinkiOS platform works with multiple ad networks include AdMob, Facebook, UnityAds, Vungle, AdColony, AppLovin, Tapjoy, Chartboost, TikTok and Mintegral etc.

##Communication


### Installation with CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Swift and Objective-C Cocoa projects, which automates and simplifies the process of using 3rd-party libraries like the TopOn-iOS-SDK in your projects. You can install it with the following command:

```
$ gem install cocoapods
```

**Podfile**
To integrate AnyThinkiOS SDK into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'AnyThinkSDKDemo' do
      pod 'AnyThinkiOS','sdk_version'
end
```

#### Subspecs

By default, you get mediation core and all ad network adapters, if you only mediation some ad networks , you need to specify it. 

Podfile example:

```
pod 'AnyThinkiOS/AnyThinkFacebookAdapter'
pod 'AnyThinkiOS/AnyThinkAdmobAdapter'
pod 'AnyThinkiOS/AnyThinkTouTiaoAdapter'
pod 'AnyThinkiOS/AnyThinkMintegralAdapter'
```

Then, run the following command:

```bash
$ pod install
```

## Requirements

- iOS 9.0 and up
- Xcode 9.3 and up

## LICENSE

See the [LICENSE](LICENSE) file.
