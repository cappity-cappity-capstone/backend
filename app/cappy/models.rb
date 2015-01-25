module Cappy
  # This module holds all of the ActiveRecord models used by Cappy.
  module Models
    autoload :Device, 'cappy/models/device'
    autoload :State, 'cappy/models/state'
  end
end
