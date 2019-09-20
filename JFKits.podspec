#
#  Be sure to run `pod spec lint JFKits.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "JFKits"
  spec.version      = "0.0.1"
  spec.summary      = "我的工具集"
  spec.homepage     = "https://github.com/fjlprivate/JFKits.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "fjlprivate" => "869325397@qq.com" }
  spec.platform     = :ios, "8.0"
  spec.source       = { :git => "https://github.com/fjlprivate/JFKits.git", :tag => "#{spec.version}" }
  spec.source_files = "JFKit/**"
  spec.requires_arc = true

  spec.dependency "Masonry"
  spec.dependency "SDWebImage"
  spec.dependency "YYWebImage"
  spec.dependency "LTNavigationBar"
  spec.dependency "TZImagePickerController", "~> 3.2.1"

end
