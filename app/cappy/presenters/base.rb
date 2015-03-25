module Cappy
  module Presenters
    class Base
      def self.present(*args)
        new(*args).present
      end
    end
  end
end
