Pod::Spec.new do |s|
  s.name         = "TeeSDK"
  s.version      = "0.5.0"
  s.summary      = "Russmedia Engagement Engine SDK for iOS"
  s.description  = <<-DESC
  DESC

  s.homepage     = "https://github.com/russmedia/Tee-ios-sdk"

  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Russmedia Digital GmbH all rights reserved
      LICENSE
  }

  s.author       = {'Russmedia Digital GmbH' => 'michal.senk@russmedia.com'}
  s.source       = {:git => "https://github.com/russmedia/Tee-ios-sdk.git", :tag => s.version }
  s.platform     = :ios, '9.0'

  s.source_files = '*.{h}'
  s.ios.vendored_frameworks = 'src/TeeSDK.framework'

end