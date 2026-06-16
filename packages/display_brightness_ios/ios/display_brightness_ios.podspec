#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint display_brightness_ios.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'display_brightness_ios'
  s.version          = '0.1.0'
  s.summary          = 'iOS implementation of the display_brightness plugin.'
  s.description      = <<-DESC
A Flutter FFI plugin for controlling app-level screen brightness on iOS
using swiftgen for direct native interop. No permissions required.
                       DESC
  s.homepage         = 'https://github.com/Mankeli-Software/display_brightness'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mankeli Solutions' => 'contact@mankelisolutions.fi' }

  s.source           = { :path => '.' }
  s.source_files     = 'display_brightness/Sources/display_brightness/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
