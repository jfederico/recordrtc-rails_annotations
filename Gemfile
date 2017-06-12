source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.1.1'
# Use PostgreSQL as the database for Active Record
gem 'pg', '0.20.0'
# Use dotenv to keep database username and password separate and user-changeable
gem 'dotenv-rails', '2.2.1'

# Use to compile SCSS stylesheets
gem 'sass-rails', '5.0.6'
# Use to compile CoffeeScript code
gem 'coffee-rails', '4.2.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '3.2.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '5.0.1'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', '0.12.3'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.7.0'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '0.4.1'
# Use will_paginate to paginate API requests (20 entries per "page", for example)
gem 'will_paginate', '3.1.5'

# Use Bootstrap for SASS
gem 'bootstrap-sass', '3.3.7'
# Use SB Admin 2 rails gem to theme the app
gem 'bootstrap_sb_admin_base_v2', '0.3.6'
# Use jQuery as a JavaScript library
gem 'jquery-rails', '4.3.1'
# Use React as a JavaScript library
gem 'react-rails', '2.2.0'
# Use Lodash as a JavaScript library
gem 'lodash-rails', '4.17.4'

# Use Passenger for serving in production
gem 'passenger', '5.1.4'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

group :development do
  gem 'listen', '3.1.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :development, :test do
  gem 'pry', require: 'pry'
  gem 'byebug', '9.0.6'
  gem 'rspec-rails', '3.6.0'
end

# Use jQuery DataTables for table functionality such as searching
gem 'jquery-datatables', '1.10.15'

gem 'rails_12factor', '0.0.3'

# Use Simple OAuth to build and verify headers
gem 'simple_oauth', '0.2.0'
# Use IMS-LTI and sample Rails LTI app to add LTI features
gem 'ims-lti', '2.0.0.beta.41'
#gem 'ims-lti', git: 'https://github.com/blindsidenetworks/ims-lti.git', ref: 'b213fc81cc87aea76f596fb99e65dfe95d6b212d'
gem 'rails_lti2_provider', git: 'https://github.com/blindsidenetworks/rails_lti2_provider.git', ref: 'b0bd051b505b0b5a894423bb1a3e36969d46095d'

# Use Shrine for file uploads
gem 'shrine', '2.6.1'
# Use AWS SDK for uploading to Amazon S3
#gem 'aws-sdk'
