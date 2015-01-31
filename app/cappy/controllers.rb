module Cappy
  # This module holds all of the controllers (which are sinatra applications)
  # for the application.
  module Controllers
    autoload :Base, 'cappy/controllers/base'
    autoload :Devices, 'cappy/controllers/devices'
    autoload :Version, 'cappy/controllers/version'
  end
end
