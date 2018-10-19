Pod::Spec.new do |s|
  s.name         = "TeeSDK"
  s.version      = "0.5.5"
  s.summary      = "Russmedia Engagement Engine SDK for iOS"
  s.homepage     = "https://github.com/russmedia/Tee-ios-sdk"
  s.description  = <<-DESC
    Russmedia Engagement Engine SDK for iOS platform
  DESC
  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Russmedia Digital GmbH, all rights reserved.
      LICENSE
  }

  s.author       = {'Russmedia Digital GmbH' => 'michal.senk@russmedia.com'}
  s.source       = {:git => "https://github.com/russmedia/Tee-ios-sdk.git", :tag => s.version }
  s.platform     = :ios, '9.0'

  s.ios.vendored_frameworks = 'src/TeeSDK.framework'

end