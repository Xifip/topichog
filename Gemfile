source 'https://rubygems.org'
gem 'rails', '3.2.6'
gem 'bootstrap-sass', '~> 2.1.0.1'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'gon'
gem 'devise'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-linkedin'
gem 'twitter'
gem 'linkedin'
gem 'koala'
gem 'bitly'
gem 'delayed_job_active_record'
gem 'acts-as-taggable-on', '~>2.2.0'
gem "rmagick"
gem "carrierwave"
gem "mini_magick"
gem "ckeditor", "3.7.1", :git => 'git://github.com/paranoida/ckeditor.git'
gem "best_in_place"
gem "fog"
gem "carrierwave_direct"
gem "sidekiq"
gem "autoscaler"
#gem "aws-s3", :require => 'aws/s3' 
#gem 'aws-sdk'
#sinatra & slim needed for sidekiq web interface
gem 'sinatra', require:false
gem 'slim'
#gem 'sidekiq-failures'
gem 'redis'
gem 'active_attr'
group :development, :test do
gem 'pg', '0.12.2'
#gem 'sqlite3', '1.3.5'
#gem 'ruby-debug19'
gem 'debugger'
end
# Gems used only for assets and not required
# in production environments by default.
group :assets do
gem 'sass-rails', '3.2.4'
gem 'coffee-rails', '3.2.2'
gem 'uglifier', '1.2.3'
gem 'jquery-fileupload-rails'
end
gem 'jquery-rails'
group :test, :development do
gem 'simplecov', :require => false
gem 'rspec-rails', '2.11.0'
gem 'ZenTest'
gem 'guard-rspec', '0.5.5'
gem 'guard-spork', '0.3.2'
gem 'spork', '0.9.0'
end
gem 'annotate', '~> 2.4.1.beta', group: :development
gem "letter_opener", :group => :development
group :test do
gem 'capybara', '1.1.2'
gem 'factory_girl_rails', '1.4.0'
#gem 'factory_girl_rails', '~> 3.3.0'
gem 'cucumber-rails', '1.2.1', require: false
gem 'database_cleaner', '0.7.0'
gem 'rb-notifu', '0.0.4'
#use these on windows not on ubuntu
#gem 'rb-fchange', '0.0.5'
#gem 'win32console', '1.3.0'
end
group :production do
gem 'pg', '0.12.2'
gem 'newrelic_rpm'
end

# use Haml for templates
gem 'haml'


