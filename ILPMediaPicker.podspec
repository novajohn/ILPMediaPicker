Pod::Spec.new do |s|
  s.name                = "ILPMediaPicker"
  s.version             = "0.0.2"
  s.summary             = "A simple but efficient picker to select or create media items for iOS apps."
  s.description         = <<-DESC
                            ILPMediaPicker provides a simple way to select multiple images/video or create new ones using camera.
                            It allows to define a prefered size for assets thumbnail.
                          DESC
  s.homepage            = "https://github.com/novajohn/ILPMediaPicker"
  # s.screenshots       = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license             = "MIT"
  s.author              = { "Evgeniy Novikov" => "neovajohn@gmail.com" }
  s.platform            = :ios, "7.0"
  s.source              = { :git => "https://github.com/novajohn/ILPMediaPicker.git", :tag => "v#{s.version}" }
  s.source_files        = "ILPMediaPicker/**/*.{h,m}"
  s.public_header_files = "ILPMediaPicker/**/*.h"
  # s.resource          = "ILPMediaPicker/Resources/ILPMediaPicker.bundle"
  s.resources           = ["ILPMediaPicker/**/*.xib", "ILPMediaPicker/Resources/ILPMediaPicker.bundle"];
  s.framework           = "UIKit"
  s.requires_arc        = true
end
