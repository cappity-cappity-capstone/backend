module Cappy
  # This module holds all of the controllers (which are sinatra applications)
  # for the application.
  module Controllers
    autoload :Base, 'cappy/controllers/base'
    autoload :Devices, 'cappy/controllers/devices'
    autoload :Alerts, 'cappy/controllers/alerts'
    autoload :States, 'cappy/controllers/states'
    autoload :Triggers, 'cappy/controllers/triggers'
    autoload :Broadcast, 'cappy/controllers/broadcast'
    autoload :Schedules, 'cappy/controllers/schedules'
    autoload :Tasks, 'cappy/controllers/tasks'
    autoload :Version, 'cappy/controllers/version'
  end
end
