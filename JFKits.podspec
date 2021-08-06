#
#  Be sure to run `pod spec lint JFKits.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "JFKits"
  spec.version      = "0.1.3.5"
  spec.summary      = "我的工具集"
  spec.homepage     = "https://github.com/fjlprivate/JFKits.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "fjlprivate" => "869325397@qq.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/fjlprivate/JFKits.git", :tag => "#{spec.version}" }
  spec.source_files =  'JFKit/**/*.{h,m}'

  spec.resource_bundles = {
   'FontAwesome' => ['JFKit/Component/FontAwesome/FontAwesome.otf']
  }


  spec.requires_arc = true

  spec.dependency "Masonry"
  spec.dependency "SDWebImage"
  spec.dependency "YYWebImage"
  spec.dependency "LTNavigationBar"
  spec.dependency "TZImagePickerController", "~> 3.2.1"


  spec.subspec 'UIKit' do |uikit|
    uikit.source_files = 'JFKit/UIKit/JFPresenter/*.{h,m}','JFKit/UIKit/JFSegmentView/*.{h,m}','JFKit/UIKit/JFAlertView/*.{h,m}','JFKit/UIKit/JFVideoKit/*.{h,m}','JFKit/UIKit/JFImageBrowser/*.{h,m}','JFKit/UIKit/JFBanner/*.{h,m}','JFKit/UIKit/JFCycleImageView/*.{h,m}','JFKit/UIKit/JFButton/*.{h,m}','JFKit/UIKit/JFAsyncDisplayKit/**/*.{h,m}','JFKit/UIKit/JFPhotoPicker/**/*.{h,m}','JFKit/UIKit/JFPageView/**/*.{h,m}'
  end

  spec.subspec 'Macro' do |macro|
    macro.source_files = 'JFKit/Macro/*.{h,m}'
  end

  spec.subspec 'Helper' do |helper| 
    helper.source_files = 'JFKit/Helper/*.{h,m}'
  end

  spec.subspec 'Component' do |component| 
    component.source_files = 'JFKit/Component/*.{h,m}'
  end

  spec.subspec 'Category' do |category| 
    category.source_files = 'JFKit/Category/*.{h,m}'
  end


end
