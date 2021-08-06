#
#  Be sure to run `pod spec lint JFKits.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "JFKits"
  s.version      = "0.1.3.10"
  s.summary      = "我的工具集"
  s.homepage     = "https://github.com/fjlprivate/JFKits.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "fjlprivate" => "869325397@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/fjlprivate/JFKits.git", :tag => "#{s.version}" }
  s.source_files =  'JFKit/JFKit.h'
  s.public_header_files = 'JFKit/JFKit.h'

  s.resource_bundles = {
   'FontAwesome' => ['JFKit/Component/FontAwesome/FontAwesome.otf']
  }


  s.requires_arc = true

  s.default_subspecs = 'Macro','Helper','Category','Component','UIKit'

  s.subspec 'Macro' do |ss|
    ss.source_files = 'JFKit/Macro/*.h'
    ss.public_header_files = 'JFKit/Macro/*.h'
  end

  s.subspec 'Helper' do |ss| 
    ss.source_files = 'JFKit/Helper/*.{h,m}'
    ss.public_header_files = 'JFKit/Helper/**/*.h'

    ss.dependency 'JFKits/Macro'
    ss.dependency 'JFKits/Category'
    ss.dependency 'SDWebImage'
  end


  s.subspec 'Category' do |ss| 
    ss.source_files = 'JFKit/Category/*.{h,m}'
    ss.public_header_files = 'JFKit/Category/**/*.h'

    ss.dependency 'JFKits/Helper'
    ss.dependency 'JFKits/Macro'
    ss.dependency 'JFKits/UIKit'
  end

  s.subspec 'Component' do |ss| 
    ss.source_files = 'JFKit/Component/FontAwesome/*.{h,m}','JFKit/Component/JFAsyncFlag/*.{h,m}','JFKit/Component/JFImageDownloader/*.{h,m}','JFKit/Component/ShortMediaCache/*.{h,m}'
    ss.public_header_files = 'JFKit/Component/**/*.h'

    ss.dependency 'JFKits/Category'
  end

  s.subspec 'UIKit' do |ss|
    ss.source_files = 'JFKit/UIKit/JFPresenter/*.{h,m}','JFKit/UIKit/JFSegmentView/*.{h,m}','JFKit/UIKit/JFAlertView/*.{h,m}','JFKit/UIKit/JFVideoKit/*.{h,m}','JFKit/UIKit/JFImageBrowser/*.{h,m}','JFKit/UIKit/JFBanner/*.{h,m}','JFKit/UIKit/JFCycleImageView/*.{h,m}','JFKit/UIKit/JFButton/*.{h,m}','JFKit/UIKit/JFAsyncDisplayKit/**/*.{h,m}','JFKit/UIKit/JFPhotoPicker/**/*.{h,m}','JFKit/UIKit/JFPageView/**/*.{h,m}'
    ss.public_header_files = 'JFKit/UIKit/**/*.h'

    ss.dependency 'JFKits/Component'
    ss.dependency 'JFKits/Helper'
    ss.dependency 'JFKits/Category'
    ss.dependency 'JFKits/Macro'

    ss.dependency "Masonry"
    ss.dependency "SDWebImage"
    ss.dependency "YYWebImage"
    ss.dependency "LTNavigationBar"
    ss.dependency "TZImagePickerController", "~> 3.2.1"

  end

end
