require 'fileutils'

version = ARGV.pop

%w( cmd core api backend frontend sample ).each do |framework|
  puts "Installing #{framework}..."

  Dir.chdir(framework) do
    `gem build colibri_#{framework}.gemspec`
    `gem install colibri_#{framework}-#{version}.gem --no-ri --no-rdoc`
    FileUtils.remove "colibri_#{framework}-#{version}.gem"
  end

end

puts "Installing Colibri..."
  `gem build colibri.gemspec`
  `gem install colibri-#{version}.gem --no-ri --no-rdoc `

  FileUtils.remove "colibri-#{version}.gem"
