# encoding: UTF-8
version = File.read(File.expand_path("../../COLIBRI_VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'colibri_sample'
  s.version     = version
  s.summary     = 'Sample data (including images) for use with Colibri.'
  s.description = 'Required dependency for Colibri'

  s.required_ruby_version = '>= 1.9.3'
  s.author      = ''
  s.email       = ''
  s.homepage    = ''
  s.license     = ''

  s.files        = Dir['lib/**/*', 'db/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'colibri_core', version
end
