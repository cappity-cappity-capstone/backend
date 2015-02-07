module Clockwork
  handler do |job|
    Resque.enqueue(job)
  end

  # Sample
  #every 5.seconds, Cappy::Services::Broadcast
end
