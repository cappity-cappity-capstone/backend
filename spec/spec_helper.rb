$LOAD_PATH << File.expand_path('app', '.')
ENV['APP_ENV'] ||= 'test'
ENV['RACK_ENV'] ||= ENV['APP_ENV']

Bundler.require(:default, ENV['APP_ENV'].to_sym)

require 'cappy'

Dir['spec/factories/**/*.rb'].each { |factory| load(factory) }
Dir['spec/support/**/*.rb'].each { |support| load(support) }

RSpec.configure do |config|
  config.include(FactoryGirl::Syntax::Methods)

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
