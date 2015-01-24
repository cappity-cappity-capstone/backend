Bundler.require(:default, (ENV['APP_ENV'] || 'development').to_sym)

# This module acts as the top-level namespace for the application.
module Cappy
  autoload :Controllers, 'cappy/controllers'
  autoload :Models, 'cappy/models'
  autoload :Services, 'cappy/services'

  VERSION = '0.0.0'
end
