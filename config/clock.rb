module Clockwork
  handler do |job|
    Resque.enqueue(job)
  end

  # Sample
  every 10.seconds, Cappy::Services::Broadcast

  every 1.minute, Cappy::Services::Tasks
end
