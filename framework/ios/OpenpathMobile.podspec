# frozen_string_literal: true

Pod::Spec.new do |s|

  s.name = 'OpenpathMobile'
  s.version = '0.6.0'
  s.summary = 'Openpath SDK.'
  s.description = 'Openpath SDK library.'
  s.homepage = 'https://openpath.com'
  # A license file is required for CocoaPods.
  s.license = { type: 'All rights reserved', file: 'LICENSE' }
  s.author = 'Openpath'
  # This "source" line is required, but does not apply:
  s.source = { git: 'https://example.org', tag: "v#{s.version}" }

  s.ios.deployment_target = '14.8.1'
  s.swift_versions = '5'

  s.vendored_frameworks = 'OpenpathMobile.xcframework'

  s.dependency 'AWSCore', '2.41.0'
  s.dependency 'AWSIoT', '2.41.0'
  s.dependency 'AWSLogs', '2.41.0'

  s.dependency 'OpenSSL-Universal', '~> 1.1.2301'

  s.pod_target_xcconfig = {
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES'
  }

end
