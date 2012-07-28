# -*- encoding: utf-8 -*-
# require File.expand_path('../lib/service_discovery/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Richie Vos"]
  gem.email         = ["richie@groupon.com"]
  #gem.description   = %q{TODO: Write a gem description}
  # gem.summary       = "test"
  # gem.homepage      = "http://www.groupon.com"

  gem.files         = Dir['lib/**.rb'] + Dir['spec/**.rb'] + %w(LICENSE README)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "remote_includes"
  gem.require_paths = ["lib"]
  gem.version       = "1.0"

  gem.add_development_dependency("rspec", ">= 1.2.0")
  gem.add_development_dependency("sinatra")
end
