# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-advisory-db-check/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-advisory-db-check'
  spec.version       = RubyAdvisoryDbCheck::VERSION
  spec.authors       = ['Torsten Braun']
  spec.email         = ['tbraun@tnt-web-solutions.de']
  spec.summary       = %q{Automatically check the ruby-advisory-db Database for advisories in your installed Gems.}
  spec.description   = %q{
                          This Gem automatically downloads and extracts the ruby-advisory-db Database from Github.
                          Than it uses bundler and rubygems to check for advisories in your installed Gems by
                          executing a rake task.
                       }
  spec.homepage      = 'https://github.com/tbraun89/ruby-advisory-db-check'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake',    '~> 0'

  spec.add_runtime_dependency 'rubyzip', '~> 1.1', '>= 1.1.6'
end
