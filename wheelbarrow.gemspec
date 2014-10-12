# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wheelbarrow/version'

Gem::Specification.new do |spec|
  spec.name          = 'wheelbarrow'
  spec.version       = Wheelbarrow::VERSION
  spec.authors       = ['LuckyThirteen']
  spec.email         = ['baloghzsof@gmail.com']
  spec.summary       = 'command-line BitBucket pull requests with ease'
  spec.homepage      = 'https://github.com/LuckyThirteen/wheelbarrow'
  spec.license       = 'GNU GPL v3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3.2'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'nyan-cat-formatter', '~> 0.10.1'
  spec.add_development_dependency 'rubocop', '~> 0.26.1'
end
