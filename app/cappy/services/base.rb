module Cappy
  module Services
    # Simple base module for utility methods
    module Base
      module_function

      def included(base)
        base.extend(self)
      end

      def wrap_active_record_errors
        yield
      rescue ActiveRecord::UnknownAttributeError, ActiveRecord::RecordInvalid => ex
        raise Errors::BadOptions, ex
      end
    end
  end
end
