module Cappy
  module Services
    # Service module for creating new triggers
    module Triggers
      include Base

      module_function

      def list(alert, page = nil, count = nil)
        page ||= 0
        count ||= 15
        alert.triggers.order('created_at DESC').limit(count).offset(page * count)
      end

      def read(alert)
        alert.triggers.last
      end

      def create(alert, data)
        wrap_active_record_errors do
          trigger = read(alert)

          if trigger.nil? || trigger.state != data["state"]
            alert.triggers.create!(data)
          end
        end
      end
    end
  end
end
