#
# Be sure to run `pod lib lint McPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'McPicker'
  s.version          = '0.1.0'
  s.summary          = 'McPicker is a UIPickerView replacement with animations and rotation ready.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
McPicker is a UIPickerView replacement with animations and rotation ready. The more string arrays you pass the more picker components you'll get. You can set custom label or use the default.
DESC

  s.homepage         = 'https://github.com/kmcgill88/McPicker-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kevin McGill' => 'kevin@mcgilldevtech.com' }
  s.source           = { :git => 'https://github.com/kmcgill88/McPicker-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'McPicker/Classes/**/*'
  
  # s.resource_bundles = {
  #   'McPicker' => ['McPicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
