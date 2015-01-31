require 'rake'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'sinatra/activerecord/rake'

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

task environment: 'db:load_config' do
  $LOAD_PATH << File.expand_path('app', '.')
  require 'cappy'
end

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

desc 'Run the specs and quality metrics'
task default: [:spec, :quality]
