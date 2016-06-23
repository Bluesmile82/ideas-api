source 'https://rubygems.org'

ruby '2.3.0'
gem 'rails_12factor', group: :production
gem 'puma',           group: :production
gem 'rails', '4.2.6'
gem 'pg', '~> 0.15'
gem 'rails-api'

gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'devise'
gem 'safe-enum', require: 'enum', github: 'mezuka/enum'
gem 'devise_token_auth'
gem 'omniauth'
gem 'figaro'
gem 'rest-client'
gem 'factory_girl_rails'
gem 'faker'
gem 'rack-cors', :require => 'rack/cors'

group :test do
  gem 'database_cleaner'
end

group :development, :test do
  gem 'awesome_print'
  gem 'byebug'
  gem "rspec-rails"
end

group :development do
  gem 'spring'
end

