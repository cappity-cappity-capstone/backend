module Cappy
  module Presenters
    # This presenter shows an alert and it's triggered state
    class Alert < Base
      attr_reader :alert

      def initialize(alert)
        @alert = alert
      end

      def present
        alert.as_json.merge(state: alert.triggers.last.as_json)
      end
    end
  end
end
