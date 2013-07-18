# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sewell/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["ssig33"]
  gem.email         = ["mail@ssig33.com"]
  gem.description   = %q{Generator for Groonga's query}
  gem.summary       = %q{Generator for Groonga's query}
  gem.homepage      = "https://github.com/ssig33/sewell"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sewell"
  gem.require_paths = ["lib"]
  gem.version       = Sewell::VERSION

  gem.licenses = ["MIT"]

  gem.add_development_dependency "rspec"  
end
