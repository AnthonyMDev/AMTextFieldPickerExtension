Pod::Spec.new do |s|
  s.name = 'AMTextFieldPickerExtension'
  s.version = '0.5.1'
  s.license = 'MIT'
  s.summary = 'A `UITextField` extension written in Swift that makes it easy to use a `UIPickerView` for selection.'
  s.homepage = 'https://github.com/AnthonyMDev/AMTextFieldPickerExtension'
  s.social_media_url = 'http://twitter.com/AnthonyMDev'
  s.authors = { 'Anthony Miller' => 'AnthonyMDev@gmail.com' }
  s.source = { :git => 'https://github.com/AnthonyMDev/AMTextFieldPickerExtension.git', :tag => s.version }
  s.frameworks = 'Foundation', 'UIKit'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AMTextFieldPickerExtension/*.{swift}'

  s.requires_arc = true

end
