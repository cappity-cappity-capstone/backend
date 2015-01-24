$LOAD_PATH << File.expand_path('app', '.')
ENV['APP_ENV'] ||= 'test'

Bundler.require(:default, ENV['APP_ENV'].to_sym)

require 'cappy'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning(&example.method(:run))
  end
end
