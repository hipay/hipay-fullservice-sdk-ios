Pod::Spec.new do |s|
  s.name             = "HiPayFullservice"
  s.version          = "2.3.0"
  s.summary          = "HiPay SDK for iOS lets you accept payments in your iOS application."
  s.description      = <<-DESC
                       HiPay is a new generation of payment platform optimized for todays’ e-tailers.

                       This SDK leverages the HiPay platform to let you accept payments in your iOS application.

                       You can either take advantage of the turnkey payment screen or make a custom implement by using the core wrapper.

                       DESC

  s.homepage         = "https://developer.hipay.com"
  s.license          = "Apache-2.0"
  s.author           = { "HiPay" => "pi-ecommerce@hipay.com"}
  s.source           = { :git => "https://github.com/hipay/hipay-fullservice-sdk-ios.git", :tag => s.version.to_s }
  s.homepage         = "https://developer.hipay.com/mobile-payments/ios/ios-fundamentals"

  s.platform     = :ios, "14.0"
  s.requires_arc = true

  s.swift_version = '6.0'
  
  s.pod_target_xcconfig = {
      "TARGETED_DEVICE_FAMILY" => "1,2",
      "SWIFT_STRICT_CONCURRENCY" => "complete"
    }
  
  s.source_files     = "HiPayFullservice/*.{m,h,swift}"
  
  s.default_subspec = 'Core', 'Payment-Screen'

  s.public_header_files = "HiPayFullservice/*.h"

  s.subspec "Core" do |s|
    s.source_files  = "HiPayFullservice/Core/**/*.{h,m}", "HiPayFullservice/Device Print/**/*.h", "HiPayFullservice/Utilities/**/*.{h,m}"
    s.public_header_files = "HiPayFullservice/Core/**/*.h", "HiPayFullservice/Utilities/**/*.h"
    s.resource_bundles = {
      "HPFCoreLocalization" => ["HiPayFullservice/Core/**/*.lproj"]
    }
    s.libraries = 'c++'
  end

  s.subspec "Utilities" do |s|
    s.source_files  = "HiPayFullservice/Utilities/**/*.{h,m}"
    s.public_header_files = "HiPayFullservice/Utilities/**/*.h"
    s.resource_bundles = {
      "HPFUtilitiesResources" => ["HiPayFullservice/Utilities/**/*.{plist}"],
    }
    s.dependency "HiPayFullservice/Core"
  end

  s.subspec "Device-Print" do |s|
      s.vendored_frameworks = "HiPayFullservice/Device Print/iovation.framework"
    s.frameworks = "UIKit", "CoreTelephony", "SystemConfiguration", "ExternalAccessory"
    s.user_target_xcconfig = { "OTHER_LDFLAGS" => "-ld_classic" }
  end

  s.subspec "Payment-Screen" do |s|
    s.source_files  = ['HiPayFullservice/Payment Screen/**/*.{h,m,swift}', 'HiPayFullservice/HiPayFullservice.h']
    s.public_header_files = "HiPayFullservice/Payment Screen/**/*.h", "HiPayFullservice/HiPayFullservice.h"
    s.resource_bundles = {
      "HPFPaymentScreenViews" => ["HiPayFullservice/Payment Screen/**/*.{xib,png,storyboard}"],
      "HPFPaymentScreenLocalization" => ["HiPayFullservice/Payment Screen/**/*.lproj"]
    }

    s.dependency "HiPayFullservice/Core"
    s.dependency "HiPayFullservice/Utilities"
    s.weak_frameworks = "WebKit"
    s.frameworks       = 'UIKit', 'Accelerate', 'AudioToolbox', 'AVFoundation', 'CoreLocation', 'CoreMedia', 'MessageUI', 'CoreServices', 'SystemConfiguration'
    s.compiler_flags   = '-fmodules'
    s.xcconfig         = { 'OTHER_LDFLAGS' => '-lc++ -ObjC'}
  end
end
