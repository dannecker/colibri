module Colibri
  module TestingSupport
    module Preferences
      # Resets all preferences to default values, you can
      # pass a block to override the defaults with a block
      #
      # reset_colibri_preferences do |config|
      #   config.track_inventory_levels = false
      # end
      #
      def reset_colibri_preferences(&config_block)
        Colibri::Preferences::Store.instance.persistence = false
        Colibri::Preferences::Store.instance.clear_cache

        config = Rails.application.config.colibri.preferences
        configure_colibri_preferences &config_block if block_given?
      end

      def configure_colibri_preferences
        config = Rails.application.config.colibri.preferences
        yield(config) if block_given?
      end

      def assert_preference_unset(preference)
        find("#preferences_#{preference}")['checked'].should be_false
        Colibri::Config[preference].should be_false
      end
    end
  end
end

