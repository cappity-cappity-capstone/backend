$LOAD_PATH << File.expand_path('app', '.')
ENV['APP_ENV'] ||= 'test'

Bundler.require(:default, ENV['APP_ENV'].to_sym)

require 'cappy'

Dir['spec/factories/**/*.rb'].each { |factory| load(factory) }

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
