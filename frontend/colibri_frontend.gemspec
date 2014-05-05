# encoding: UTF-8
version = File.read(File.expand_path("../../COLIBRI_VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'colibri_frontend'
  s.version     = version
  s.summary     = 'Frontend e-commerce functionality for the Colibri project.'
  s.description = 'Required dependency for Colibri'

  s.required_ruby_version = '>= 1.9.3'
  s.author      = ''
  s.email       = ''
  s.homepage    = ''
  s.rubyforge_project = 'colibri_frontend'

  s.files        = Dir['app/**/*', 'config/**/*', 'lib/**/*', 'db/**/*', 'vendor/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'colibri_api', version
  s.add_dependency 'colibri_core', version

  s.add_dependency 'canonical-rails', '~> 0.0.4'
  s.add_dependency 'jquery-rails', '~> 3.1.0'
  s.add_dependency 'stringex', '~> 1.5.1'

  s.add_development_dependency 'email_spec', '~> 1.2.1'
  s.add_development_dependency 'capybara-accessible'
end
