require 'thor'
require 'thor/group'

case ARGV.first
  when 'version', '-v', '--version'
    puts Gem.loaded_specs['colibri_cmd'].version
  when 'extension'
    ARGV.shift
    require 'colibri_cmd/extension'
    ColibriCmd::Extension.start
  else
    ARGV.shift
    require 'colibri_cmd/installer'
    ColibriCmd::Installer.start
end
