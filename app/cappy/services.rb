module Cappy
  # This module holds all of the services Cappy.
  module Services
    autoload :Base, 'cappy/services/base'
    autoload :Devices, 'cappy/services/devices'
    autoload :States, 'cappy/services/states'
    autoload :Broadcast, 'cappy/services/broadcast'
    autoload :Schedules, 'cappy/services/schedules'
    autoload :Tasks, 'cappy/services/tasks'
    autoload :TaskRunner, 'cappy/services/task_runner'
    autoload :CloudClient, 'cappy/services/cloud_client'
    autoload :OpenIgdPort, 'cappy/services/open_igd_port'
    autoload :DispatchState, 'cappy/services/dispatch_state'
  end
end
