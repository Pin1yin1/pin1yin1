source 'http://rubygems.org'

gem 'rails', "~> 4.2.0"
gem 'haml'
gem 'sass'
gem 'sass-rails'
group :production do
  gem 'thin'
  gem 'unicorn'
  gem 'uglifier'
end

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

group :development, :test do
  gem 'byebug'
  gem 'foreman'
  gem 'taps'
  gem 'rspec-rails'
end

group :test do
  gem "capybara"
  gem "poltergeist"  # Requires you to install phantomjs; you should use chef (see the server_setup repo)
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem "guard"
  gem "guard-rspec"
  gem 'libnotify'
  gem 'rb-inotify'
end

gem 'acts_as_indexed'
