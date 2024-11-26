# frozen_string_literal: true

#
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#




Pod::Spec.new do |s|
  s.name = 'OpenpathMobile'
  s.version = '0.4.6'
  s.summary = 'Openpath SDK.'

  s.description = <<~DESC
    Openpath SDK library.
  DESC

  s.homepage = 'https://openpath.com'
  # A license file is required for CocoaPods.
  s.license = { type: 'All rights reserved', file: 'LICENSE' }
  s.author = 'Openpath'
  # This "source" line is required, but does not apply:
  s.source = { git: 'https://example.org', tag: "v#{s.version}" }

  s.ios.deployment_target = '12.1'
  s.swift_versions = '5'

  s.subspec 'Core' do |core|


    core.vendored_frameworks = 'OpenpathMobile.xcframework'


    core.public_header_files = 'OpenpathMobileAccessCore/OpenpathMobileAccessCore.h'

    core.dependency 'AWSCore', '2.37.2'
    core.dependency 'AWSIoT', '2.37.2'
    core.dependency 'AWSLogs', '2.37.2'

    core.dependency 'OpenSSL-Universal', '~> 1.1.2301'

    core.pod_target_xcconfig = {

      'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'
    }


  end

  # Allegion subspec 
end
