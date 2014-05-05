require 'colibri_core'
require 'colibri_api'
require 'colibri_backend'
require 'colibri_frontend'
require 'colibri_sample'

begin
  require 'protected_attributes'
  puts "*" * 75
  puts "[FATAL] Colibri does not work with the protected_attributes gem installed!"
  puts "You MUST remove this gem from your Gemfile. It is incompatible with Colibri."
  puts "*" * 75
  exit
rescue LoadError
end
