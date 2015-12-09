Pod::Spec.new do |s|
  s.name             = "HiPayFullservice"
  s.version          = "0.1.0"
  s.summary          = "HiPay Fullservice SDK for iOS lets you accept payments in your iOS application."
  s.description      = <<-DESC
                       HiPay Fullservice is a new generation of payment platform optimized for todays’ e-tailers.

                       This SDK leverages the HiPay Fullservice platform to let you accept payments in your iOS application.

                       You can either take advantage of the turnkey payment screen or make a custom implement by using the core wrapper.

                       DESC

  s.homepage         = "https://github.com/hipay/hipay-fullservice-sdk-ios-dev"
  s.license          = "MIT"
  s.author           = { "Jonathan TIRET" => "jtiret@hipay.com" }
  s.source           = { :git => "https://github.com/hipay/hipay-fullservice-sdk-ios-dev.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/hipay"

  s.platform     = :ios, "7.0"
  s.requires_arc = true

  s.pod_target_xcconfig = {"TARGETED_DEVICE_FAMILY" => "1,2"}

  s.source_files     = "HiPayFullservice/*.{m,h}"

  s.default_subspecs = %w[Core Payment-Screen Device-Print]

  s.public_header_files = "HiPayFullservice/*.h"

  s.subspec "Core" do |s|
    s.source_files  = "HiPayFullservice/Core/**/*.{h,m}", "HiPayFullservice/Device Print/**/*.h"
    s.public_header_files = "HiPayFullservice/Core/**/*.h"
  end

  s.subspec "Utilities" do |s|
    s.source_files  = "HiPayFullservice/Utilities/**/*.{h,m}"
    s.public_header_files = "HiPayFullservice/Utilities/**/*.h"
    s.resource_bundles = {
      "HPFUtilitiesResources" => ["HiPayFullservice/Utilities/**/*.{plist}"],
    }
  end

  s.subspec "Device-Print" do |s|
    s.vendored_frameworks = "HiPayFullservice/Device Print/iovation.framework"
    s.frameworks = "CoreTelephony", "SystemConfiguration", "ExternalAccessory"
  end

  s.subspec "Payment-Screen" do |s|
    s.source_files  = "HiPayFullservice/Payment Screen/**/*.{h,m}"
    s.public_header_files = "HiPayFullservice/Payment Screen/**/*.h"
    s.resource_bundles = {
      "HPFPaymentScreenViews" => ["HiPayFullservice/Payment Screen/**/*.{xib,png,storyboard}"],
      "HPFPaymentScreenLocalization" => ["HiPayFullservice/Payment Screen/**/*.lproj"]
    }
    s.dependency "HiPayFullservice/Core"
    s.dependency "HiPayFullservice/Utilities"
    s.frameworks = "UIKit"
    s.weak_frameworks = "WebKit"
  end

end
