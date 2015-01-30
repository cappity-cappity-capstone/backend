module Cappy
  # This module all of the ActiveRecord models used by Cappy.
  module Models
    autoload :Device, 'cappy/models/device'
    autoload :State, 'cappy/models/state'
    autoload :User, 'cappy/models/user'
  end
end
