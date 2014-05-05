# encoding: UTF-8
version = File.read(File.expand_path('../COLIBRI_VERSION',__FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'colibri'
  s.version     = version
  s.summary     = ''
  s.description = ''

  s.files        = Dir['lib/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'
  s.required_ruby_version     = '>= 1.9.3'
  s.required_rubygems_version = '>= 1.8.23'

  s.author       = ''
  s.email        = ''
  s.homepage     = ''
  s.license      = ''

  s.add_dependency 'colibri_core', version
  s.add_dependency 'colibri_api', version
  s.add_dependency 'colibri_backend', version
  s.add_dependency 'colibri_frontend', version
  s.add_dependency 'colibri_sample', version
  s.add_dependency 'colibri_cmd', version
end
