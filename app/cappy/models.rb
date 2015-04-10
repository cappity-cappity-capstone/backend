module Cappy
  # This module holds all of the ActiveRecord models used by Cappy.
  module Models
    autoload :Device, 'cappy/models/device'
    autoload :Alert, 'cappy/models/alert'
    autoload :State, 'cappy/models/state'
    autoload :Trigger, 'cappy/models/trigger'
    autoload :Task, 'cappy/models/task'
    autoload :Schedule, 'cappy/models/schedule'
    autoload :TaskComplete, 'cappy/models/task_complete'
  end
end
