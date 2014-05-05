require 'ffaker'
require 'pathname'
require 'colibri/sample'

namespace :colibri_sample do
  desc 'Loads sample data'
  task :load => :environment do
    if ARGV.include?("db:migrate")
      puts %Q{
Please run db:migrate separately from colibri_sample:load.

Running db:migrate and colibri_sample:load at the same time has been known to
cause problems where columns may be not available during sample data loading.

Migrations have been run. Please run "rake colibri_sample:load" by itself now.
      }
      exit(1)
    end

    ColibriSample::Engine.load_samples
  end
end


