# -*- encoding: utf-8 -*-
version = File.read(File.expand_path("../../COLIBRI_VERSION", __FILE__)).strip

Gem::Specification.new do |gem|
  gem.authors       = [""]
  gem.email         = [""]
  gem.description   = %q{Colibri's API}
  gem.summary       = %q{Colibri's API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "colibri_api"
  gem.require_paths = ["lib"]
  gem.version       = version

  gem.add_dependency 'colibri_core', version
  gem.add_dependency 'rabl', '~> 0.9.4.pre1'
  gem.add_dependency 'versioncake', '~> 2.3.1'
end
