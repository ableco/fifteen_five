$LOAD_PATH.push File.expand_path("lib", __dir__)
require "fifteen_five/version"

Gem::Specification.new do |spec|
  spec.name          = "fifteen_five"
  spec.version       = FifteenFive::VERSION
  spec.authors       = ["Able Engineering"]
  spec.email         = ["engineering@able.co"]
  spec.summary       = "FifteenFive - a simple interface for 15Five"
  spec.description   = "FifteenFive is a simple interface to help connect your application to the 15Five API."
  spec.homepage      = "https://github.com/ableco/fifteen_five"
  spec.license       = "Nonstandard"
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.7"

  # Her is used to map a RESTful interface with the 15Five API.
  spec.add_dependency "her", "~> 1.0"
end
