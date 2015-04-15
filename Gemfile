source 'https://rubygems.org'

gem 'rake', '~> 10.4.2'
gem 'sinatra', git: 'https://github.com/sinatra/sinatra'
gem 'activerecord', '~> 4.2.0'
gem 'unicorn', '~> 4.8.3'
gem 'sqlite3', '~> 1.3.10'
gem 'pry', '~> 0.10.1'
gem 'sinatra-activerecord', '~> 2.0.4'
gem 'resque', '~> 1.25.2'
gem 'clockwork', '~> 1.1.0'
gem 'excon', '~> 0.44.3'
gem 'savon', '~> 2.10.0'

group :development, :test do
  gem 'annotate'
  gem 'rspec', '~> 3.1.0'
  gem 'rubocop', '~> 0.28.0'
  gem 'rack-test', '~> 0.6.3'
  gem 'database_cleaner', '~> 1.4.0'
  gem 'factory_girl', '~> 4.5.0'
end

group :production do
  gem 'mysql2', '~> 0.3.18'
end

group :test do
  gem 'fakeredis', '~> 0.5.0'
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.20.4'
end
