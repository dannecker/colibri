class CreateStoreFromPreferences < ActiveRecord::Migration
  def change
    preference_store = Colibri::Preferences::Store.instance
    if store = Colibri::Store.where(default: true).first
      store.meta_description = preference_store.get('colibri/app_configuration/default_meta_description') {}
      store.meta_keywords    = preference_store.get('colibri/app_configuration/default_meta_keywords') {}
      store.seo_title        = preference_store.get('colibri/app_configuration/default_seo_title') {}
      store.save!
    else
      # we set defaults for the things we now require
      Colibri::Store.new do |s|
        s.name              = preference_store.get 'colibri/app_configuration/site_name' do
          'Colibri Demo Site'
        end
        s.url               = preference_store.get 'colibri/app_configuration/site_url' do
          'demo.colibricommerce.com'
        end
        s.mail_from_address = preference_store.get 'colibri/app_configuration/mails_from' do
          'colibri@example.com'
        end

        s.meta_description = preference_store.get('colibri/app_configuration/default_meta_description') {}
        s.meta_keywords    = preference_store.get('colibri/app_configuration/default_meta_keywords') {}
        s.seo_title        = preference_store.get('colibri/app_configuration/default_seo_title') {}
        s.default_currency = preference_store.get('colibri/app_configuration/currency') {}
        s.code             = 'colibri'
      end.save!
    end
  end
end
