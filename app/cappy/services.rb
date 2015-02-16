module Cappy
  # This module holds all of the services Cappy.
  module Services
    autoload :Base, 'cappy/services/base'
    autoload :Devices, 'cappy/services/devices'
    autoload :States, 'cappy/services/states'
    autoload :Broadcast, 'cappy/services/broadcast'
    autoload :Schedules, 'cappy/services/schedules'
    autoload :CloudService, 'cappy/services/cloud_service'
  end
end
