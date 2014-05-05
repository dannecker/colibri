#!/bin/sh

set -e

# Switching Gemfile
set_gemfile(){
  echo "Switching Gemfile..."
  export BUNDLE_GEMFILE="`pwd`/Gemfile"
}

# Target mysql. Override with: `DB=sqlite bash build.sh`
export DB=${DB:-mysql}

# Colibri defaults
echo "Setup Colibri defaults and creating test application..."
bundle check || bundle update
bundle exec rake test_colibri

# Colibri API
echo "Setup Colibri API and running RSpec..."
cd api; set_gemfile; bundle update; bundle exec rspec spec

# Colibri Backend
echo "Setup Colibri Backend and running RSpec..."
cd ../backend; set_gemfile; bundle update; bundle exec rspec spec

# Colibri Core
echo "Setup Colibri Core and running RSpec..."
cd ../core; set_gemfile; bundle update; bundle exec rspec spec

# Colibri Frontend
echo "Setup Colibri Frontend and running RSpec..."
cd ../frontend; set_gemfile; bundle update; bundle exec rspec spec

# Colibri Sample
echo "Setup Colibri Sample and running RSpec..."
cd ../sample; bundle install; bundle exec rake test_colibri; bundle exec rspec spec
