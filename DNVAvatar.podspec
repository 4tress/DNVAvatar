Pod::Spec.new do |s|

  s.name         = "DNVAvatar"
  s.version      = "0.3.1"
  s.summary      = "Round Avatar View for iOS apps."

  s.description  = <<-DESC
Lightweight and responsive iOS Swift component which represents a round avatar or multiple avatars in a circle.
DESC

  s.homepage     = "https://github.com/DnV1eX/DNVAvatar"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE.txt" }
  s.author       = { "Alexey Demin" => "dnv1ex@ya.ru" }

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/DnV1eX/DNVAvatar.git", :tag => "#{s.version}" }
  s.source_files = "DNVAvatar/DNVAvatarView.swift", "DNVAvatar/SwiftMD5.swift"
  s.requires_arc = true
  s.pod_target_xcconfig = { "SWIFT_VERSION" => "3.0" }

end
