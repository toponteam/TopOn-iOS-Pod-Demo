#
# Be sure to run `pod lib lint TopOnTest.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LocalThrirdPartySDK'
  s.version          = '1.0.0'
  s.summary          = '测试'
  s.description      = <<-DESC
  LocalThrirdPartySDK,LocalThrirdPartySDK.podspec,LocalThrirdPartySDK.podspec
                       DESC
  s.homepage         = 'https://github.com/GPPG/topon_pod_test.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'GUO PENG' => 'ios' }
  s.source           = { :git => 'https://github.com/GPPG/topon_pod_test.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'

 # s.static_framework = true
  
  s.requires_arc = true

  s.frameworks = 'SystemConfiguration', 'CoreGraphics','Foundation','UIKit','AVFoundation','AdSupport','AudioToolbox','CoreMedia','StoreKit','SystemConfiguration','WebKit','AppTrackingTransparency','CoreMotion','CoreTelephony','MessageUI','SafariServices','WebKit','CoreLocation','MediaPlayer','JavaScriptCore'
  
  s.pod_target_xcconfig =   {'OTHER_LDFLAGS' => ['-lObjC']}
  
  s.libraries = 'c++', 'z', 'sqlite3', 'xml2', 'resolv','bz2.1.0','bz2','xml2','resolv.9','iconv','c++abi'
  
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 armv7s arm64' }
  
  
  s.subspec 'adcolony' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'adcolony/AdColony.framework','adcolony/AnyThinkAdColonyAdapter.framework'
    
  end
  
  s.subspec 'admob' do |ss|
    ss.ios.deployment_target = '10.0'
    ss.vendored_frameworks = 'admob/GoogleAppMeasurement.framework','admob/GoogleMobileAds.framework','admob/GoogleUtilities.framework','admob/nanopb.framework','admob/PromisesObjC.framework','admob/UserMessagingPlatform.framework','admob/AnyThinkAdmobAdapter.framework'
  end
  
  s.subspec 'applovin' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'applovin/AppLovinSDK.framework','applovin/AnyThinkApplovinAdapter.framework'
    ss.resource = 'applovin/AppLovinSDKResources.bundle'
  end
  
  s.subspec 'baidu' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'baidu/BaiduMobAdSDK.framework','baidu/AnyThinkBaiduAdapter.framework'
    ss.resource = 'baidu/baidumobadsdk.bundle'
  end
  
  s.subspec 'chartboost' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'chartboost/Chartboost.framework','chartboost/HeliumAdapterChartboost.framework','chartboost/HeliumSdk.framework','chartboost/AnyThinkChartboostAdapter.framework'
  end
  
  s.subspec 'facebook' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'facebook/FBAudienceNetwork.framework','facebook/FBSDKCoreKit_Basics.framework','facebook/AnyThinkFacebookAdapter.framework'
  end
  
  s.subspec 'inmobi' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'inmobi/InMobiSDK.framework','inmobi/AnyThinkInmobiAdapter.framework'
  end

  s.subspec 'ironsource' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'ironsource/IronSource.framework', 'ironsource/AnyThinkIronSourceAdapter.framework'
  end
  
  s.subspec 'maio' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'maio/Maio.framework','maio/AnyThinkMaioAdapter.framework'
  end
  
  s.subspec 'mintegral' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'mintegral/MTGSDK.framework','mintegral/MTGSDKBanner.framework','mintegral/MTGSDKBidding.framework','mintegral/MTGSDKInterActive.framework','mintegral/MTGSDKInterstitial.framework','mintegral/MTGSDKInterstitialVideo.framework','mintegral/MTGSDKNativeAdvanced.framework','mintegral/MTGSDKReward.framework','mintegral/MTGSDKSplash.framework','mintegral/AnyThinkMintegralAdapter.framework'
  end
  

  s.subspec 'mopub' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'mopub/MoPubSDK.framework','mopub/OMSDK_Mopub.framework','mopub/AnyThinkMopubAdapter.framework'
  end
  
  s.subspec 'MyTarget' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'MyTarget/MyTargetSDK.framework','MyTarget/AnyThinkMyTargetAdapter.framework'
  end

  s.subspec 'nend' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'nend/NendAd.embeddedframework/NendAd.framework','nend/AnyThinkMyTargetAdapter.framework'
  end
  
  s.subspec 'ogury' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'ogury/OguryAds.framework','ogury/OguryChoiceManager.framework','ogury/OMSDK_Oguryco.framework','ogury/AnyThinkOguryAdapter.framework'
  end

  s.subspec 'pangle_China' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'pangle_China/BUCNAuxiliary.framework','pangle_China/AnyThinkTTAdapter.framework'
    end
  
  s.subspec 'pangle_noChina' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'pangle_nonChina/BUVAAuxiliary.framework','pangle_China/AnyThinkPnagleAdapter.framework'
  end
  
  s.subspec 'pangle_china_common' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'pangle_China/BUAdSDK.framework','pangle_China/BUFoundation.framework'
    ss.resource = 'pangle_China/BUAdSDK.bundle'
  end
  
  s.subspec 'pangle_oversea_common' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'pangle_noChina/BUAdSDK.framework','pangle_noChina/BUFoundation.framework'
    ss.resource = 'pangle_noChina/BUAdSDK.bundle'
  end
  
  
  s.subspec 'sigmob' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'sigmob/WindSDK.framework','sigmob/AnyThinkSigmobAdapter.framework'
    ss.resource = 'sigmob/Sigmob.bundle'
  end
  
  
  s.subspec 'startapp' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'startapp/StartApp.framework','startapp/AnyThinkStartAppAdapter.framework'
    ss.resource = 'startapp/StartApp.bundle'
  end
  
  s.subspec 'tapjoy' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'tapjoy/Tapjoy.framework','tapjoy/AnyThinkTapjoyAdapter.framework'
  end
  
  s.subspec 'unityads' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'unityads/UnityAds.framework','unityads/AnyThinkUnityAdsAdapter.framework'
  end
  
  s.subspec 'vungle' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'vungle/VungleSDK.framework','vungle/AnyThinkVungleAdapter.framework'
  end
  
    
  s.subspec 'fyber' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'fyber/IASDKCore/IASDKCore.framework','fyber/IASDKMRAID/IASDKMRAID.framework','fyber/IASDKVideo/IASDKVideo.framework','fyber/AnyThinkFyberAdapter.framework'
    
    ss.resource = 'startapp/IASDKResources.bundle'
    ss.source_files  = "fyber/IASDKCore/SwiftIntegration/*.h","fyber/IASDKMRAID/SwiftIntegration/*.h","fyber/IASDKVideo/SwiftIntegration/*.h"
  end
  
  s.subspec 'gdt' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'gdt/AnyThinkGDTAdapter.framework'
    ss.vendored_library = 'gdt/libGDTMobSDK.a'
    ss.source_files  = "gdt/*.h"
  end

  s.subspec 'kidoz' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'kidoz/AnyThinkKidozAdapter.framework'
    ss.vendored_library = 'kidoz/libKidozSDK.a'
    ss.source_files  = "kidoz/*.h"
  end


  s.subspec 'kuaishou' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks =
     'kuaishou/thirdRely/AFNetworking.framework','kuaishou/thirdRely/MJExtension.framework','kuaishou/thirdRely/SDWebImage.framework','kuaishou/KSAdSDK.framework','kuaishou/AnyThinkKuaiShouAdapter.framework'
 end
 
  s.subspec 'core' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'Core/AnyThinkBanner.framework','Core/AnyThinkInterstitial.framework','Core/AnyThinkNative.framework','Core/AnyThinkRewardedVideo.framework','Core/AnyThinkSDK.framework','Core/AnyThinkSplash.framework'
    ss.resource = 'Core/AnyThinkSDK.bundle'
  end

  s.subspec 'klevin' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'klevin/KlevinAdSDK.framework','klevin/AnyThinkKlevinAdapter.framework'
 end
 
  s.subspec 'mobrain' do |ss|
    ss.ios.deployment_target = '9.0'
    ss.vendored_frameworks = 'mobrain/ABUAdAdmobAdapter.framework','mobrain/ABUAdBaiduAdapter.framework','mobrain/ABUAdGdtAdapter.framework','mobrain/ABUAdSDK.framework','mobrain/ABUAdSDKAdapter.framework','mobrain/ABUAdSigmobAdapter.framework','mobrain/ABUAdUnityAdapter.framework','mobrain/AnyThinkMobrainAdapter.framework','mobrain/OfmMobrainAdapter.framework','mobrain/OfmSDK.framework','mobrain/OfmTopOnAdapter.framework'
 end
end
