# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

use_frameworks!
inhibit_all_warnings!
MonkeyTest = 'MonkeyTest'

target 'QuickNews' do
  pod "SwiftMonkeyPaws", '~> 2.1.0', :configurations => ['MonkeyTest']
end

target 'QuickNewsMonkeyTests' do
#  inherit! :search_paths
  pod 'SwiftMonkey', '~> 2.1.0'
end

# create a "MonkeyTest" config in our pods based on the standard "Debug" target
project 'QuickNews', MonkeyTest => :debug

post_install do |installer|
  installer.pods_project.targets.each do |target|
    
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'YES' #For now all targets must have bitcode disabled :-(
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      config.build_settings['SWIFT_VERSION'] = '4.2'

      if target.name == 'Pods-QuickNews'
        target.build_configurations.each do |config|
          if config.name == MonkeyTest
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = [
              '$(inherited)',
              'Monkey=1'
            ]
            config.build_settings['OTHER_SWIFT_FLAGS'] = [
              '$(inherited)',
              '-D MonkeyTest'
            ]
          end
        end
      end
    end
  end
  
  app_project = Xcodeproj::Project.open(Dir.glob("*.xcodeproj")[0])
  app_project.native_targets.each do |target|
    if target.name == 'QuickNews'
      target.build_configurations.each do |config|
        if config.name == MonkeyTest
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = [
            '$(inherited)',
            'Monkey=1'
          ]
          config.build_settings['OTHER_SWIFT_FLAGS'] = [
            '$(inherited)',
            '-D MonkeyTest'
          ]
        end
      end
    end
  end
  app_project.save
end
