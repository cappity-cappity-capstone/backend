module Cappy
  module Controllers
    # This controller handles starting a CCS UDP broadcast
    class Broadcast < Base
      post '/broadcast/?' do
        status 200
        Resque.enqueue(Cappy::Services::Broadcast)
        {}.to_json
      end
    end
  end
end
