source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.0.beta1'
gem "mongoid", :github => "mongoid/mongoid"
gem 'unicorn'

group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'

  gem 'bourbon'
  gem "neat"

  gem 'uglifier', '>= 1.0.3'
  gem 'compass-rails', github: 'milgner/compass-rails', ref: '1749c06f15dc4b058427e7969810457213647fb8'
  gem 'compass-h5bp'
end

gem 'jquery-rails'
gem 'html5-rails', :github => "servebox/html5-rails"
#gem 'rails-backbone'
gem 'newrelic_rpm'

gem 'sinatra'

gem 'iron_worker_ng'
gem "mechanize", "~> 2.5.1"

gem 'actionpack-page_caching'

group :test do
  gem 'database_cleaner'
  gem 'minitest'
  gem 'mocha'
  gem 'miniskirt' #factories
  gem 'spork-minitest', '~> 0.0.2'
  gem 'vcr'
  gem 'webmock'
end
