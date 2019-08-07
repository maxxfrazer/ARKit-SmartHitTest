Pod::Spec.new do |s|
  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "SmartHitTest"
  s.version      = "2.0.0"
  s.summary      = "SmartHitTest allows users to get a pretty good estimate of a hitTest on vertical or horizontal planes"
  s.description  = <<-DESC
            🎉 Now working with both SceneKit and RealityKit 🎉
  					SmartHitTest allows users to get a pretty good estimate of a hitTest on vertical or horizontal planes.
            This function is only a slight alteration of Apple's code found at this location:
            https://developer.apple.com/documentation/arkit/handling_3d_interaction_and_ui_controls_in_augmented_reality
                   DESC
  s.homepage     = "https://github.com/maxxfrazer/ARKit-SmartHitTest"
  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = "Max Cobb"
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/maxxfrazer/ARKit-SmartHitTest.git", :tag => "#{s.version}" }
  s.swift_version = '5.0'
  s.ios.deployment_target = '11.0'
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "Sources/SmartHitTest/*.swift"
end
