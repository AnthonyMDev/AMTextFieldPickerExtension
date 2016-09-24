source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

use_frameworks!
inhibit_all_warnings!

target :AMTextFieldPickerExtension do

end

target :AMTextFieldPickerExtensionTests do
  pod "Nimble", '~> 4.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
    end
  end
end
