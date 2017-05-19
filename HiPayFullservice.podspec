Pod::Spec.new do |s|
  s.name             = "HiPayFullservice"
  s.version          = "1.4.2"
  s.summary          = "HiPay Fullservice SDK for iOS lets you accept payments in your iOS application."
  s.description      = <<-DESC
                       HiPay Fullservice is a new generation of payment platform optimized for todays’ e-tailers.

                       This SDK leverages the HiPay Fullservice platform to let you accept payments in your iOS application.

                       You can either take advantage of the turnkey payment screen or make a custom implement by using the core wrapper.

                       DESC

  s.homepage         = "https://developer.hipay.com"
  s.license          = "Apache-2.0"
  s.author           = { "Jonathan TIRET" => "jtiret@hipay.com", "Nicolas FILLION" => "nfillion21@gmail.com" }
  s.source           = { :git => "https://github.com/hipay/hipay-fullservice-sdk-ios.git", :tag => s.version.to_s }
  s.homepage         = "https://developer.hipay.com/doc/hipay-fullservice-sdk-ios/"

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.pod_target_xcconfig = {"TARGETED_DEVICE_FAMILY" => "1,2"}

  s.source_files     = "HiPayFullservice/*.{m,h}"

  s.default_subspec = 'Core', 'Payment-Screen'#,'Device-Print', 'CardIO'

  s.public_header_files = "HiPayFullservice/*.h"

  s.subspec "Core" do |s|
    s.source_files  = "HiPayFullservice/Core/**/*.{h,m}", "HiPayFullservice/Device Print/**/*.h", "HiPayFullservice/Utilities/**/*.{h,m}" 
    s.public_header_files = "HiPayFullservice/Core/**/*.h", "HiPayFullservice/Utilities/**/*.h"
    s.resource_bundles = {
      "HPFCoreLocalization" => ["HiPayFullservice/Core/**/*.lproj"]
    }
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
    s.frameworks = "CoreTelephony", "SystemConfiguration", "ExternalAccessory"
  end

  s.subspec "Payment-Screen" do |s|
    s.source_files  = ['HiPayFullservice/Payment Screen/**/*.{h,m}']
    s.public_header_files = "HiPayFullservice/Payment Screen/**/*.h"
    s.resource_bundles = {
      "HPFPaymentScreenViews" => ["HiPayFullservice/Payment Screen/**/*.{xib,png,storyboard}"],
      "HPFPaymentScreenLocalization" => ["HiPayFullservice/Payment Screen/**/*.lproj"]
    }

    s.dependency "HiPayFullservice/Core"
    s.dependency "HiPayFullservice/Utilities"
    s.weak_frameworks = "WebKit"
    s.frameworks       = 'UIKit', 'Accelerate', 'AudioToolbox', 'AVFoundation', 'CoreLocation', 'CoreMedia', 'MessageUI', 'MobileCoreServices', 'SystemConfiguration'
    s.vendored_libraries = ['HiPayFullservice/Payment Screen/CardIO/*.a']
    s.compiler_flags   = '-fmodules'#,  '-fmodules-autolink'
    s.xcconfig         = { 'OTHER_LDFLAGS' => '-lc++ -ObjC'}
    
  end
  
  s.subspec 'CardIO' do |s|
      s.dependency       'CardIO', '~> 5.4.1'
      
  end

end
