# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'Bubbles' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  pod "Texture"#, "2.8"
  pod 'XMPPFramework'
  pod 'XMPPFramework/Swift'
  pod 'IQKeyboardManager'
  pod "PromiseKit", "~> 6.8"
  pod 'JMessageInput', :git => 'https://github.com/Mammadbayli/JMessageInput.git'
end

post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
          config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
          end
      end
  end
