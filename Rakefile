require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'sinatra/activerecord/rake'

SHA = `git rev-parse --short HEAD`.strip.freeze

desc 'Run the application specs'
RSpec::Core::RakeTask.new(:spec)

desc 'Run the quality metrics'
RuboCop::RakeTask.new(:quality) do |cop|
  cop.patterns = ['app/**/*.rb', 'spec/**/*.rb']
end

namespace :db do
  desc 'Load the database configuration for Cappy'
  task :load_config do
    ENV['APP_ENV'] ||= 'development'
    ActiveRecord::Base.configurations = YAML.load_file('config/database.yml')
    ActiveRecord::Base.establish_connection(ENV['APP_ENV'].to_sym)
  end
end

task app_environment: 'db:load_config' do
  $LOAD_PATH << File.expand_path('app', '.')
  require 'cappy'
end

desc 'Swaps redis with the container name'
task configure_redis: :app_environment do
  ENV['REDIS_HOST'] ||= 'localhost'
  Resque.redis = Redis.new(host: ENV['REDIS_HOST'])
end

task environment: %w(db:load_config app_environment configure_redis)

desc 'Open a Pry console with the application loaded and database set'
task shell: :environment do
  Pry.config.prompt_name = 'cappy'
  Pry.start
end

desc 'Run the web server'
task web: :environment do
  ENV['RACK_ENV'] = ENV['APP_ENV']
  unicorn_conf = { config_file: 'unicorn.rb' }
  app = Unicorn.builder('config.ru', unicorn_conf)
  Unicorn::HttpServer.new(app, unicorn_conf).start.join
end

desc 'Run the Clockwork worker'
task clockwork: :environment do
  require './config/clock.rb'
  Clockwork.run
end

desc 'Run the Resque queue worker'
task resque: :environment do
  Resque.logger.formatter = Resque::VeryVerboseFormatter.new
  # Queue to work and 1.0 interval when checking queue
  Resque::Worker.new('cappy').work(1.0)
end

desc 'Run the Docker build'
task :docker do
  system("docker build -t backend:#{SHA} .") || fail('Unable to build backend')
  system("docker tag -f backend:#{SHA} backend:latest") || fail('Unable to tag docker image')
end

desc 'Run the specs and quality metrics'
task default: [:spec, :quality]
