require 'spec_helper'

describe Cappy::Controllers::Broadcast do
  include Rack::Test::Methods

  let(:app) { described_class.new }

  describe 'POST /broadcast/' do
    it 'returns a "200" and kicks off a broadcast' do
      expect(Resque).to receive(:enqueue).with(Cappy::Services::Broadcast)
      post '/broadcast/', {}

      expect(last_response.status).to eq(200)
    end
  end
end
