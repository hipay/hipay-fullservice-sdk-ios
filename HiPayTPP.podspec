#
# Be sure to run `pod lib lint HiPayTPP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "HiPayTPP"
  s.version          = "0.1.0"
  s.summary          = "A short description of HiPayTPP."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                       DESC

  s.homepage         = "https://github.com/<GITHUB_USERNAME>/HiPayTPP"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jonathan TIRET" => "jtiret@hipay.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/HiPayTPP.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

#  s.source_files = 'HiPayTPP/**/*'
#  s.resource_bundles = {
#    'HiPayTPP' => ['Pod/Assets/*.png']
#  }

  s.default_subspecs = %w[Core]

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.subspec "Core" do |s|
    s.source_files  = "HiPayTPP/Core/**/*.{h,m}"
  end

  s.subspec "Payment-Screen" do |s|
    s.source_files  = "HiPayTPP/Payment-Screen/**/*.{h,m}"
    s.dependency "HiPayTPP/Core"
  end

end
