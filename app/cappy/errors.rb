module Cappy
  # This module contains all of the application specific errors.
  module Errors
    # Never raised, but useful as an application-specific catch-all.
    BaseError = Class.new(::StandardError)

    # Raised when an unknown foreign key is referenced.
    NoSuchObject = Class.new(BaseError)

    # Raised when bad attributes are passed to create or update a model.
    BadOptions = Class.new(BaseError)

    # Raised when a request cannot be parsed.
    MalformedRequestError = Class.new(BaseError)

    # Raised when duplicated data is created.
    DuplicationError = Class.new(BaseError)

    # Superclass for all cloud communication errors.
    CloudError = Class.new(BaseError)

    # Thrown when a 4xx is received from the cloud servers.
    CloudClientError = Class.new(CloudError)

    # Thrown when a 5xx is received from the cloud servers.
    CloudServerError = Class.new(CloudError)
  end
end
