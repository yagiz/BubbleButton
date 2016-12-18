Pod::Spec.new do |s|
  s.name             = 'BubbleButton'
  s.version          = '0.1.1'
  s.summary          = 'BubbleButton is a Swift 3 UIButton subclass which produces fancy bubbles when it's tapped.'
 
  s.description      = <<-DESC
In Interface Builder you can set BubbleButton to Custom Class property of your button. Just do not forget the module field. Then you can customize its properties.
                       DESC
 
  s.homepage         = 'https://github.com/yagiz/BubbleButton'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yagiz' => 'yagizgurgul@gmail.com' }
  s.source           = { :git => 'https://github.com/yagiz/BubbleButton.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'BubbleButton/BubbleButton.swift'
 
end