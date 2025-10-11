#
# Be sure to run `pod lib lint TopOnTest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LocalThirdPartySDK'
  s.version          = '1.0.0'
  s.summary          = 'LocalThirdPartySDK'
  s.description      = <<-DESC
  LocalThirdPartySDK,LocalThirdPartySDK.podspec,LocalThirdPartySDK.podspec
                       DESC
  s.homepage         = 'https://github.com/GPPG/topon_pod_test.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'GUO PENG' => 'ios' }
  s.source           = { :git => 'https://github.com/GPPG/topon_pod_test.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'
#  s.swift_version         = '5.0'
#  s.static_framework = true
  
  s.requires_arc = true

  s.frameworks = 'SystemConfiguration','CoreGraphics','Foundation','UIKit','AVFoundation','AdSupport','AudioToolbox','CoreMedia','StoreKit','WebKit','AppTrackingTransparency','CoreMotion','CoreTelephony','MessageUI','SafariServices','CoreLocation','MediaPlayer','JavaScriptCore','CoreAudio','CoreFoundation','QuartzCore','NetworkExtension','Accelerate','CoreImage','CoreText','ImageIO','MapKit','MobileCoreServices','Security','CoreHaptics','CoreML'
  
  s.pod_target_xcconfig =   {'OTHER_LDFLAGS' => ['-lObjC']}
  
  s.libraries = 'c++', 'z', 'sqlite3', 'xml2', 'resolv','bz2.1.0','bz2','resolv.9','iconv','c++abi'

  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 armv7s arm64' }
  
  s.subspec 'core' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'core/**/*.xcframework'
    ss.resource = 'core/*.bundle'
  end
  
  s.subspec 'admob' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.vendored_frameworks = 'admob/*.xcframework'
  end
  
  s.subspec 'applovin' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'applovin/*.xcframework'
  end
  
  s.subspec 'aqy' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'aqy/*.xcframework','aqy/*.framework'
    ss.resource = 'aqy/*.bundle'
  end
  
  s.subspec 'tanx' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'tanx/*.xcframework','tanx/TanxSDK/TanxSDK.library/*.framework'
  end
  
  
  s.subspec 'baidu' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'baidu/*.framework','baidu/*.xcframework'
    ss.resource = 'baidu/*.bundle'
  end
  
  s.subspec 'bidmachine' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'bidmachine/*.xcframework','bidmachine/**/**/**/*.xcframework','bidmachine/OMSDK_Appodeal/*.xcframework'
  end
  
  s.subspec 'bigo' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'bigo/*.xcframework'
    ss.resource = 'bigo/*.bundle'
  end
  
  s.subspec 'chartboost' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'chartboost/*.framework','chartboost/ChartboostMediationSDK.framework'
    ss.resource = 'chartboost/*.bundle'
    ss.source_files = 'chartboost/ChartboostMediationAdapterChartboost/**/*.{swift}'
  end
  
  s.subspec 'facebook' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'facebook/*.xcframework'
  end
  
  s.subspec 'fyber' do |ss|
    ss.ios.deployment_target = '11.0'
    ss.vendored_frameworks = 'fyber/*.xcframework'
  end
  
  s.subspec 'gdt' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'gdt/*.xcframework'
  end
  
  s.subspec 'inmobi' do |ss|
    ss.ios.deployment_target = '11.0'
    ss.vendored_frameworks = 'inmobi/*.xcframework'
  end

  s.subspec 'ironsource' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.vendored_frameworks = 'ironsource/*.xcframework'
  end

  
  s.subspec 'JADYun' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'jd/*.xcframework'
    ss.resource = 'jd/*.bundle'
  end
  
  s.subspec 'kidoz' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_library = 'kidoz/*.a'
    ss.vendored_frameworks = 'kidoz/*.xcframework'
    ss.source_files  = "kidoz/*.h"
  end
  
  s.subspec 'klevin' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'klevin/*.xcframework','klevin/*.framework'
  end
  
  s.subspec 'kuaishou' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'kuaishou/*.xcframework'
  end
  
  s.subspec 'Kwai' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'kwai/*.xcframework'
  end
  
  s.subspec 'maio' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'maio/*.framework','maio/*.xcframework'
  end
  
  s.subspec 'mintegral' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'mintegral/*.xcframework'
  end
  
  s.subspec 'ms' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'ms/*.xcframework','ms/MSAdMotion/*.xcframework','ms/MSMobAdSDK/*.xcframework'
    ss.resource = 'ms/MSMobAdSDK/*.bundle'
  end
  
  s.subspec 'mytarget' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'mytarget/*.xcframework'
  end
  
  s.subspec 'ogury' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'ogury/*.framework','ogury/*.xcframework'
  end
  
  s.subspec 'pangle' do |ss|
    ss.ios.deployment_target = '11.0'
    ss.vendored_frameworks = 'pangle/*.xcframework'
    ss.resource = 'pangle/*.bundle'
  end
  
  s.subspec 'pubnative' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'pubnative/*.xcframework'
  end
  
  s.subspec 'qm' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'qm/*.xcframework'
  end
  
  s.subspec 'sigmob' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'sigmob/*.xcframework'
  end

  s.subspec 'smaato' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'smaato/*.xcframework','smaato/**/*.xcframework'
  end

  s.subspec 'startapp' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'startapp/*.xcframework'
  end
  
  


  s.subspec 'tt' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'tt/*.xcframework'
    ss.resource = 'tt/*.bundle'
  end

  s.subspec 'tt_mix' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'tt_mix/BUAdSDK.xcframework','tt_mix/AnyThinkTTAdapter_Mix.xcframework'
    ss.resource = 'tt_mix/CSJAdSDK.bundle'
  end
  
  s.subspec 'gromore' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'gromore/CSJMediation.xcframework','tt_mix/BUAdSDK.xcframework','gromore/AnyThinkGromoreAdapter.xcframework'
    ss.resource = 'tt_mix/CSJAdSDK.bundle'
  end
  
  s.subspec 'unityads' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'unityads/*.xcframework'
  end
  
  s.subspec 'vungle' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'vungle/*.xcframework'
  end

 

  s.subspec 'pagcombine' do |ss|
    ss.ios.deployment_target = '12.0'
    ss.vendored_frameworks = 'pagcombine/*.framework'
    ss.resource = 'pagcombine/*.bundle'
  end

 
  s.subspec 'tapjoy' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'tapjoy/*.framework','tapjoy/*.xcframework'
  end
  

  
  s.subspec 'Yandex' do |ss|
    ss.ios.deployment_target = '13.0'
    ss.vendored_frameworks = 'yandex/*.xcframework'
  end
  
  s.subspec 'zy' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'zy/*.xcframework','zy/OctopusSDK/*.xcframework'
    ss.resource = 'zy/OctopusSDK/Assets/*.bundle'
  end
  
end
