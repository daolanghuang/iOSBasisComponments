#
#  Be sure to run `pod spec lint iOSBasisComponents.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name = 'iOSBasisComponents'
    s.version = '0.1.2'
    s.license = 'MIT'
    s.summary = 'iOSBasisComponents in Swift'
    s.homepage = 'http://source.enncloud.cn/smc_ios/Fastlane_Actions'
    s.authors = { 'Enn Software Foundation' => 'huangdaolang@ennew.cn' }
    s.source = { :git => 'https://source.enncloud.cn/smc_ios/iOSBasisComponents.git', :tag => s.version }

    s.ios.deployment_target = '9.0'

    s.default_subspec = 'Core'


#s.source_files = 'Source/**/*.swift'
#s.resource_bundles = {
#'iOSBasisComponents' => ['Source/**/*.png','Source/**/*.plist']
#}
#s.dependency  'SDWebImage'
#s.dependency  'Alamofire'
#s.dependency  'SwiftyJSON'
#s.dependency  'SQLite.swift'
#s.dependency  'SnapKit'

    s.subspec 'Core' do |core|
        core.source_files = 'Source/Core/**/*.swift'
        core.resource_bundles = {
            'Core' => ['Source/Core/**/*.png']
       }
        core.dependency  'SDWebImage'
        core.dependency  'Alamofire'
        core.dependency  'SwiftyJSON'
        core.dependency  'SQLite.swift'
        core.dependency  'SnapKit'
   end

   s.subspec 'LK' do |lk|
        lk.source_files = 'Source/LK/*.swift'
        lk.dependency 'iOSBasisComponents/Core'
        lk.resource_bundles = {
            'LK' => ['Source/LK/*.plist']
        }
    end


end
