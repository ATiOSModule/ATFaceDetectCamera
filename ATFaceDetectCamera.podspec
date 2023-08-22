#
#  Be sure to run `pod spec lint EkycFramework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|  
  s.name              = 'ATFaceDetectCamera' # Name for your pod
  s.version           = '0.0.3'
  s.summary           = 'An extension collection  of ios swift'
  s.homepage          = "https://github.com/ATiOSModule/ATFaceDetectCamera"

  s.author            = { "Nguyen Anh Tuan" => "nguyenanhtuan25122001@gmail.com" }
  s.license           = "MIT"

  s.platform          = :ios

  # Resource
  s.source            = { :git => "https://github.com/ATiOSModule/ATFaceDetectCamera.git", :tag => '0.0.3'}
  s.source_files  = "ATFaceDetectCamera", "ATFaceDetectCamera/ATFaceDetectCamera/**/*.{h,m,mm,swift}"
  s.exclude_files = "ATFaceDetectCamera/Exclude/**"

  # Dependencies
  s.dependency 'ATBaseExtensions', '~> 0.0.2'

  # Deployment
  s.ios.deployment_target = '13.0'

end 
