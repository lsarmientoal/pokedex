# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Pokedex' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Reactive
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  
  # Networking
  pod 'Moya/RxSwift', '~> 14.0.0-alpha'
  
  # Resources
  pod 'R.swift'

  target 'PokedexTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxTest'
    pod 'RxBlocking'
    
    pod 'OHHTTPStubs/Swift'
    pod 'Quick'
    pod 'Nimble'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5'
      config.build_settings['LD_NO_PIE'] = 'NO'
    end
  end
end
