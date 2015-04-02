module Cappy
  module Presenters
    # This presenter shows a list of tasks and it's schedules
    class Tasks < Base
      attr_reader :tasks

      def initialize(tasks)
        @tasks = Array(tasks)
      end

      def present
        tasks.map do |task|
          task.as_json.merge(schedules: task.schedules.as_json)
        end
      end
    end
  end
end
