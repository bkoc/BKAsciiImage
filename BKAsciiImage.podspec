#
# Be sure to run `pod lib lint BKAsciiImage.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BKAsciiImage"
  s.version          = "0.1.0"
  s.summary          = "Convert any UIImage to ascii art."
  s.homepage         = "https://github.com/bkoc/BKAsciiImage"
  # s.screenshots    = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Barış Koç" => "bariskoc@gmail.com" }
  s.source           = { :git => "https://github.com/bkoc/BKAsciiImage.git", :tag => s.version.to_s }
  s.platform     	 = :ios, '7.0'
  s.requires_arc 	 = true
  s.source_files 	 = 'BKAsciiImage/**/*'
end
