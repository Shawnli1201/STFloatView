Pod::Spec.new do |spec|

  spec.name         = "STFloatView"
  spec.version      = "1.0.0"
  spec.summary      = "A category file of UIViewController."
  spec.description  = <<-DESC
			A easy way to add a floatView to your ViewController.
                      DESC
  spec.homepage     = "https://github.com/Shawnli1201"
  spec.license      = "MIT"
  spec.author             = { "Shawnli1201" => "shawnli1201@gmail.com" }
  spec.platform     = :ios,"8.0"
  spec.source       = { :git => "https://github.com/Shawnli1201/STFloatView.git", :tag => "#{spec.version}" }
  spec.source_files  = "STFloatView/**/*.{h,m}"
  spec.requires_arc  = true

end
