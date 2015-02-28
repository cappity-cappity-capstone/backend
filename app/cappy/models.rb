module Cappy
  # This module holds all of the ActiveRecord models used by Cappy.
  module Models
    autoload :Device, 'cappy/models/device'
    autoload :State, 'cappy/models/state'
    autoload :Task, 'cappy/models/task'
    autoload :Schedule, 'cappy/models/schedule'
    autoload :TaskComplete, 'cappy/models/task_complete'
  end
end
