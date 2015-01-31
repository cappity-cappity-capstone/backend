module Cappy
  module Controllers
    # This controller returns Cappy's version. It can be used on deploys as a
    # live-check URL.
    class Version < Base
      get '/version' do
        [200, { version: Cappy::VERSION }.to_json]
      end
    end
  end
end
