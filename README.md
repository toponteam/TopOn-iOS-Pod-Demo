# TopOn-iOS-Pod-Demo SDK for iOS
[![CocoaPods Compatible](http://img.shields.io/badge/pod-v1.9.3-blue.svg)](https://github.com/toponteam/TopOn-iOS-Pod-Demo)
[![Platform](https://img.shields.io/badge/platform-iOS%209%2B-brightgreen.svg?style=flat)](https://github.com/toponteam/TopOn-iOS-Pod-Demo)

TopOn is an ad mediation platform that helps global app developers manage ad networks conveniently and maximize revenue lightly. Especially in China, TopOn becomes the Top #1 mediation platform. Until now, We have cooperated with around 400 companies. We have supported rich local advertising platform resources and lots of global ad platforms. 


## Communication
Official website ： https://www.toponad.com/

Business Cooperation : business@toponad.com

Market Cooperation : leon@toponad.com

Technical Support : support@toponad.com

QQ & wechat 188108875(Harry)

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

## Integration instructions

https://docs.toponad.com/#/en-us/ios/ios_doc/ios_sdk_config_access

## LICENSE

See the [LICENSE](LICENSE) file.
