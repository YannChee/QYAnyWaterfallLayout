Pod::Spec.new do |s|
  s.name         = "QYAnyWaterfallLayout"
  s.version      = "0.1.0"
  s.summary      = "A short description of QYAnyWaterfallLayout."

  s.description  = <<-DESC
                    QYAnyWaterfallLayout 继承自UICollectionViewLayout ,而不是UICollectionViewFlowLayout,相对更加轻量级;布局的方法完全
                    自定义实现使用起来更加灵活
                   DESC

  s.homepage     = "http://EXAMPLE/QYAnyWaterfallLayout"
  s.license      = "MIT"
  s.author             = { "YannChee" => "yannchee@163.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "http://EXAMPLE/QYAnyWaterfallLayout.git", :tag => "#{s.version}" }

  s.source_files  = "QYAnyWaterfallLayout/**/*"

  s.requires_arc = true

end
