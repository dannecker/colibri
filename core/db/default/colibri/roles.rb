Colibri::Role.where(:name => "admin").first_or_create
Colibri::Role.where(:name => "user").first_or_create
