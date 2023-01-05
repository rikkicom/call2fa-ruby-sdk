# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rikkicom/call2fa/version'

Gem::Specification.new do |spec|
  spec.version       = Rikkicom::Call2FA::VERSION
  spec.authors       = ['Yehor Smoliakov']
  spec.email         = ['yehor@rikkicom.io']

  spec.name          = 'rikkicom-call2fa'
  spec.summary       = 'Ruby SDK for Call2FA.'
  spec.homepage      = 'https://github.com/rikkicom/call2fa-ruby-sdk'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
