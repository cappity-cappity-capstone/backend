require 'json'
require 'socket'
require 'set'
Bundler.require(:default, (ENV['APP_ENV'] || 'development').to_sym)

require 'cappy/initializers'

# This module acts as the top-level namespace for the application.
module Cappy
  autoload :Controllers, 'cappy/controllers'
  autoload :Errors, 'cappy/errors'
  autoload :Models, 'cappy/models'
  autoload :Services, 'cappy/services'
  autoload :Presenters, 'cappy/presenters'

  VERSION = '0.0.0'
end
