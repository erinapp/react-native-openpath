# frozen_string_literal: true

Pod::Spec.new do |s|
  s.name = 'OpenpathMobileAllegion'
  s.version = '0.5.0'
  s.summary = 'Allegion support for Openpath SDK.'
  s.description = 'Allegion support for Openpath SDK.'
  s.homepage = 'https://openpath.com'
  # A license file is required for CocoaPods.
  s.license = { type: 'All rights reserved', file: 'LICENSE' }
  s.author = 'Openpath'
  # This "source" line is required, but does not apply:
  s.source = { git: 'https://example.org', tag: "v#{s.version}" }

  s.ios.deployment_target = '13.0'
  s.swift_versions = '5'

  s.vendored_frameworks = %w[ AllegionAccessBLECredential.xcframework
    AllegionAccessHub.xcframework
    AllegionAnalytics.xcframework
    AllegionBLECore.xcframework
    AllegionExtensions.xcframework
    AllegionLogging.xcframework
    AllegionSecurity.xcframework
    AllegionTranslation.xcframework
    Allegion_Access_MobileAccessSDK_iOS.xcframework
    OpenpathMobileAllegion.xcframework ]

  s.dependency 'PromiseKit', '~> 8.0'
  s.dependency 'AmplitudeSwift', '~> 1.11'
  s.dependency 'Analytics', '~> 4.1'
  s.dependency 'CryptoSwift', '~> 1.0'
  s.dependency 'IOSSecuritySuite', '~> 2.0'
  s.dependency 'SwiftCBOR', '= 0.4.5'

  s.dependency 'OpenpathMobile', s.version.version # Depend on the same version as this.
end
