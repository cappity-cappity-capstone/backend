module Cappy
  module Controllers
    # This controller returns Cappy's version. It can be used on deploys as a
    # live-check URL.
    class Version < Sinatra::Base
      get '/version' do
        [200, Cappy::VERSION]
      end
    end
  end
end
