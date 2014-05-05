Colibri
=======

```ruby
gem 'colibri', path: ''
gem 'colibri_auth_devise', path: ''
```

In `config/initializers/colibri.rb`:
```ruby
Colibri.user_class = "Colibri::User"
```

```shell
bundle exec rake db:create
bundle exec rake railties:install:migrations
bundle exec rake colibri_auth:install:migrations
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake colibri_auth:admin:create
bundle exec rake colibri_sample:load

DB=mysql bundle exec rake test_colibri
COVERAGE=true bundle exec rspec spec
bundle exec rspec spec
```

Or shortcut using generator:

```shell
rails g colibri:install --migrate=false --sample=false --seed=false
```

