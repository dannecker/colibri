# Configure Colibri Preferences
Colibri.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false
end

Colibri.user_class = (options[:user_class].blank? ? "Colibri::LegacyUser" : options[:user_class]).inspect
