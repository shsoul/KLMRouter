Pod::Spec.new do |s|

  s.name         = "KLMRouter"
  s.version      = "1.0.0"
  s.summary      = "A iOS router that help app navigate to controllers."
  s.homepage     = "https://github.com/shsoul/KLMRouter"
  s.license      = "MIT"
  s.author       = { "shsoul" => "shuijie_zhang@163.com" }
  s.source       = { :git => "https://github.com/shsoul/KLMRouter.git", :tag => s.version.to_s }
  s.source_files  = 'KLMRouter/*.{h,m}'
  s.ios.deployment_target = '5.0'

end
