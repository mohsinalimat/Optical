Pod::Spec.new do |s|
  s.name             = 'Optical'
  s.version          = '1.0.0'
  s.summary          = 'Lightweight & Predictable state management framework for iOS'
  s.description      = 'Optical is a lightweight and predictable state management pattern framework for iOS'

  s.homepage         = 'https://github.com/Geektree0101/Optical'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Geektree0101' => 'h2s1880@gmail.com' }
  s.source           = { :git => 'https://github.com/Geektree0101/Optical.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Optical/Classes/**/*'
end
