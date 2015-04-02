module Cappy
  module Presenters
    # Base presenter logic
    class Base
      def self.present(*args)
        new(*args).present
      end
    end
  end
end
