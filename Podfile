platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

target "SpryExample" do
    target 'SpryExampleTests' do
        inherit! :search_paths

        pod 'Quick'
        pod 'Nimble'
        pod 'Spry', :path => './'
        pod 'Spry+Nimble', :path => './'
    end
end
