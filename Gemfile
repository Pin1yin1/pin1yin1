source 'https://rubygems.org'

gem 'rails', '~> 8.1.0'
gem 'haml', '~> 7.5'
gem 'sass-rails', '~> 6.0'
gem 'base64'
gem 'mutex_m'
gem 'observer'
gem 'drb'
group :production do
  gem 'thin'
  gem 'unicorn', '~> 6.1'
  gem 'uglifier', '~> 4.2'
end

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mysql2'

group :development, :test do
  gem 'byebug'
  gem 'foreman'
  gem 'rspec-rails', '~> 8.0'
end

group :test do
  gem 'capybara', '~> 3.40'
  gem 'selenium-webdriver', '~> 4.0'
  gem 'puma', '~> 8.1'
  gem 'factory_bot_rails', '~> 6.0'
  gem 'database_cleaner-active_record', '~> 2.0'
  gem 'guard', '~> 2.20'
  gem "guard-rspec"
  gem 'rb-inotify', '~> 0.11'
end

gem 'acts_as_indexed', '~> 0.9'
