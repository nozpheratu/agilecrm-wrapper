# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'agilecrm/version'

Gem::Specification.new do |spec|
  spec.name          = "agilecrm"
  spec.version       = AgileCRM::VERSION
  spec.authors       = ["Cyle"]
  spec.email         = ["cylehunter33@gmail.com"]
  spec.summary       = %q{ Ruby Client to Access Agile CRM Functionality. }
  spec.description   = %q{ Ruby Client to Access Agile CRM Functionality. }
  spec.homepage      = "https://github.com/nozpheratu/agilecrm-ruby-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "webmock"

end
