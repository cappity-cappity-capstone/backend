module Clockwork
  handler do |job|
    Resque.enqueue(job)
  end

  #every(5.seconds, 'JobName') { Trigger Cappy Service here }
end
