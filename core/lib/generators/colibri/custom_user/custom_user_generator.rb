module Colibri
  class CustomUserGenerator < Rails::Generators::NamedBase
    include Rails::Generators::ResourceHelpers
    include Rails::Generators::Migration


    desc "Set up a Colibri installation with a custom User class"

    def self.source_paths
      paths = self.superclass.source_paths
      paths << File.expand_path('../templates', __FILE__)
      paths.flatten
    end

    def check_for_constant
      begin
        klass
      rescue NameError
        @shell.say "Couldn't find #{class_name}. Are you sure that this class exists within your application and is loaded?", :red
        exit(1)
      end
    end

    def generate
      migration_template 'migration.rb.tt', "db/migrate/add_colibri_fields_to_custom_user_table.rb"
      template 'authentication_helpers.rb.tt', "lib/colibri/authentication_helpers.rb"

      file_action = File.exist?('config/initializers/colibri.rb') ? :append_file : :create_file
      send(file_action, 'config/initializers/colibri.rb') do
        %Q{
          Rails.application.config.to_prepare do
            require_dependency 'colibri/authentication_helpers'
          end\n}
      end
    end

    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        sleep 1 # make sure to get a different migration every time
        Time.new.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end

    def klass
      class_name.constantize
    end

    def table_name
      klass.table_name
    end

  end
end

