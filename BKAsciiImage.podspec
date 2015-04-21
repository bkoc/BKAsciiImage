Pod::Spec.new do |s|
  s.name             = "BKAsciiImage"
  s.version          = "0.1.1"
  s.summary          = "Convert any UIImage to ascii art."
  s.homepage         = "https://github.com/bkoc/BKAsciiImage"
  s.license          = 'MIT'
  s.author           = { "Barış Koç" => "bariskoc@gmail.com" }
  s.source           = { :git => "https://github.com/bkoc/BKAsciiImage.git", :tag => s.version.to_s }
  s.platform     	 = :ios, '7.0'
  s.requires_arc 	 = true
  s.source_files 	 = 'BKAsciiImage/**/*'
end
