# frozen_string_literal: true

require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = package['name']
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']

  s.platform     = :ios, '11.2'

  s.source       = { git: 'https://github.com/author/OpenpathReactNative.git', tag: 'master' }

  s.source_files = [
    'ios/**/*.{m,swift}'
  ]

  s.dependency 'React-Core'

  s.dependency 'OpenpathMobile', '~> 0.6.0'

  s.pod_target_xcconfig = {
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'NO'
  }
end
