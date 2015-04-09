module Cappy
  # This module holds all of the presenters for formatting responses
  module Presenters
    autoload :Base, 'cappy/presenters/base'
    autoload :Device, 'cappy/presenters/device'
    autoload :Alert, 'cappy/presenters/alert'
    autoload :Tasks, 'cappy/presenters/tasks'
  end
end
