class MigrateOldPreferences < ActiveRecord::Migration
  def up
    migrate_preferences(Colibri::Calculator)
    migrate_preferences(Colibri::PaymentMethod)
    migrate_preferences(Colibri::PromotionRule)
  end

  def down
  end

  private
  def migrate_preferences klass
    klass.reset_column_information
    klass.find_each do |record|
      store = Colibri::Preferences::ScopedStore.new(record.class.name.underscore, record.id)
      record.defined_preferences.each do |key|
        value = store.fetch(key){}
        record.preferences[key] = value unless value.nil?
      end
      record.save!
    end
  end
end
