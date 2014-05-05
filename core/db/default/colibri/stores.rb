# Possibly already created by a migration.
unless Colibri::Store.where(code: 'colibri').exists?
  Colibri::Store.new do |s|
    s.code              = 'colibri'
    s.name              = 'Colibri Demo Site'
    s.url               = 'demo.colibri.com.ua'
    s.mail_from_address = 'colibri@example.com'
  end.save!
end
