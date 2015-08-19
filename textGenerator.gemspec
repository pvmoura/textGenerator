# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'textGenerator/version'

Gem::Specification.new do |spec|
  spec.name          = "textGenerator"
  spec.version       = "0.0.1"
  spec.authors       = ["Pedro Moura"]
  spec.email         = ["pmavfmoura@gmail.com"]

  spec.summary       = %q{Generates 10 ten-word sentences from text files added to the program's called directory}
  spec.description   = %q{}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
