module Cappy
  # This module contains all of the application specific errors.
  module Errors
    # Never raised, but useful as an application-specific catch-all.
    BaseError = Class.new(::StandardError)

    # Raised when an unknown device_id is referenced.
    NoSuchDevice = Class.new(BaseError)

    # Raised when bad attributes are passed to create or update a device.
    BadDeviceOptions = Class.new(BaseError)

    # Raised when a request cannot be parsed.
    MalformedRequestError = Class.new(BaseError)

    # Raised when duplicated data is created.
    DuplicationError = Class.new(BaseError)
  end
end